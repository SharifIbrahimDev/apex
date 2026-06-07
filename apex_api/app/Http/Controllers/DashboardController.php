<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Sale;
use App\Models\Expense;
use App\Models\Service;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function admin(Request $request)
    {
        $today = Carbon::today();
        
        $totalSalesToday = Sale::whereDate('transaction_date', $today)->sum('amount');
        $totalExpensesToday = Expense::whereDate('expense_date', $today)->sum('amount');
        $netProfitToday = $totalSalesToday - $totalExpensesToday;

        $weeklyRevenue = Sale::whereBetween('transaction_date', [Carbon::now()->startOfWeek(), Carbon::now()->endOfWeek()])->sum('amount');
        $monthlyRevenue = Sale::whereMonth('transaction_date', Carbon::now()->month)->whereYear('transaction_date', Carbon::now()->year)->sum('amount');
        $yearlyRevenue = Sale::whereYear('transaction_date', Carbon::now()->year)->sum('amount');

        $topStaff = Sale::select('user_id', DB::raw('SUM(amount) as total_sales'))
            ->groupBy('user_id')
            ->orderByDesc('total_sales')
            ->with('user')
            ->take(5)
            ->get();

        $mostUsedServices = Sale::select('service_id', DB::raw('COUNT(*) as usage_count'), DB::raw('SUM(amount) as total_revenue'))
            ->groupBy('service_id')
            ->orderByDesc('usage_count')
            ->with('service')
            ->take(5)
            ->get();
            
        $recentTransactions = Sale::with(['user', 'service'])
            ->orderByDesc('created_at')
            ->take(10)
            ->get();

        return response()->json([
            'total_sales_today' => $totalSalesToday,
            'total_expenses_today' => $totalExpensesToday,
            'net_profit_today' => $netProfitToday,
            'weekly_revenue' => $weeklyRevenue,
            'monthly_revenue' => $monthlyRevenue,
            'yearly_revenue' => $yearlyRevenue,
            'top_staff' => $topStaff,
            'most_used_services' => $mostUsedServices,
            'recent_transactions' => $recentTransactions,
        ]);
    }

    public function staff(Request $request)
    {
        $user = $request->user();
        $today = Carbon::today();

        $mySalesToday = Sale::where('user_id', $user->id)
            ->whereDate('transaction_date', $today)
            ->count();
            
        $myRevenueToday = Sale::where('user_id', $user->id)
            ->whereDate('transaction_date', $today)
            ->sum('amount');

        $recentActivities = Sale::with('service')
            ->where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->take(10)
            ->get();

        return response()->json([
            'my_sales_today' => $mySalesToday,
            'my_revenue_today' => $myRevenueToday,
            'recent_activities' => $recentActivities,
        ]);
    }
}
