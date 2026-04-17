import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOAddToCartEntity {
  String? groupId;
  String? companyId;
  String? mobileNo;
  String? hedUniqueId;
  String? partyName;
  String? date;
  String? issueSlipNo;
  String? itemId;
  String? quantity;
  String? rate;
  String? discount;
  String? value;
  String? imagePath;
  String? itemName;
  String? gstRate;
  String? cessRate;
  String? gstValue;
  String? cessValue;
  String? netValue;
  String? returnQty;
  String? hsnCode;
  String? unitName;
  String? remark;
  String? totalPoints;
  String? pointsPerUnit;
  String? itemapprovalstatus;
  String? invid;
  String? balancequantity;
  String? soinvapprovalstatus;
  String? approvalRemark;
  String? soinvapprovalRemark;
  String? headerstatus;
  String? businessOpportunityId;
  String? soinvno;

  // ===============================
  //  Reactive & Controller fields
  // ===============================
  late RxString itemapprovalstatusRx;
  late TextEditingController preCloseCtrl;
  late TextEditingController freeQtyCtrl;

  SOAddToCartEntity({
    this.companyId,
    this.mobileNo,
    this.hedUniqueId,
    this.partyName,
    this.date,
    this.issueSlipNo,
    this.itemId,
    this.quantity,
    this.rate,
    this.discount,
    this.value,
    this.imagePath,
    this.itemName,
    this.gstRate,
    this.cessRate,
    this.gstValue,
    this.cessValue,
    this.netValue,
    this.returnQty,
    this.hsnCode,
    this.unitName,
    this.remark,
    this.totalPoints,
    this.pointsPerUnit,
    this.itemapprovalstatus,
    this.approvalRemark,
    this.headerstatus,
    this.businessOpportunityId,
    this.soinvno,
  }) {
    // Initialize reactive & controllers properly
    itemapprovalstatusRx = (itemapprovalstatus ?? "").obs;
    preCloseCtrl = TextEditingController();
    freeQtyCtrl = TextEditingController();
  }

  SOAddToCartEntity.fromMap(Map<String, dynamic> json) {
    groupId = json['group_id'];
    companyId = json['Company_Id'];
    mobileNo = json['Mobile_No'];
    hedUniqueId = json['hed_unique_id'];
    partyName = json['party_name'];
    date = json['date'];
    issueSlipNo = json['issue_slip_no'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    rate = json['rate'];
    discount = json['discount'];
    value = json['value'];
    imagePath = json['image_path'];
    itemName = json['item_name'];
    gstRate = json['gst_rate'];
    cessRate = json['cess_rate'];
    gstValue = json['gst_value'];
    cessValue = json['cess_value'];
    netValue = json['net_value'];
    returnQty = json['return_quantity'];
    hsnCode = json['hsn_code'];
    unitName = json['unit_name'];
    remark = json['remark'];
    pointsPerUnit = json['points_per_unit'];
    totalPoints = json['total_points'];

    itemapprovalstatus = json['so_inv_approval_status'];

    invid = json['inv_id']?.toString();
    balancequantity = json['balance_qty']?.toString();
    // balancequantity = json['balancequantity']?.toString();
    soinvapprovalstatus = json['soinvapprovalstatus']?.toString();
    approvalRemark = json['approval_remark']?.toString();
    soinvapprovalRemark = json['so_approval_remark'].toString();
    headerstatus = json['header_approval_status'].toString();
    // Reactive & controllers
    itemapprovalstatusRx = (itemapprovalstatus ?? "").obs;

    preCloseCtrl = TextEditingController(
      text: json['pre_close']?.toString() ?? "",
    );
    freeQtyCtrl = TextEditingController(
      text: json['free_qty']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'group_id': groupId,
      'company_id': companyId,
      'mobile_no': mobileNo,
      'hed_unique_id': hedUniqueId,
      'item_id': itemId,
      'quantity': quantity,
      'rate': rate,
      'discount': discount,
      'value': value,
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
      'so_inv_no':soinvno//pratiksha p 28-03-2026
    };
  }
}
