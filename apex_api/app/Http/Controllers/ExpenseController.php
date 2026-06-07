<?php

namespace App\Http\Controllers;

use App\Models\Expense;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ExpenseController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $query = Expense::with('user')->orderByDesc('expense_date');
        
        if ($user->role !== 'admin') {
            $query->where('user_id', $user->id);
        }
        
        return response()->json($query->paginate(20));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'amount' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'expense_date' => 'required|date',
        ]);

        $validated['user_id'] = Auth::id();

        $expense = Expense::create($validated);
        return response()->json($expense->load('user'), 201);
    }

    public function show(Expense $expense)
    {
        return response()->json($expense->load('user'));
    }

    public function update(Request $request, Expense $expense)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $expense->user_id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'amount' => 'sometimes|numeric|min:0',
            'description' => 'nullable|string',
            'expense_date' => 'sometimes|date',
        ]);

        $expense->update($validated);
        return response()->json($expense->load('user'));
    }

    public function destroy(Expense $expense)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $expense->user_id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $expense->delete();
        return response()->json(null, 204);
    }
}
