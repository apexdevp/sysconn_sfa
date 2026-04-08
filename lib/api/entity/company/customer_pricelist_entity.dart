class CustomerPricelistEntity {
  String? priceListName;
  String? itemId;
  String? type;
  String? rate;
  String? discount;
  String? fromDate;
  String? toDate;

  CustomerPricelistEntity({
    this.priceListName,
    this.itemId,
    this.type,
    this.rate,
    this.discount,
    this.fromDate,
    this.toDate,
  });

  factory CustomerPricelistEntity.fromJson(Map<String, dynamic> json) {
    return CustomerPricelistEntity(
      priceListName: json['pricelist'],
      itemId: json['item_id'],
      type: json['type'],
      rate: json['rate'],
      discount: json['discount'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
    );
  }
}
