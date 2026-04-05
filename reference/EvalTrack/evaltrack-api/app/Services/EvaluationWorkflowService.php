<?php

namespace App\Services;

use App\Models\Enrollment;
use App\Models\EvalDetail;
use App\Models\Evaluation;
use App\Models\Grade;
use App\Models\Subject;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class EvaluationWorkflowService
{
    /**
     * Load all grades for student, run {@see EvaluationEngine}, persist evaluations + recommended enrollments.
     *
     * @return array{details: list<array<string, mixed>>, eligible: list<array<string, mixed>>, third_year_standing: bool, evaluation_id: int}
     */
    public function runAndPersist(
        string $studentId,
        ?string $evaluatedBy,
        ?string $academicYear = null,
        ?string $term = null
    ): array {
        $subjects = Subject::query()->where('program', 'BSIT')->orderBy('year_level')->orderBy('semester')->orderBy('code')->get();

        $gradesByCode = Grade::query()
            ->where('student_id', $studentId)
            ->get()
            ->mapWithKeys(fn (Grade $g) => [$g->subject_code => $g->grade !== null ? (float) $g->grade : null])
            ->all();

        $pairs = DB::table('prerequisites')
            ->select('subject_code', 'prerequisite_code')
            ->get()
            ->map(fn ($r) => [$r->subject_code, $r->prerequisite_code])
            ->all();

        $result = EvaluationEngine::run($gradesByCode, $subjects, $pairs);

        $evaluationId = DB::transaction(function () use ($studentId, $evaluatedBy, $academicYear, $term, $result) {
            $evaluation = Evaluation::query()->create([
                'student_id' => $studentId,
                'academic_year' => $academicYear,
                'term' => $term,
                'evaluated_by' => $evaluatedBy,
                'evaluated_at' => now(),
                'status' => 'complete',
            ]);

            foreach ($result['details'] as $row) {
                EvalDetail::query()->create([
                    'evaluation_id' => $evaluation->id,
                    'subject_code' => $row['code'],
                    'grade' => $row['grade'],
                    'passed' => $row['passed'],
                    'prereq_met' => $row['prereq_met'],
                    'enroll_eligible' => $row['enroll_eligible'],
                    'remarks' => $row['remarks'],
                ]);
            }

            Enrollment::query()
                ->where('student_id', $studentId)
                ->where('status', 'recommended')
                ->delete();

            foreach ($result['eligible'] as $row) {
                Enrollment::query()->create([
                    'student_id' => $studentId,
                    'subject_code' => $row['code'],
                    'academic_year' => $academicYear,
                    'term' => $term,
                    'type' => $row['had_failed_attempt'] ? 'retake' : 'new',
                    'status' => 'recommended',
                    'evaluation_id' => $evaluation->id,
                ]);
            }

            User::query()->where('id', $studentId)->update([
                'evaluation_updated_at' => now(),
            ]);

            return $evaluation->id;
        });

        return array_merge($result, ['evaluation_id' => $evaluationId]);
    }
}
