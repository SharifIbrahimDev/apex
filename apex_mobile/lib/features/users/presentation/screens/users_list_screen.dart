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
      appBar: AppBar(title: const Text('System Users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/users/add'),
        child: const Icon(Icons.person_add),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (users) {
          if (users.isEmpty) return const Center(child: Text('No users found.'));
          
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Chip(
                  label: Text(user.role.toUpperCase(), style: const TextStyle(fontSize: 10)),
                  backgroundColor: user.role == 'admin' ? Colors.blue.shade100 : Colors.green.shade100,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
