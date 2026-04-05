<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'string', 'max:50', 'unique:users,id'],
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:100', 'regex:/@jmc\.edu\.ph$/', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'role' => ['required', 'in:student,instructor,admin,dean'],
            'program' => ['nullable', 'string', 'max:20'],
            'year_level' => ['nullable', 'string', 'max:10'],
            'student_type' => ['nullable', 'in:regular,irregular'],
        ]);

        $user = User::create([
            'id' => $validated['id'],
            'name' => $validated['name'],
            'email' => strtolower($validated['email']),
            'password' => Hash::make($validated['password']),
            'role' => $validated['role'],
            'program' => $validated['program'] ?? 'BSIT',
            'year_level' => $validated['year_level'] ?? '1',
            'student_type' => $validated['student_type'] ?? 'regular',
            'status' => 'Active',
            'must_change_password' => $validated['role'] === 'student',
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registration successful.',
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => $this->mapUser($user),
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email_or_id' => ['required', 'string'],
            'password' => ['required', 'string'],
        ]);

        $identity = trim($validated['email_or_id']);

        $user = User::query()
            ->where('email', $identity)
            ->orWhere('id', $identity)
            ->first();

        if (!$user) {
            throw ValidationException::withMessages([
                'email_or_id' => ['Invalid credentials.'],
            ]);
        }

        if ($user->status !== 'Active') {
            return response()->json([
                'success' => false,
                'message' => 'Your account is currently inactive.',
            ], 403);
        }

        // Transition support:
        // 1) Accept proper hashed passwords.
        // 2) Temporarily accept legacy plaintext passwords from old system.
        // 3) Auto-upgrade plaintext to hash after successful login.
        $isHashedMatch = Hash::check($validated['password'], $user->password);
        $isLegacyPlaintextMatch = hash_equals((string) $user->password, $validated['password']);

        if (!$isHashedMatch && !$isLegacyPlaintextMatch) {
            throw ValidationException::withMessages([
                'email_or_id' => ['Invalid credentials.'],
            ]);
        }

        if ($isLegacyPlaintextMatch && !$isHashedMatch) {
            $user->password = Hash::make($validated['password']);
            $user->save();
        }

        $user->last_seen = now();
        $user->save();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful.',
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => $this->mapUser($user),
        ]);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'user' => $this->mapUser($request->user()),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()?->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully.',
        ]);
    }

    private function mapUser(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'program' => $user->program,
            'year_level' => $user->year_level,
            'student_type' => $user->student_type,
            'status' => $user->status,
            'must_change_password' => (bool) $user->must_change_password,
        ];
    }
}
