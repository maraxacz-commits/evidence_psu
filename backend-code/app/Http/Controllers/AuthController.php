<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Registrace nového uživatele
     * 
     * POST /api/register
     */
    public function register(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|string|max:50|unique:users',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'first_name' => 'nullable|string|max:100',
            'last_name' => 'nullable|string|max:100',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:100',
            'zip_code' => 'nullable|string|max:20',
            'country' => 'nullable|string|max:100',
        ]);

        $user = User::create([
            'username' => $validated['username'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'first_name' => $validated['first_name'] ?? null,
            'last_name' => $validated['last_name'] ?? null,
            'phone' => $validated['phone'] ?? null,
            'address' => $validated['address'] ?? null,
            'city' => $validated['city'] ?? null,
            'zip_code' => $validated['zip_code'] ?? null,
            'country' => $validated['country'] ?? 'Czech Republic',
            'is_active' => true,
        ]);

        // Vytvoření API tokenu
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Registrace úspěšná',
            'user' => [
                'id' => $user->id,
                'username' => $user->username,
                'email' => $user->email,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'full_name' => $user->full_name,
            ],
            'token' => $token,
        ], 201);
    }

    /**
     * Přihlášení uživatele
     * 
     * POST /api/login
     */
    public function login(Request $request)
    {
        $validated = $request->validate([
            'login' => 'required|string', // může být username nebo email
            'password' => 'required|string',
        ]);

        // Najdi uživatele podle username nebo emailu
        $user = User::where('username', $validated['login'])
            ->orWhere('email', $validated['login'])
            ->first();

        // Kontrola uživatele a hesla
        if (!$user || !Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'login' => ['Nesprávné přihlašovací údaje.'],
            ]);
        }

        // Kontrola, zda je účet aktivní
        if (!$user->isActive()) {
            throw ValidationException::withMessages([
                'login' => ['Váš účet byl deaktivován. Kontaktujte administrátora.'],
            ]);
        }

        // Smazání starých tokenů (optional - můžeš povolit více zařízení)
        $user->tokens()->delete();

        // Vytvoření nového tokenu
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Přihlášení úspěšné',
            'user' => [
                'id' => $user->id,
                'username' => $user->username,
                'email' => $user->email,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'full_name' => $user->full_name,
            ],
            'token' => $token,
        ]);
    }

    /**
     * Odhlášení uživatele
     * 
     * POST /api/logout
     */
    public function logout(Request $request)
    {
        // Smazání aktuálního tokenu
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Odhlášení úspěšné',
        ]);
    }

    /**
     * Získání informací o přihlášeném uživateli
     * 
     * GET /api/user
     */
    public function user(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => [
                'id' => $user->id,
                'username' => $user->username,
                'email' => $user->email,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'full_name' => $user->full_name,
                'phone' => $user->phone,
                'address' => $user->address,
                'city' => $user->city,
                'zip_code' => $user->zip_code,
                'country' => $user->country,
                'is_active' => $user->is_active,
                'email_verified_at' => $user->email_verified_at,
                'created_at' => $user->created_at,
            ],
        ]);
    }

    /**
     * Aktualizace profilu uživatele
     * 
     * PUT /api/user
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'first_name' => 'nullable|string|max:100',
            'last_name' => 'nullable|string|max:100',
            'phone' => 'nullable|string|max:20',
            'address' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:100',
            'zip_code' => 'nullable|string|max:20',
            'country' => 'nullable|string|max:100',
        ]);

        $user->update($validated);

        return response()->json([
            'message' => 'Profil aktualizován',
            'user' => [
                'id' => $user->id,
                'username' => $user->username,
                'email' => $user->email,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'full_name' => $user->full_name,
                'phone' => $user->phone,
                'address' => $user->address,
                'city' => $user->city,
                'zip_code' => $user->zip_code,
                'country' => $user->country,
            ],
        ]);
    }
}
