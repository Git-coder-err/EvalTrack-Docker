<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasTable('subjects')) {
            Schema::create('subjects', function (Blueprint $table) {
                $table->string('code', 50)->primary();
                $table->string('title', 200);
                $table->unsignedTinyInteger('units');
                $table->string('program', 20)->default('BSIT');
                $table->unsignedTinyInteger('year_level');
                $table->unsignedTinyInteger('semester');
                $table->unsignedTinyInteger('trm')->default(1);
            });
        } elseif (! Schema::hasColumn('subjects', 'trm')) {
            Schema::table('subjects', function (Blueprint $table) {
                $table->unsignedTinyInteger('trm')->default(1)->after('semester');
            });
        }

        if (! Schema::hasTable('prerequisites')) {
            Schema::create('prerequisites', function (Blueprint $table) {
                $table->string('subject_code', 50);
                $table->string('prerequisite_code', 50);
                $table->primary(['subject_code', 'prerequisite_code']);
            });
        }

        if (! Schema::hasTable('subject_standing_requirements')) {
            Schema::create('subject_standing_requirements', function (Blueprint $table) {
                $table->string('subject_code', 50);
                $table->string('standing', 32);
                $table->primary(['subject_code', 'standing']);
            });
        }

        if (! Schema::hasTable('grades')) {
            Schema::create('grades', function (Blueprint $table) {
                $table->id();
                $table->string('student_id', 50);
                $table->string('subject_code', 50);
                $table->decimal('grade', 5, 2)->nullable();
                $table->string('status', 20)->nullable();
                $table->text('remarks')->nullable();
                $table->string('semester_taken', 30)->nullable();
                $table->unique(['student_id', 'subject_code'], 'grades_student_subject_unique');
                $table->index('student_id');
            });
        } else {
            $this->ensureGradesUniqueIndex();
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('grades');
        Schema::dropIfExists('subject_standing_requirements');
        Schema::dropIfExists('prerequisites');
        Schema::dropIfExists('subjects');
    }

    private function ensureGradesUniqueIndex(): void
    {
        if (Schema::getConnection()->getDriverName() !== 'mysql') {
            return;
        }

        $db = Schema::getConnection()->getDatabaseName();
        $exists = DB::selectOne(
            'SELECT COUNT(1) AS c FROM information_schema.statistics WHERE table_schema = ? AND table_name = ? AND index_name = ?',
            [$db, 'grades', 'grades_student_subject_unique']
        );
        if ($exists && (int) $exists->c === 0) {
            try {
                DB::statement('ALTER TABLE grades ADD UNIQUE INDEX grades_student_subject_unique (student_id, subject_code)');
            } catch (\Throwable) {
            }
        }
    }
};
