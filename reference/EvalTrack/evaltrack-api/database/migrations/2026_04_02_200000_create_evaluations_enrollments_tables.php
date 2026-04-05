<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasTable('evaluations')) {
            Schema::create('evaluations', function (Blueprint $table) {
                $table->id();
                $table->string('student_id', 50);
                $table->string('academic_year', 20)->nullable();
                $table->string('term', 20)->nullable();
                $table->string('evaluated_by', 50)->nullable();
                $table->timestamp('evaluated_at')->useCurrent();
                $table->string('status', 20)->default('complete');
                $table->index(['student_id', 'evaluated_at']);
            });
        }

        if (! Schema::hasTable('eval_details')) {
            Schema::create('eval_details', function (Blueprint $table) {
                $table->id();
                $table->foreignId('evaluation_id')->constrained('evaluations')->cascadeOnDelete();
                $table->string('subject_code', 50);
                $table->decimal('grade', 5, 2)->nullable();
                $table->boolean('passed')->default(false);
                $table->boolean('prereq_met')->default(false);
                $table->boolean('enroll_eligible')->default(false);
                $table->string('remarks', 40);
                $table->index('evaluation_id');
            });
        }

        if (! Schema::hasTable('enrollments')) {
            Schema::create('enrollments', function (Blueprint $table) {
                $table->id();
                $table->string('student_id', 50);
                $table->string('subject_code', 50);
                $table->string('academic_year', 20)->nullable();
                $table->string('term', 20)->nullable();
                $table->string('type', 20)->default('new');
                $table->string('status', 20)->default('recommended');
                $table->foreignId('evaluation_id')->nullable()->constrained('evaluations')->nullOnDelete();
                $table->index(['student_id', 'academic_year', 'term'], 'enrollments_student_year_term_idx');
                $table->index('evaluation_id');
            });
        }

        if (Schema::hasTable('users') && ! Schema::hasColumn('users', 'evaluation_updated_at')) {
            Schema::table('users', function (Blueprint $table) {
                $table->timestamp('evaluation_updated_at')->nullable();
            });
        }

        if (Schema::hasTable('grades') && ! Schema::hasColumn('grades', 'academic_year')) {
            Schema::table('grades', function (Blueprint $table) {
                $table->string('academic_year', 20)->nullable()->after('semester_taken');
                $table->string('term', 20)->nullable()->after('academic_year');
            });
        }

    }

    public function down(): void
    {
        if (Schema::hasTable('grades') && Schema::hasColumn('grades', 'academic_year')) {
            Schema::table('grades', function (Blueprint $table) {
                $table->dropColumn(['academic_year', 'term']);
            });
        }

        if (Schema::hasTable('users') && Schema::hasColumn('users', 'evaluation_updated_at')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('evaluation_updated_at');
            });
        }

        Schema::dropIfExists('enrollments');
        Schema::dropIfExists('eval_details');
        Schema::dropIfExists('evaluations');
    }
};
