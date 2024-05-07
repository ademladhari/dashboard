class Category {
  final String id;
  final String name;
  final String language;

  Category({required this.id, required this.name, required this.language});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['\$id'] as String,
      name: json['name'] as String? ?? 'Unnamed Category',
      language: json['language'] as String? ?? 'Unnamed Category',
    );
  }
  @override
  String toString() {
    return 'Category(id: $id, name: $name,language:$language)';
  }
}
