<?php

namespace App\Services;

use Illuminate\Support\Collection;

/**
 * Pure evaluation logic (EvalTrack v4.0). No HTTP, no DB — unit-testable.
 */
final class EvaluationEngine
{
    public const REMARK_COMPLETED = 'Completed';

    public const REMARK_RETAKE = 'Retake';

    public const REMARK_MISSING_PREREQ = 'Missing Prerequisite';

    /**
     * @param  array<string, float|null>  $gradesByCode  Latest numeric grade per subject code (null = not taken / no grade)
     * @param  array<int, array{0: string, 1: string}>  $prerequisitePairs  [subject_code, prerequisite_code]
     * @return array{details: list<array<string, mixed>>, eligible: list<array<string, mixed>>, third_year_standing: bool}
     */
    public static function run(
        array $gradesByCode,
        Collection $subjects,
        array $prerequisitePairs,
        ?float $passingGrade = null
    ): array {
        $min = $passingGrade ?? (float) config('evaltrack.passing_grade', 75);

        $prereqMap = [];
        foreach ($prerequisitePairs as $pair) {
            [$subjectCode, $preCode] = $pair;
            $prereqMap[$subjectCode] ??= [];
            $prereqMap[$subjectCode][] = $preCode;
        }

        $records = [];
        foreach ($subjects as $subject) {
            $code = $subject->code;
            $g = $gradesByCode[$code] ?? null;
            $passed = $g !== null && (float) $g >= $min;
            $records[$code] = [
                'grade' => $g,
                'passed' => $passed,
            ];
        }

        $thirdYearStanding = self::thirdYearStandingMet($records, $subjects);

        $details = [];
        foreach ($subjects as $subject) {
            $code = $subject->code;
            $g = $gradesByCode[$code] ?? null;
            $passed = $g !== null && (float) $g >= $min;
            $prereqMet = self::prerequisitesMetForSubject(
                $code,
                $records,
                $prereqMap,
                $thirdYearStanding
            );

            if ($passed) {
                $remarks = self::REMARK_COMPLETED;
            } elseif (! $prereqMet) {
                $remarks = self::REMARK_MISSING_PREREQ;
            } else {
                $remarks = self::REMARK_RETAKE;
            }

            $enrollEligible = ! $passed && $prereqMet;

            $details[] = [
                'code' => $code,
                'title' => $subject->title,
                'units' => $subject->units,
                'year_level' => $subject->year_level,
                'semester' => $subject->semester,
                'trm' => $subject->trm ?? 1,
                'grade' => $g,
                'passed' => $passed,
                'prereq_met' => $prereqMet,
                'enroll_eligible' => $enrollEligible,
                'remarks' => $remarks,
                'had_failed_attempt' => $g !== null && (float) $g < $min,
            ];
        }

        $eligible = array_values(array_filter($details, fn (array $d) => $d['enroll_eligible']));

        usort($eligible, function (array $a, array $b) {
            return $b['had_failed_attempt'] <=> $a['had_failed_attempt'];
        });

        return [
            'details' => $details,
            'eligible' => $eligible,
            'third_year_standing' => $thirdYearStanding,
        ];
    }

    /**
     * Third Year Standing (CAP 101 / SP 101): ALL courses in Year 1–2 and Year 3 1st & 2nd semesters passed (≥ min).
     */
    private static function thirdYearStandingMet(array $records, Collection $subjects): bool
    {
        $codes = $subjects->filter(function ($s) {
            if ((int) $s->year_level <= 2) {
                return true;
            }
            if ((int) $s->year_level === 3 && (int) $s->semester <= 2) {
                return true;
            }

            return false;
        })->pluck('code')->all();

        foreach ($codes as $code) {
            if (! ($records[$code]['passed'] ?? false)) {
                return false;
            }
        }

        return true;
    }

    /**
     * @param  array<string, list<string>>  $prereqMap
     */
    private static function prerequisitesMetForSubject(
        string $subjectCode,
        array $records,
        array $prereqMap,
        bool $thirdYearStanding
    ): bool {
        if (in_array($subjectCode, ['CAP 101', 'SP 101'], true)) {
            return $thirdYearStanding;
        }

        foreach ($prereqMap[$subjectCode] ?? [] as $pre) {
            if (! ($records[$pre]['passed'] ?? false)) {
                return false;
            }
        }

        return true;
    }
}
