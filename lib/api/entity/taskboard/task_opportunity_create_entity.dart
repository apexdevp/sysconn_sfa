class TaskBizOpportunitiesCreateEntity {
  String? businessOpportunityId;
  String? companyId;
  String? retailerCode;
  String? retailerName;
  int? source;
  String? title;
  String? productCode;
  String? productDesc;
  String? description;
  int? stage;
  int? status;
  int? rate;
  int? qty;
  double? total;
  String? priority;
  String? createdAt;
  String? entryMedium;
  String? taskId;
  String? taskType;
  String? orderId;
  String? productPriceListId;

  TaskBizOpportunitiesCreateEntity({
    this.businessOpportunityId,
    this.companyId,
    this.retailerCode,
    this.retailerName,
    this.source,
    this.title,
    this.productCode,
    this.productDesc,
    this.description,
    this.stage,
    this.status,
    this.rate,
    this.qty,
    this.total,
    this.priority,
    this.createdAt,
    this.entryMedium,
    this.taskId,
    this.taskType,
    this.orderId,
    this.productPriceListId,
  });

  factory TaskBizOpportunitiesCreateEntity.fromJson(Map<String, dynamic> json) {
    return TaskBizOpportunitiesCreateEntity(
      businessOpportunityId: json['businessopportunityid']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      retailerCode: json['retailer_code']?.toString() ?? '',
      retailerName: json['retailer_name']?.toString() ?? '',
      source: json['source'] != null
          ? int.tryParse(json['source'].toString())
          : null,
      title: json['title']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? '',
      productDesc: json['product_desc']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      stage: parseInt(json['stage']),
      status: parseInt(json['status']),
      rate: parseInt(json['rate']),
      qty: parseInt(json['qty']),
      total: parseDouble(json['total']),
      priority: json['priority']?.toString() ?? '',
      createdAt: json['createdat']?.toString() ?? '',
      productPriceListId: json['productpricelistid']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessopportunityid': businessOpportunityId ?? "",
      'company_id': companyId ?? "",
      'retailer_code': retailerCode ?? "",
      'retailer_name': retailerName ?? "",
      'product_code': productCode ?? "",
      'product_desc': productDesc ?? "",
      'source': source?.toString() ?? "0",
      'title': title ?? "",
      'description': description ?? "",
      // 'stage': stage ?? 0,
      // 'status': status ?? 0,
      'stage': stage?.toString(),
      'status': status?.toString(),
      // 'rate': rate ?? 0,
      // 'qty': qty ?? 0,
      "rate": rate?.toString(),
      "qty": qty?.toString(),
      "total": total?.toString(),
      // 'total': total ?? 0.0,
      'priority': priority ?? "",
      'entrymedium': entryMedium ?? "",
      'taskid': taskId ?? "",
      'tasktype': taskType ?? "",
      'orderid': orderId ?? "",

      'productpricelistid': productPriceListId ?? "",
    };
  }
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}


class TaskOpportunitiesCustomerEntity {
  String? companyId;
  String? retailerCode;
  String? retailerName;
   String? priceList;

  TaskOpportunitiesCustomerEntity({
    this.companyId,
    this.retailerCode,
    this.retailerName,
    this.priceList,

  });

  factory TaskOpportunitiesCustomerEntity.fromJson(Map<String, dynamic> json) {
    return TaskOpportunitiesCustomerEntity(
      companyId: json['company_id'],
      retailerCode: json['tally_retailer_code'],
      priceList: json['price_list'],
      retailerName: json['retailer_name'],
    );
  }
}

class TaskOpportunitiesProductEntity {
  String? companyId;
  String? productCode;
  String? productDesc;

  TaskOpportunitiesProductEntity({
    this.companyId,
    this.productCode,
    this.productDesc,
  });

  factory TaskOpportunitiesProductEntity.fromJson(Map<String, dynamic> json) {
    return TaskOpportunitiesProductEntity(
      companyId: json['company_id']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? '',
      productDesc: json['product_desc']?.toString() ?? '',
    );
  }
}

class TaskOpportunitiesPriceListEntity {
  String? companyId;
  String? priceList;
  String? fromDate;
  String? toDate;
  String? itemId;
  double rate;
  double discount;
  double schemeDiscount;
  String? type;

  TaskOpportunitiesPriceListEntity({
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

  factory TaskOpportunitiesPriceListEntity.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return TaskOpportunitiesPriceListEntity(
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

