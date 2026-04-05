# EvalTrack Migration — Laravel API (`evaltrack-api`)

This backend runs **alongside** the legacy PHP/HTML app until each module is cut over.

**Stack note:** Your product spec may mention Node/Prisma/React; **this folder is Laravel 12 + MySQL + Sanctum** — same business rules, different implementation.

## Phase 1 — Auth

- Sanctum bearer tokens, `@jmc.edu.ph` rules in registration, legacy-compatible login with password upgrade.

## Phase 2 — Users

- `UserController` + legacy aliases (`get_users`, `update_status`, etc.).

## Phase 3 & v4.0 — Internal evaluation pipeline (no n8n, no external workflow engines)

All evaluation logic runs **inside** PHP:

1. **`EvaluationEngine`** (`app/Services/EvaluationEngine.php`) — pure, testable: pass/fail (≥ `EVALTRACK_PASSING_GRADE`), prerequisite checks, remarks (`Completed` | `Retake` | `Missing Prerequisite`), eligible subjects (retakes first).
2. **Third Year Standing** — all subjects in **Year 1–2** and **Year 3 1st & 2nd semesters** must be passed before `CAP 101` / `SP 101` prerequisites are considered met (implemented in engine, not via n8n).
3. **`EvaluationWorkflowService`** — after grades are saved: persists `evaluations`, `eval_details`, and recommended rows in `enrollments`; sets `users.evaluation_updated_at`.

### Migrations

- `2026_04_02_100000_create_evaltrack_curriculum_tables.php` — subjects, prerequisites, grades, etc.
- `2026_04_02_200000_create_evaluations_enrollments_tables.php` — `evaluations`, `eval_details`, `enrollments`, optional `grades.academic_year` / `term`, `users.evaluation_updated_at`.

### Main API routes (all `auth:sanctum` unless noted)

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/api/grades/save` | **v4 trigger** — same body as `POST /api/evaluations` |
| POST | `/api/evaluations` | Save grades + run pipeline |
| POST | `/api/legacy/save_evaluation` | Legacy alias |
| GET | `/api/student/report?student_id=` | Latest saved evaluation + detail rows |
| GET | `/api/student/enrollment?student_id=` | Recommended enrollment list |
| GET | `/api/students/{id}/enrollment/eligible` | Same enrollment payload (path param) |
| GET | `/api/curriculum/subjects` | BSIT subjects |

### Seed

```powershell
C:\xampp\php\php.exe artisan db:seed --class=BsitCurriculumSeeder
```

Data file: `database/data/bsit_curriculum.php` (prerequisites updated for SF chain, PE 4 → PE 3, etc.).

## Next steps

1. Messaging API (replace `get_messages.php`, …)
2. Optional AI layer (never used for pass/fail or prerequisites)
3. Vue SPA consuming these endpoints

## Run

```powershell
cd c:\xampp\htdocs\EvalTrack\evaltrack-api
C:\xampp\php\php.exe artisan migrate --force
C:\xampp\php\php.exe artisan serve
```
