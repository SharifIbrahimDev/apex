class ServiceModel {
  final int id;
  final int serviceCategoryId;
  final String name;
  final double price;
  final String? description;

  ServiceModel({
    required this.id,
    required this.serviceCategoryId,
    required this.name,
    required this.price,
    this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceCategoryId: json['service_category_id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
    );
  }
}
