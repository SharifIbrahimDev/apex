import '../../services/models/service_model.dart';
import '../../auth/models/user_model.dart';

class SaleModel {
  final int id;
  final int quantity;
  final double amount;
  final String paymentMethod;
  final String? customerName;
  final String? notes;
  final DateTime transactionDate;
  final ServiceModel? service;
  final UserModel? user;

  SaleModel({
    required this.id,
    required this.quantity,
    required this.amount,
    required this.paymentMethod,
    this.customerName,
    this.notes,
    required this.transactionDate,
    this.service,
    this.user,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      quantity: json['quantity'],
      amount: double.parse(json['amount'].toString()),
      paymentMethod: json['payment_method'],
      customerName: json['customer_name'],
      notes: json['notes'],
      transactionDate: DateTime.parse(json['transaction_date']),
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
