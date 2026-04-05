<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CurriculumController;
use App\Http\Controllers\Api\EvaluationController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function (): void {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);
    });
});

Route::middleware('auth:sanctum')->group(function (): void {
    // Modern REST-style endpoints
    Route::get('/users', [UserController::class, 'index']);
    Route::patch('/users/{id}/metadata', [UserController::class, 'updateMetadata']);
    Route::patch('/users/{id}/touch-last-seen', [UserController::class, 'touchLastSeen']);
    Route::delete('/users/{id}', [UserController::class, 'destroy']);

    // Legacy-compatible aliases to allow safe frontend migration
    Route::post('/legacy/get_users', [UserController::class, 'index']);
    Route::post('/legacy/update_status', [UserController::class, 'touchLastSeen']);
    Route::post('/legacy/update_user_metadata', [UserController::class, 'updateMetadata']);
    Route::post('/legacy/delete_user', [UserController::class, 'destroy']);

    Route::get('/evaluations', [EvaluationController::class, 'index']);
    Route::get('/legacy/get_evaluations', [EvaluationController::class, 'index']);
    Route::post('/evaluations', [EvaluationController::class, 'store']);
    Route::post('/grades/save', [EvaluationController::class, 'store']);
    Route::post('/legacy/save_evaluation', [EvaluationController::class, 'store']);
    Route::get('/student/report', [EvaluationController::class, 'latestReport']);
    Route::get('/student/enrollment', [EvaluationController::class, 'studentEnrollment']);
    Route::get('/students/{studentId}/enrollment/eligible', [EvaluationController::class, 'eligible']);
    Route::get('/curriculum/subjects', [CurriculumController::class, 'subjects']);
});
