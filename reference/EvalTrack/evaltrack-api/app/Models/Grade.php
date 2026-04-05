<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Grade extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'student_id',
        'subject_code',
        'grade',
        'status',
        'remarks',
        'semester_taken',
        'academic_year',
        'term',
    ];

    protected function casts(): array
    {
        return [
            'grade' => 'decimal:2',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'student_id', 'id');
    }

    public function subject(): BelongsTo
    {
        return $this->belongsTo(Subject::class, 'subject_code', 'code');
    }
}
