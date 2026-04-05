<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Evaluation;
use App\Models\Grade;
use App\Models\Subject;
use App\Models\User;
use App\Services\EnrollmentEligibilityService;
use App\Services\EvaluationWorkflowService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class EvaluationController extends Controller
{
    public function __construct(
        private EnrollmentEligibilityService $eligibility,
        private EvaluationWorkflowService $workflow
    ) {}

    public function index(Request $request): JsonResponse
    {
        $studentId = $request->query('student_id');
        if ($studentId === null || $studentId === '') {
            return response()->json(['message' => 'student_id is required.'], 422);
        }

        $this->authorizeStudentAccess($request, (string) $studentId);

        $rows = DB::table('grades as g')
            ->join('users as u', 'g.student_id', '=', 'u.id')
            ->leftJoin('subjects as s', 'g.subject_code', '=', 's.code')
            ->where('g.student_id', $studentId)
            ->orderByDesc('g.id')
            ->select([
                'g.student_id',
                'u.name as student_name',
                'u.program',
                'u.year_level',
                'u.student_type',
                'g.subject_code',
                's.title as subject_title',
                'g.grade',
                'g.status',
                'g.remarks as ai_insight',
                'g.semester_taken as sem',
            ])
            ->get();

        return response()->json($rows);
    }

    /**
     * EvalTrack v4.0 — save grades, run internal pipeline, persist evaluations + enrollments (no external workflow tools).
     */
    public function store(Request $request): JsonResponse
    {
        if (! $this->isStaff($request)) {
            return response()->json(['success' => false, 'message' => 'Forbidden.'], 403);
        }

        $validated = $request->validate([
            'studentId' => ['sometimes', 'string'],
            'student_id' => ['sometimes', 'string'],
            'academic_year' => ['nullable', 'string', 'max:20'],
            'term' => ['nullable', 'string', 'max:20'],
            'grades' => ['required', 'array', 'min:1'],
            'grades.*.code' => ['required', 'string', 'max:50'],
            'grades.*.grade' => ['required', 'numeric', 'min:0', 'max:100'],
            'grades.*.sem' => ['nullable', 'string', 'max:30'],
            'grades.*.subject' => ['nullable', 'string', 'max:200'],
        ]);

        $studentId = $validated['studentId'] ?? $validated['student_id'] ?? null;
        if ($studentId === null || $studentId === '') {
            return response()->json(['success' => false, 'message' => 'Invalid payload.'], 422);
        }

        $student = User::query()->where('id', $studentId)->where('role', 'student')->first();
        if (! $student) {
            return response()->json(['success' => false, 'message' => 'Student not found.'], 404);
        }

        $minPass = (float) config('evaltrack.passing_grade', 75);
        $academicYear = $validated['academic_year'] ?? null;
        $term = $validated['term'] ?? null;
        $gradesHasAy = Schema::hasColumn('grades', 'academic_year');

        DB::beginTransaction();
        try {
            foreach ($validated['grades'] as $g) {
                $code = $g['code'];
                if (! Subject::query()->where('code', $code)->exists()) {
                    DB::rollBack();

                    return response()->json([
                        'success' => false,
                        'message' => "Subject code '{$code}' does not exist in the curriculum. Run php artisan db:seed --class=BsitCurriculumSeeder.",
                    ], 422);
                }

                $gradeVal = (float) $g['grade'];
                $status = $gradeVal >= $minPass ? 'Passed' : 'Failed';
                $sem = $g['sem'] ?? '';

                $payload = [
                    'grade' => $gradeVal,
                    'status' => $status,
                    'remarks' => null,
                    'semester_taken' => $sem,
                ];
                if ($gradesHasAy) {
                    $payload['academic_year'] = $academicYear;
                    $payload['term'] = $term;
                }

                Grade::query()->updateOrCreate(
                    [
                        'student_id' => $studentId,
                        'subject_code' => $code,
                    ],
                    $payload
                );
            }
            DB::commit();
        } catch (\Throwable $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Database error: '.$e->getMessage(),
            ], 500);
        }

        $pipeline = $this->workflow->runAndPersist(
            $studentId,
            $request->user()->id,
            $academicYear,
            $term
        );

        $eligible = $this->eligibility->eligibleSubjectsForResponse($student);

        return response()->json([
            'success' => true,
            'message' => 'Evaluations saved and pipeline completed.',
            'evaluation_id' => $pipeline['evaluation_id'],
            'third_year_standing' => $pipeline['third_year_standing'],
            'report' => $pipeline['details'],
            'eligible_subjects' => $eligible,
        ]);
    }

    public function eligible(Request $request, string $studentId): JsonResponse
    {
        $this->authorizeStudentAccess($request, $studentId);

        $student = User::query()->findOrFail($studentId);
        if ($student->role !== 'student') {
            return response()->json(['message' => 'Not a student account.'], 422);
        }

        return response()->json([
            'success' => true,
            'eligible_subjects' => $this->eligibility->eligibleSubjectsForResponse($student),
        ]);
    }

    public function latestReport(Request $request): JsonResponse
    {
        $studentId = $request->query('student_id');
        if ($studentId === null || $studentId === '') {
            return response()->json(['message' => 'student_id is required.'], 422);
        }

        $this->authorizeStudentAccess($request, (string) $studentId);

        $evaluation = Evaluation::query()
            ->where('student_id', $studentId)
            ->orderByDesc('id')
            ->with('details')
            ->first();

        if (! $evaluation) {
            return response()->json([
                'success' => true,
                'evaluation' => null,
                'details' => [],
            ]);
        }

        return response()->json([
            'success' => true,
            'evaluation' => $evaluation->only([
                'id', 'student_id', 'academic_year', 'term', 'evaluated_by', 'evaluated_at', 'status',
            ]),
            'details' => $evaluation->details,
        ]);
    }

    public function studentEnrollment(Request $request): JsonResponse
    {
        $studentId = $request->query('student_id');
        if ($studentId === null || $studentId === '') {
            return response()->json(['message' => 'student_id is required.'], 422);
        }

        $this->authorizeStudentAccess($request, (string) $studentId);

        $student = User::query()->findOrFail($studentId);
        if ($student->role !== 'student') {
            return response()->json(['message' => 'Not a student account.'], 422);
        }

        return response()->json([
            'success' => true,
            'eligible_subjects' => $this->eligibility->eligibleSubjectsForResponse($student),
        ]);
    }

    private function isStaff(Request $request): bool
    {
        return in_array($request->user()->role, ['admin', 'instructor', 'dean'], true);
    }

    private function authorizeStudentAccess(Request $request, string $studentId): void
    {
        $user = $request->user();
        if ($user->id === $studentId) {
            return;
        }
        if ($this->isStaff($request)) {
            return;
        }
        abort(403);
    }
}
