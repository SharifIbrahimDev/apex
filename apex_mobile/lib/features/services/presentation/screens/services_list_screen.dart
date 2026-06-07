import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: const Center(child: Text('Service Management Module')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/services/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
