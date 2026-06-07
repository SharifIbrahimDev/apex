import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/services/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Service'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: servicesAsync.when(
          loading: () => _buildSkeletonLoader(context),
          error: (e, st) => Center(
            key: const ValueKey('error'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load services', style: Theme.of(context).textTheme.titleLarge),
                Text(e.toString(), style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => ref.invalidate(servicesProvider), child: const Text('Retry')),
              ],
            ),
          ),
          data: (services) {
            return RefreshIndicator(
              key: const ValueKey('data'),
              onRefresh: () async => ref.invalidate(servicesProvider),
              child: services.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.design_services_outlined, size: 100, color: Colors.grey.shade300),
                            const SizedBox(height: 24),
                            Text('No services yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Tap the + button to add a service.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                      itemCount: services.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: Icon(Icons.business_center, color: Theme.of(context).colorScheme.primary),
                            ),
                            title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text(service.category?.name ?? 'Uncategorized', style: TextStyle(color: Colors.grey.shade500)),
                            trailing: Text('₦${service.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
