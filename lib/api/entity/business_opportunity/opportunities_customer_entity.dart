class OpportunitiesCustomerEntity {
  String? companyId;
  String? retailerCode;
  String? retailerName;
  String? priceList;

  OpportunitiesCustomerEntity({
    this.companyId,
    this.retailerCode,
    this.retailerName,
    this.priceList,
  });

  factory OpportunitiesCustomerEntity.fromJson(Map<String, dynamic> json) {
    return OpportunitiesCustomerEntity(
      companyId: json['company_id'],
      retailerCode: json['tally_retailer_code'],
      retailerName: json['retailer_name'],
      priceList: json['price_list'],
    );
  }
}
