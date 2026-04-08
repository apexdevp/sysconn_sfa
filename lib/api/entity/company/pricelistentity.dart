class PriceListEntity {
  String? itemid;
  String? companyid;
  String? pricelist;
  String? fromDate;
  double? pricelistrate;
  double? discount;
  String? itemname;

  PriceListEntity();

  PriceListEntity.fromMap(Map<String, dynamic> map) {
    itemid = map['item_id'];
    companyid = map['company_id'];
    pricelist = map['pricelist'];
    fromDate = map['from_date'];
    pricelistrate = map['pricelistrate'] == ''?0.0:double.parse(map['pricelistrate']);
    discount = map['discount'] == ''?0.0:double.parse(map['discount']);
    itemname = map['item_name'];
  }

}