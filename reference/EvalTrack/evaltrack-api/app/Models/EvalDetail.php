<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class EvalDetail extends Model
{
    protected $table = 'eval_details';

    public $timestamps = false;

    protected $fillable = [
        'evaluation_id',
        'subject_code',
        'grade',
        'passed',
        'prereq_met',
        'enroll_eligible',
        'remarks',
    ];

    protected function casts(): array
    {
        return [
            'grade' => 'decimal:2',
            'passed' => 'boolean',
            'prereq_met' => 'boolean',
            'enroll_eligible' => 'boolean',
        ];
    }

    public function evaluation(): BelongsTo
    {
        return $this->belongsTo(Evaluation::class);
    }
}
