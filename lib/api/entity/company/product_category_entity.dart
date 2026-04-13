class ProductCategoryEntity {
  final String id;
  final String name;

  ProductCategoryEntity({required this.id, required this.name});

  factory ProductCategoryEntity.fromJson(Map<String, dynamic> json) {
    return ProductCategoryEntity(
      id: (json['categoryid'] ?? '').toString().trim(),
      name: json['name'] ?? '',
    );
  }
}

class ProductSubCategoryEntity {
  final String id;
  final String name;
  final String parentCategoryId;

  ProductSubCategoryEntity({
    required this.id,
    required this.name,
    required this.parentCategoryId,
  });

  factory ProductSubCategoryEntity.fromJson(Map<String, dynamic> json) {
    return ProductSubCategoryEntity(
      id: (json['subcategoryid'] ?? '').toString().trim(),
      name: json['name'] ?? '',
      parentCategoryId: (json['categoriesid'] ?? '').toString().trim(),
    );
  }
}
