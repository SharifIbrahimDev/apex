<?php

namespace App\Http\Controllers;

use App\Models\Sale;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SaleController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $query = Sale::with(['user', 'service'])->orderByDesc('transaction_date');
        
        if ($user->role !== 'admin') {
            $query->where('user_id', $user->id);
        }
        
        return response()->json($query->paginate(20));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'quantity' => 'required|integer|min:1',
            'amount' => 'required|numeric|min:0',
            'payment_method' => 'required|in:Cash,POS,Transfer',
            'customer_name' => 'nullable|string|max:255',
            'notes' => 'nullable|string',
            'transaction_date' => 'required|date',
        ]);

        $validated['user_id'] = Auth::id();

        $sale = Sale::create($validated);
        return response()->json($sale->load(['user', 'service']), 201);
    }

    public function show(Sale $sale)
    {
        return response()->json($sale->load(['user', 'service']));
    }

    public function update(Request $request, Sale $sale)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $sale->user_id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $validated = $request->validate([
            'service_id' => 'sometimes|exists:services,id',
            'quantity' => 'sometimes|integer|min:1',
            'amount' => 'sometimes|numeric|min:0',
            'payment_method' => 'sometimes|in:Cash,POS,Transfer',
            'customer_name' => 'nullable|string|max:255',
            'notes' => 'nullable|string',
            'transaction_date' => 'sometimes|date',
        ]);

        $sale->update($validated);
        return response()->json($sale->load(['user', 'service']));
    }

    public function destroy(Sale $sale)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $sale->user_id) {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $sale->delete();
        return response()->json(null, 204);
    }
}
