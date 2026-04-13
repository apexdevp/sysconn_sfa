class ProductUOMEntity {
  String? pUnitId;
  String? pUnitName;

  ProductUOMEntity({this.pUnitId, this.pUnitName});

  ProductUOMEntity copyWith({String? pUnitId, String? pUnitName}) =>
      ProductUOMEntity(
        pUnitId: pUnitId ?? this.pUnitId,
        pUnitName: pUnitName ?? this.pUnitName,
      );

  factory ProductUOMEntity.fromJson(Map<String, dynamic> json) =>
      ProductUOMEntity(
        pUnitId: json["categoryid"]?.toString().trim(),
        pUnitName: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "categorytypeid": pUnitId,
    "name": pUnitName,
  };
}
