class CustomerCategoryEntity {
  String? categoryId;
  String? name;

  CustomerCategoryEntity({this.categoryId, this.name});

  CustomerCategoryEntity copyWith({String? categoryId, String? name}) => CustomerCategoryEntity(
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
  );

  factory CustomerCategoryEntity.fromJson(Map<String, dynamic> json) => CustomerCategoryEntity(
    categoryId: json["categoryid"]?.toString().trim(),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {"categoryid": categoryId, "name": name};
}
