<?php

namespace Tests\Unit;

use App\Models\Subject;
use App\Services\EvaluationEngine;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class EvaluationEngineTest extends TestCase
{
    #[Test]
    public function it_marks_completed_when_passed(): void
    {
        $subjects = collect([
            new Subject([
                'code' => 'IT 101',
                'title' => 'Intro',
                'units' => 3,
                'year_level' => 1,
                'semester' => 1,
                'trm' => 1,
                'program' => 'BSIT',
            ]),
        ]);

        $result = EvaluationEngine::run(
            ['IT 101' => 80.0],
            $subjects,
            [],
            75.0
        );

        $this->assertTrue($result['details'][0]['passed']);
        $this->assertSame(EvaluationEngine::REMARK_COMPLETED, $result['details'][0]['remarks']);
    }

    #[Test]
    public function third_year_standing_requires_all_y1_y2_y3s1s2_passed(): void
    {
        $subjects = collect([
            $this->makeSubject('GE 10', 1, 1),
            $this->makeSubject('CAP 101', 3, 3),
        ]);

        $result = EvaluationEngine::run(
            ['GE 10' => 50.0],
            $subjects,
            [],
            75.0
        );

        $this->assertFalse($result['third_year_standing']);
    }

    private function makeSubject(string $code, int $year, int $sem): Subject
    {
        return new Subject([
            'code' => $code,
            'title' => 'T',
            'units' => 3,
            'year_level' => $year,
            'semester' => $sem,
            'trm' => 1,
            'program' => 'BSIT',
        ]);
    }
}
