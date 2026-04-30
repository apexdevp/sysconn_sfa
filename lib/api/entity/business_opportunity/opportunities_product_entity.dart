class OpportunitiesProductEntity {
  String? companyId;
  String? productCode;
  String? productDesc;

  OpportunitiesProductEntity({
    this.companyId,
    this.productCode,
    this.productDesc,
  });

  factory OpportunitiesProductEntity.fromJson(Map<String, dynamic> json) {
    return OpportunitiesProductEntity(
      companyId: json['company_id']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? '',
      productDesc: json['product_desc']?.toString() ?? '',
    );
  }
}

class OpportunitiesPriceListEntity {
  String? companyId;
  String? priceList;
  String? fromDate;
  String? toDate;
  String? itemId;
  double rate;
  double discount;
  double schemeDiscount;
  String? type;

  OpportunitiesPriceListEntity({
    this.companyId,
    this.priceList,
    this.fromDate,
    this.toDate,
    this.itemId,
    required this.rate,
    required this.discount,
    required this.schemeDiscount,
    this.type,
  });

  factory OpportunitiesPriceListEntity.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OpportunitiesPriceListEntity(
      companyId: json['company_id']?.toString() ?? '',
      priceList: json['pricelist']?.toString() ?? '',
      fromDate: json['from_date']?.toString() ?? '',
      toDate: json['to_date']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      rate: parseDouble(json['rate']),
      discount: parseDouble(json['discount']),
      schemeDiscount: parseDouble(json['scheme_discount']),
      type: json['type']?.toString() ?? '',
    );
  }
}
