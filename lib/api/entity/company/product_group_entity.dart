class ProductGrpEntity {
  String? pGrpId;
  String? pGrpName;

  ProductGrpEntity({this.pGrpId, this.pGrpName});

  ProductGrpEntity copyWith({String? pGrpId, String? pGrpName}) =>
      ProductGrpEntity(
        pGrpId: pGrpId ?? this.pGrpId,
        pGrpName: pGrpName ?? this.pGrpName,
      );

  factory ProductGrpEntity.fromJson(Map<String, dynamic> json) =>
      ProductGrpEntity(
        pGrpId: json["categoryid"]?.toString().trim(),
        pGrpName: json["name"],
      );

  Map<String, dynamic> toJson() => {"categoryid": pGrpId, "name": pGrpName};
}
