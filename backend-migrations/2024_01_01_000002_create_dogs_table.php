<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('dogs', function (Blueprint $table) {
            $table->id();
            $table->string('registration_number', 50)->unique()->nullable();
            $table->string('name', 100);
            $table->string('breed', 100);
            $table->string('color', 50)->nullable();
            $table->enum('gender', ['male', 'female']);
            $table->date('date_of_birth');
            $table->date('date_of_death')->nullable();
            $table->string('microchip_number', 50)->nullable();
            $table->string('tattoo_number', 50)->nullable();
            $table->text('health_notes')->nullable();
            $table->string('titles')->nullable();
            $table->string('photo_url')->nullable();
            
            // Self-referencing foreign keys pro rodiče
            $table->foreignId('father_id')->nullable()->constrained('dogs')->nullOnDelete();
            $table->foreignId('mother_id')->nullable()->constrained('dogs')->nullOnDelete();
            
            // Kdo psa vytvořil v systému
            $table->foreignId('created_by')->constrained('users')->cascadeOnDelete();
            
            $table->timestamps();
            
            $table->index('registration_number');
            $table->index('father_id');
            $table->index('mother_id');
            $table->index('created_by');
            $table->index('breed');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dogs');
    }
};
