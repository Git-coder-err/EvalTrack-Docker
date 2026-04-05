<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    public $incrementing = false;

    protected $keyType = 'string';

    protected $primaryKey = 'code';

    public $timestamps = false;

    protected $fillable = [
        'code',
        'title',
        'units',
        'program',
        'year_level',
        'semester',
        'trm',
    ];

    protected function casts(): array
    {
        return [
            'units' => 'integer',
            'year_level' => 'integer',
            'semester' => 'integer',
            'trm' => 'integer',
        ];
    }
}
