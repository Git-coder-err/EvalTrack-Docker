<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Subject;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CurriculumController extends Controller
{
    public function subjects(Request $request): JsonResponse
    {
        $q = Subject::query()->where('program', $request->query('program', 'BSIT'));

        if ($request->filled('year_level')) {
            $q->where('year_level', (int) $request->query('year_level'));
        }
        if ($request->filled('semester')) {
            $q->where('semester', (int) $request->query('semester'));
        }

        $rows = $q->orderBy('year_level')->orderBy('semester')->orderBy('code')->get();

        return response()->json($rows);
    }
}
