<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'username',
        'email',
        'password',
        'first_name',
        'last_name',
        'phone',
        'address',
        'city',
        'zip_code',
        'country',
        'is_active',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
        'password' => 'hashed',
    ];

    /**
     * Vztah k psům přes user_dogs
     */
    public function dogs()
    {
        return $this->belongsToMany(Dog::class, 'user_dogs')
            ->withPivot('ownership_type', 'from_date', 'to_date', 'notes')
            ->withTimestamps();
    }

    /**
     * Psi, které uživatel vytvořil v systému
     */
    public function createdDogs()
    {
        return $this->hasMany(Dog::class, 'created_by');
    }

    /**
     * Kontrola, zda je účet aktivní
     */
    public function isActive(): bool
    {
        return $this->is_active;
    }

    /**
     * Vrátí celé jméno
     */
    public function getFullNameAttribute(): string
    {
        return trim("{$this->first_name} {$this->last_name}");
    }
}
