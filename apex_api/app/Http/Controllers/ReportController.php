<?php

namespace App\Http\Controllers;

use App\Models\Report;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ReportController extends Controller
{
    public function index()
    {
        $reports = Report::with('user:id,name')->orderByDesc('created_at')->paginate(20);
        return response()->json($reports);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'report_type' => 'required|in:Daily,Weekly,Monthly,Yearly',
            'file_path' => 'required|string',
        ]);

        $validated['generated_by'] = Auth::id();

        $report = Report::create($validated);
        return response()->json($report->load('user'), 201);
    }

    public function show(Report $report)
    {
        return response()->json($report->load('user'));
    }

    public function destroy(Report $report)
    {
        $report->delete();
        return response()->json(null, 204);
    }
}
