<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class BsitCurriculumSeeder extends Seeder
{
    public function run(): void
    {
        $data = require database_path('data/bsit_curriculum.php');

        foreach ($data['subjects'] as $row) {
            DB::table('subjects')->updateOrInsert(
                ['code' => $row['code']],
                [
                    'title' => Str::limit($row['title'], 100, ''),
                    'units' => $row['units'],
                    'program' => 'BSIT',
                    'year_level' => $row['year_level'],
                    'semester' => $row['semester'],
                    'trm' => $row['trm'],
                ]
            );
        }

        DB::table('prerequisites')->delete();

        foreach ($data['prerequisites'] as $pair) {
            DB::table('prerequisites')->insert([
                'subject_code' => $pair[0],
                'prerequisite_code' => $pair[1],
            ]);
        }

        if (Schema::hasTable('subject_standing_requirements')) {
            DB::table('subject_standing_requirements')->delete();
        }
    }
}
