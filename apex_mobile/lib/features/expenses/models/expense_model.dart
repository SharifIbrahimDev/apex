import '../../auth/models/user_model.dart';

class ExpenseModel {
  final int id;
  final String title;
  final double amount;
  final String? description;
  final DateTime expenseDate;
  final UserModel? user;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    this.description,
    required this.expenseDate,
    this.user,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      amount: double.parse(json['amount'].toString()),
      description: json['description'],
      expenseDate: DateTime.parse(json['expense_date']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
