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
        Schema::create('pedigree_exports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('dog_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('template_id')->constrained('pedigree_templates')->cascadeOnDelete();
            $table->string('file_path');
            $table->timestamp('generated_at')->useCurrent();
            $table->timestamps();
            
            $table->index('dog_id');
            $table->index('user_id');
            $table->index('generated_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pedigree_exports');
    }
};
