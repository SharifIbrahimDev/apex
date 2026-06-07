<?php

namespace App\Http\Controllers;

use App\Models\ServiceCategory;
use Illuminate\Http\Request;

class ServiceCategoryController extends Controller
{
    public function index()
    {
        return response()->json(ServiceCategory::all());
    }

    public function store(Request $request)
    {
        if (\Illuminate\Support\Facades\Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $category = ServiceCategory::create($validated);
        return response()->json($category, 201);
    }

    public function show(ServiceCategory $serviceCategory)
    {
        return response()->json($serviceCategory);
    }

    public function update(Request $request, ServiceCategory $serviceCategory)
    {
        if (\Illuminate\Support\Facades\Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'nullable|string',
        ]);

        $serviceCategory->update($validated);
        return response()->json($serviceCategory);
    }

    public function destroy(ServiceCategory $serviceCategory)
    {
        if (\Illuminate\Support\Facades\Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized action.'], 403);
        }
        $serviceCategory->delete();
        return response()->json(null, 204);
    }
}
