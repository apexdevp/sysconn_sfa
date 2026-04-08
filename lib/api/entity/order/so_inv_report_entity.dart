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
  String? itemName; //snehal add 06-07-2022 itemName
  String? quantity; //snehal add 06-07-2022 quantity
  String? rate; //snehal add 06-07-2022 rate
  String? gstRate; //pooja/25/08/2022 add party_mobile_no
  String? cessRate;
  String? gstValue;
  String? cessValue;
  String? netValue;
  String? value; //snehal add 06-07-2022 value
  String? discount; //snehal add 06-07-2022 discount
  String? hedUniqueId; //snehal add 13-07-2022 hedUniqueId
  String? returnQty;
  String? vchtypeName; //pooja/25/08/2022 add vchtype_name
  String? parent; //pooja/25/08/2022 add parent
  String? partyMobileNumber; //pooja/25/08/2022 add party_mobile_no
  String? totalAmount;
  String? salesPerson;
  String? tallyStatus;
  String? approver; //snehal 17-11-2022
  String? approverName; //snehal 17-11-2022
  String? approvalStatus; //snehal 17-11-2022
  String? approvalReason; //snehal 17-11-2022
  String? approvalRemark; //snehal 17-11-2022
  String? userReason; //snehal 17-11-2022
  String? userRemark; //snehal 17-11-2022    // komal // 12-6-2023 // commented bcze it's removed
  String? narration;    // komal // 15-6-2023 // new node added as remark in so report
  String? remark; //pratiksha p 07-08-2023 add remark in item so report
  TextEditingController? salesQtyController;
  String? productremark;
  String?productremark2;
  String?productremark3;
  String? leadpriority;
  String? nextfollowupdate;

  SOInvReportEntity();

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
    rate = json['rate'];
    discount = json['discount'];
    gstRate = json['gst_rate']; //pooja/25/08/2022 add gst
    cessRate = json['cess_rate']; //pooja/25/08/2022 add gst
    gstValue = json['gst_value']; //pooja/25/08/2022 add gst
    cessValue = json['cess_value']; //pooja/25/08/2022 add gst
    netValue = json['net_value']; //pooja/25/08/2022 add gst
    value = json['value'];
    partyName = json['party_name'];
    hedUniqueId = json['hed_unique_id'];
    returnQty = json['return_quantity'];
    vchtypeName = json['vchtype_name']; //pooja/25/08/2022 add vchtype_name
    parent = json['parent']; //pooja/25/08/2022 add parent
    partyMobileNumber = json['party_mobile_number']; //pooja/25/08/2022 add party_mobile_no
    totalAmount = json['total_amount'];
    salesPerson = json['sales_person'];
    tallyStatus = json['tally_status']; // Manoj 10-12-2022 Add Tally Status
    approver = json['approver']; //snehal 17-11-2022 add approver
    approverName = json['approver_name']; //snehal 17-11-2022 add approver_name
    approvalStatus = json['approval_status']; //snehal 17-11-2022 add approval_status
    approvalReason = json['approval_reason']; //snehal 17-11-2022 add approval_reason
    approvalRemark = json['approval_remark']; //snehal 17-11-2022 add approval_remark
    userReason = json['user_reason']; //snehal 17-11-2022 add user_reason
    userRemark = json['user_remark']; //snehal 17-11-2022 add user_remark    // komal // 12-6-2023 // commented bcze it's removed
    narration = json['narration'];    // komal // 12-6-2023 // new node added as remark in so report
    remark = json['remark']; //pratiksha p 07-08-2023 add remark in item so report
    salesQtyController = TextEditingController(text: json['quantity']);
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
     if (productremark2 != null) {
      map['product_remark_two'] = productremark2;
    }
     if (productremark3 != null) {
      map['product_remark_three'] = productremark3;
    }
    if (leadpriority != null) {
      map['lead_priority'] = leadpriority;
    }
    if (nextfollowupdate != null) {
      map['next_followup_date'] = nextfollowupdate;
    }
    if (nextfollowupdate != null) {
      map['next_followup_date'] = nextfollowupdate;
    }
    if (quantity != null) {
      map['quantity'] = quantity;
    }
    if (rate != null) {
      map['rate'] = rate;
    }
    if (discount != null) {
      map['discount'] = discount;
    }
    if (hedUniqueId != null) {
      map['hed_unique_id'] = hedUniqueId;
    }
    if (itemId != null) {
      map['item_id'] = itemId;
    }
    if (value != null) {
      map['value'] = value;
    }

    
    return map;
  }
}
