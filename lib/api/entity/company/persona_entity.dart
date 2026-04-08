//Manisha C 18-03-2026 added

class Personacategory {
  String? categoryId;
  String? categoryName;
  List<Subcategory>? subcategories;

  Personacategory({this.categoryId, this.categoryName, this.subcategories});

  factory Personacategory.fromPersonaMap(Map<String, dynamic> json) {
    return Personacategory(
      categoryId: json['categoryid']?.toString(),
      categoryName: json['categoryname'] ?? "",
      subcategories: (json['subcategories'] ?? [])
          .map<Subcategory>((e) => Subcategory.fromMap(e))
          .toList(),
    );
  }
}

class Subcategory {
  String? subCategoryId;
  String? subCategoryName;

  Subcategory({this.subCategoryId, this.subCategoryName});

  factory Subcategory.fromMap(Map<String, dynamic> json) {
    return Subcategory(
      subCategoryId: json['subcategoryid']?.toString(),
      subCategoryName: json['subcategoryname'] ?? "",
    );
  }
}
