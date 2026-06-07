import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/sales_provider.dart';
import '../../../services/providers/services_provider.dart';

class SaleFormScreen extends ConsumerStatefulWidget {
  const SaleFormScreen({super.key});

  @override
  ConsumerState<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends ConsumerState<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedServiceId;
  int _quantity = 1;
  final _amountController = TextEditingController();
  String _paymentMethod = 'Cash';
  final _customerNameController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  void _onServiceSelected(int? serviceId, List<dynamic> services) {
    setState(() {
      _selectedServiceId = serviceId;
      if (serviceId != null) {
        final service = services.firstWhere((s) => s.id == serviceId);
        _amountController.text = (service.price * _quantity).toString();
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedServiceId == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(salesProvider.notifier).addSale({
        'service_id': _selectedServiceId,
        'quantity': _quantity,
        'amount': double.parse(_amountController.text),
        'payment_method': _paymentMethod,
        'customer_name': _customerNameController.text.isEmpty ? null : _customerNameController.text,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'transaction_date': DateTime.now().toIso8601String(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale recorded successfully!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Record Sale')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              servicesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text('Error loading services: $e'),
                data: (services) {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Service'),
                    value: _selectedServiceId,
                    items: services.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                    onChanged: (val) => _onServiceSelected(val, services),
                    validator: (v) => v == null ? 'Please select a service' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onChanged: (val) {
                  final q = int.tryParse(val) ?? 1;
                  setState(() {
                    _quantity = q;
                    if (_selectedServiceId != null) {
                      final service = servicesAsync.value?.firstWhere((s) => s.id == _selectedServiceId);
                      if (service != null) {
                        _amountController.text = (service.price * _quantity).toString();
                      }
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount (₦)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Payment Method'),
                value: _paymentMethod,
                items: ['Cash', 'POS', 'Transfer'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _paymentMethod = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name (Optional)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('SAVE SALE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
