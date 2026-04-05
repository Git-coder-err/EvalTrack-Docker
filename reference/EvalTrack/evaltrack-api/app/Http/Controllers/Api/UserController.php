<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        if (!$this->hasRole($request, ['admin', 'instructor', 'dean'])) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $users = User::query()
            ->select(['id', 'name', 'email', 'role', 'program', 'year_level', 'student_type', 'status', 'last_seen'])
            ->orderBy('name')
            ->get();

        return response()->json($users);
    }

    public function touchLastSeen(Request $request, ?string $id = null): JsonResponse
    {
        $targetId = $id ?? (string) $request->input('user_id');
        if ($targetId === '') {
            return response()->json(['success' => false, 'message' => 'user_id is required.'], 422);
        }

        $actor = $request->user();
        if ($actor->id !== $targetId && !$this->hasRole($request, ['admin', 'instructor', 'dean'])) {
            return response()->json(['message' => 'Forbidden.'], 403);
        }

        $updated = User::query()->where('id', $targetId)->update([
            'last_seen' => now(),
        ]);
        if (!$updated) {
            return response()->json(['success' => false, 'message' => 'User not found.'], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Status updated.',
        ]);
    }

    public function updateMetadata(Request $request, ?string $id = null): JsonResponse
    {
        if (!$this->hasRole($request, ['admin', 'instructor', 'dean'])) {
            return response()->json(['success' => false, 'message' => 'Forbidden.'], 403);
        }

        $validated = $request->validate([
            'program' => ['required', 'string', 'max:20'],
            'year_level' => ['required', 'string', 'max:10'],
            'student_type' => ['required', 'in:regular,irregular'],
        ]);

        $targetId = $id ?? (string) $request->input('id');
        if ($targetId === '') {
            return response()->json(['success' => false, 'message' => 'User ID is required.'], 422);
        }

        $updated = User::query()->where('id', $targetId)->update([
            'program' => $validated['program'],
            'year_level' => $validated['year_level'],
            'student_type' => $validated['student_type'],
        ]);
        if (!$updated) {
            return response()->json(['success' => false, 'message' => 'User not found.'], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'User metadata updated successfully.',
        ]);
    }

    public function destroy(Request $request, ?string $id = null): JsonResponse
    {
        if (!$this->hasRole($request, ['admin'])) {
            return response()->json(['success' => false, 'message' => 'Forbidden.'], 403);
        }

        $targetId = $id ?? (string) $request->input('id');
        if ($targetId === '') {
            return response()->json(['success' => false, 'message' => 'User ID is required.'], 422);
        }

        if ($request->user()->id === $targetId) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot delete your own account.',
            ], 422);
        }

        $deleted = User::query()->where('id', $targetId)->delete();
        if (!$deleted) {
            return response()->json(['success' => false, 'message' => 'User not found.'], 404);
        }

        return response()->json(['success' => true]);
    }

    private function hasRole(Request $request, array $roles): bool
    {
        return in_array($request->user()->role, $roles, true);
    }
}
