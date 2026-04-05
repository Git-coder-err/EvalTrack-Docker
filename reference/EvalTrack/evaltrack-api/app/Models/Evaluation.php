<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Evaluation extends Model
{
    protected $table = 'evaluations';

    public $timestamps = false;

    protected $fillable = [
        'student_id',
        'academic_year',
        'term',
        'evaluated_by',
        'evaluated_at',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'evaluated_at' => 'datetime',
        ];
    }

    public function student(): BelongsTo
    {
        return $this->belongsTo(User::class, 'student_id', 'id');
    }

    public function evaluator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'evaluated_by', 'id');
    }

    public function details(): HasMany
    {
        return $this->hasMany(EvalDetail::class);
    }

    public function enrollments(): HasMany
    {
        return $this->hasMany(Enrollment::class);
    }
}
