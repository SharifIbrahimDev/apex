import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/users_provider.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Users', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/users/add'),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: usersAsync.when(
          loading: () => _buildSkeletonLoader(context),
          error: (e, st) => Center(
            key: const ValueKey('error'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load users', style: Theme.of(context).textTheme.titleLarge),
                Text(e.toString(), style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => ref.invalidate(usersProvider), child: const Text('Retry')),
              ],
            ),
          ),
          data: (users) {
            return RefreshIndicator(
              key: const ValueKey('data'),
              onRefresh: () async => ref.invalidate(usersProvider),
              child: users.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group_off_outlined, size: 100, color: Colors.grey.shade300),
                            const SizedBox(height: 24),
                            Text('No users found', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Tap the + button to add a staff member.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
                      itemCount: users.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isAdmin = user.role == 'admin';
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: isAdmin ? Colors.blue.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                              child: Text(user.name[0].toUpperCase(), style: TextStyle(color: isAdmin ? Colors.blue : Colors.green, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Text(user.email, style: TextStyle(color: Colors.grey.shade500)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isAdmin ? Colors.blue.shade50 : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(user.role.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAdmin ? Colors.blue.shade700 : Colors.green.shade700)),
                            ),
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
