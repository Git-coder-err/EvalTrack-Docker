<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Enrollment extends Model
{
    protected $table = 'enrollments';

    public $timestamps = false;

    protected $fillable = [
        'student_id',
        'subject_code',
        'academic_year',
        'term',
        'type',
        'status',
        'evaluation_id',
    ];

    public function student(): BelongsTo
    {
        return $this->belongsTo(User::class, 'student_id', 'id');
    }

    public function evaluation(): BelongsTo
    {
        return $this->belongsTo(Evaluation::class);
    }
}
