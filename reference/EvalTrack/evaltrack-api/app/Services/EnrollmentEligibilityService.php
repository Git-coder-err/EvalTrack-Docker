<?php

namespace App\Services;

use App\Models\Enrollment;
use App\Models\Grade;
use App\Models\Subject;
use App\Models\User;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class EnrollmentEligibilityService
{
    public function passedSubjectCodes(string $studentId): Collection
    {
        $min = (float) config('evaltrack.passing_grade', 75);

        return Grade::query()
            ->where('student_id', $studentId)
            ->get()
            ->filter(function (Grade $g) use ($min) {
                if ($g->status === 'Passed') {
                    return true;
                }
                if ($g->grade !== null && (float) $g->grade >= $min) {
                    return true;
                }

                return false;
            })
            ->pluck('subject_code')
            ->unique()
            ->values();
    }

    /**
     * Recommended enrollments from DB (after evaluation workflow). Retakes first.
     *
     * @return array<int, array<string, mixed>>
     */
    public function eligibleSubjectsForResponse(User $student): array
    {
        $recommended = Enrollment::query()
            ->where('student_id', $student->id)
            ->where('status', 'recommended')
            ->orderByRaw("CASE WHEN type = 'retake' THEN 0 ELSE 1 END")
            ->orderBy('subject_code')
            ->get();

        if ($recommended->isNotEmpty()) {
            return $recommended->map(function (Enrollment $e) {
                $s = Subject::query()->find($e->subject_code);

                return [
                    'code' => $e->subject_code,
                    'title' => $s?->title,
                    'units' => $s?->units,
                    'year_level' => $s?->year_level,
                    'semester' => $s?->semester,
                    'trm' => $s?->trm,
                    'type' => $e->type,
                    'status' => $e->status,
                ];
            })->values()->all();
        }

        return $this->computeEligibleViaEngine($student);
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function computeEligibleViaEngine(User $student): array
    {
        $subjects = Subject::query()
            ->where('program', 'BSIT')
            ->orderBy('year_level')
            ->orderBy('semester')
            ->orderBy('code')
            ->get();

        $gradesByCode = Grade::query()
            ->where('student_id', $student->id)
            ->get()
            ->mapWithKeys(fn (Grade $g) => [$g->subject_code => $g->grade !== null ? (float) $g->grade : null])
            ->all();

        $pairs = DB::table('prerequisites')
            ->select('subject_code', 'prerequisite_code')
            ->get()
            ->map(fn ($r) => [$r->subject_code, $r->prerequisite_code])
            ->all();

        $result = EvaluationEngine::run($gradesByCode, $subjects, $pairs);

        return collect($result['eligible'])
            ->map(fn (array $row) => [
                'code' => $row['code'],
                'title' => $row['title'],
                'units' => $row['units'],
                'year_level' => $row['year_level'],
                'semester' => $row['semester'],
                'trm' => $row['trm'],
                'type' => $row['had_failed_attempt'] ? 'retake' : 'new',
                'status' => 'recommended',
            ])
            ->values()
            ->all();
    }
}
