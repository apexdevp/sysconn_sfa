import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OpportunitiesDealsRepEntity {
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
  // int? rate;
  double? rate;           //shweta 20-04-26
  int? qty;
  double? total;
  String? priority;
  String? createdAt;
  String? entryMedium;
  String? productPriceListId;
  //pratiksha p 21-03-2026 add for bo tracking
  String? soqty;
  String? sorate;
  String? hedUniqueId;
  String? discount;
  String? gstRate;
  String? cessRate;
  String? gstValue;
  String? cessValue;
  String? netValue;
  String? returnQty;
  String? remark;
  String? balancequantity;
  String? itemapprovalstatus;
  String? soinvapprovalstatus;
  String? approvalRemark;
  String? soinvapprovalRemark;
  String? headerstatus;
  String? invid;
  String? totalvalue;

  String? taskId;
  String? orderId;
  String? taskType;

  String? privateid;        //shweta 20-04-26
  String? rating;
  String? activity;
  String? activityDescription;
  String? updatedat;
  
  
  late RxString itemapprovalstatusRx;
  late TextEditingController preCloseCtrl;
  late TextEditingController freeQtyCtrl;
 
 

  OpportunitiesDealsRepEntity({
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
    this.productPriceListId,
    this.hedUniqueId,
    this.discount,
    this.gstRate,
    this.cessRate,
    this.gstValue,
    this.cessValue,
    this.netValue,
    this.soqty,
    this.sorate,
    this.totalvalue,
    this.taskId,
    this.orderId,
    this.taskType,

    this.privateid,   //shweta 20-04-26
    this.rating,
    this.activity,
    this.activityDescription,
    this.updatedat,


  }){
    // Initialize reactive & controllers properly
    itemapprovalstatusRx = (itemapprovalstatus ?? "").obs;
    preCloseCtrl = TextEditingController();
    freeQtyCtrl = TextEditingController();
  }


  factory OpportunitiesDealsRepEntity.fromJson(Map<String, dynamic> json) {
    return OpportunitiesDealsRepEntity(
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
      // rate: parseInt(json['rate']),
      rate: parseDouble(json['rate']),        //shweta 20-04-26
      qty: parseInt(json['qty']),
      total: parseDouble(json['total']),
      priority: json['priority']?.toString() ?? '',
      createdAt: json['createdat']?.toString() ?? '',
      productPriceListId: json['productpricelistid']?.toString() ?? '',
      taskId: json['taskid']?.toString() ?? '',
      orderId: json['orderid']?.toString() ?? '',
      taskType: json['tasktype']?.toString() ?? '',
      privateid: json['privateid']?.toString() ?? '',      //shweta 20-04-26
      rating: json['rating']?.toString() ?? '',
      activity: json['activity']?.toString() ?? '',
      activityDescription: json['activityDescription']?.toString() ?? '',
      updatedat: json['updatedat']?.toString() ?? '',
    );
  }


  //pratiksha p 26-03-2026 add
  OpportunitiesDealsRepEntity.formBoMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    createdAt = map['date'];
    retailerName = map['party_name'];
    retailerCode = map['retailer_code'];
    productCode = map['item_id'];
    productDesc = map['item_name'];
    soqty = map['quantity'];
    sorate = map['rate'];
    total = parseDouble(map['value']);
    gstRate = map['gst_rate'];
    cessRate = map['cess_rate'];
    businessOpportunityId = map['businessopportunityid'];
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
      'productpricelistid': productPriceListId ?? "",
      'taskid': taskId ?? "",
      'orderid': orderId ?? "",
      'tasktype': taskType ?? "",
      'privateid': privateid ?? "",       //shweta 20-04-26
      'rating': rating ?? "",
      'activity': activity ?? "",
      'activityDescription': activityDescription ?? "",
      'updatedat': updatedat ?? "",
    };
  }

    //pratiksha p 21-03-2026 add for bo tracking
  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'hed_unique_id': hedUniqueId,
      'item_id': productCode,
      'quantity': soqty,
      'rate': sorate,
      'discount': discount,
      'value': totalvalue,
      'gst_rate': gstRate,
      'cess_rate': cessRate,
      'gst_value': gstValue,
      'cess_value': cessValue,
      'net_value': netValue,
      'return_quantity': returnQty,
      'remark': remark,
      'so_approval_status': itemapprovalstatus,
      'pre_close': preCloseCtrl.text,
      'free_qty': freeQtyCtrl.text,
      'inv_id': invid,
      'balancequantity': balancequantity,
      'soinvapprovalstatus': soinvapprovalstatus,
      'approval_remark': approvalRemark,
      'header_approval_status': headerstatus,
      'bo_id':businessOpportunityId
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
