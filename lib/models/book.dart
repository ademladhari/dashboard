class Book {
  final String id;
  final String name;
  final double price;
  final String type;
  final Map<String, dynamic>
      category; // Changed field type to Map<String, dynamic>
  // Changed field type to Map<String, dynamic>
  Book({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.category, // Changed field name to 'category'
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> categoryJson = json['categorie'] ?? {'id': 'unknown'};
    return Book(
      id: json["\$id"] as String? ?? 'default-id',
      name: json['Book-Name'] as String? ?? 'Unnamed Book',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      type: json['Book-Language'] as String? ?? 'Unknown Type',
      category: categoryJson,
    );
  }
}
