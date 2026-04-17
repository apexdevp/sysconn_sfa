import 'package:flutter/material.dart';

class SOInvReportEntity {
  String? companyId;
  String? partnerCode;
  String? mobileNo;
  String? type;
  String? uniqueId;
  String? partyId;
  String? partyName;
  String? date;
  String? time;
  String? invoiceNo;
  // String? issueSlipNo;
  String? invId;
  String? itemId;
  String? itemName; 
  String? quantity; //only for so tracking
  String? qty; 
  String? rate; 
  String? gstRate; 
  String? cessRate;
  String? gstValue;
  String? cessValue;
  String? netValue;
  String? value; 
  String? discount; 
  String? hedUniqueId;
  String? returnQty;
  String? vchtypeName; 
  String? parent; 
  String? partyMobileNumber; 
  String? totalAmount;
  String? salesPerson;
  String? tallyStatus;
  String? approver; 
  String? approverName; 
  String? approvalStatus; 
  String? approvalReason; 
  String? approvalRemark; 
  String? userReason; 
  String? userRemark;    
  String? narration;    
  String? remark; //pratiksha p 07-08-2023 add remark in item so report
  String? unitname;
  String? hsncode;
  TextEditingController? salesQtyController;

  SOInvReportEntity({ this.netValue,this.gstValue,this.value});

  SOInvReportEntity.fromMap(Map<String, dynamic> json) {
    companyId = json['company_id'];
    partnerCode = json['partner_code'];
    mobileNo = json['mobile_no'];
    uniqueId = json['unique_id'];
    type = json['type'];
    partyId = json['party_id'];
    date = json['date'];
    time = json['time'];
    invoiceNo = json['invoice_no'];
    invId = json['inv_id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    quantity = json['quantity'];
    qty = json['qty']; //pratiksha p 25-10-2025 
    rate = json['rate'];
    discount = json['discount'];
    gstRate = json['gst_rate']; 
    cessRate = json['cess_rate']; 
    gstValue = json['gst_value']; 
    cessValue = json['cess_value']; 
    netValue = json['net_value']; 
    value = json['value'];
    partyName = json['party_name'];
    hedUniqueId = json['hed_unique_id'];
    returnQty = json['return_quantity'];
    vchtypeName = json['vchtype_name']; 
    parent = json['parent'];
    partyMobileNumber = json['party_mobile_number'];
    totalAmount = json['total_amount'];
    salesPerson = json['sales_person'];
    tallyStatus = json['tally_status'];
    approver = json['approver']; 
    approverName = json['approver_name']; 
    approvalStatus = json['approval_status']; 
    approvalReason = json['approval_reason']; 
    approvalRemark = json['approval_remark']; 
    userReason = json['user_reason'];
    userRemark = json['user_remark']; 
    narration = json['narration'];  
    remark = json['remark']; //pratiksha p 07-08-2023 add remark in item so report
    salesQtyController = TextEditingController(text: json['quantity']);
    unitname=json['unit'];//pratiksha p 23-01-2026 add this 
    hsncode=json['hsn_code'];//pratiksha p 23-01-2026 add this 
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (partnerCode != null) {
      map['partner_code'] = partnerCode;
    }
    if (mobileNo != null) {
      map['mobile_no'] = mobileNo;
    }
    if (type != null) {
      map['type'] = type;
    }
    if (partyId != null) {
      map['party_id'] = partyId;
    }
    if (date != null) {
      map['date'] = date;
    }
     if (remark != null) {
      map['remark'] = remark;
    }
     if (invId != null) {
      map['inv_id'] = invId;
    }
    
    // if (issueSlipNo != null) {
    //   map['issue_slip_no'] = issueSlipNo;
    // }
    return map;
  }

  // Map<String, dynamic> toSOJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['company_id'] = companyId;
  //   data['approval_status'] = approvalStatus;
  //   data['approval_reason'] = approvalReason;
  //   data['approval_remark'] = approvalRemark;
  //   data['approver'] = approver;
  //   data['user_remark'] = userRemark;    // komal // 12-6-2023 // commented bcze it's removed
  //   data['user_reason'] = userReason;
  //   return data;
  // }
}
