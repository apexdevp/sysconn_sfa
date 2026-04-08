class SOReportEntity {
  String? companyId;
  String? emailid;
  // String? mobileNo;
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
  String? quantity; 
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
  String? userRemark;     // commented bcze it's removed
  String? narration; 
  String? remark; //pratiksha p 07-08-2023 add remark in item so report
  String? soinvapprovalstatus; //pratiksha p 18-11-2024 add soinvapprovalstatus in item so report
  String? salequantity; //pratiksha p 18-11-2024 add salequantity in item so report
  String? balancequantity; //pratiksha p 18-11-2024 add balancequantity in item so report
  String? preclose;
  String? invapprovalRemark;
  String? duedate;

  SOReportEntity({
    this.uniqueId,
    this.invId,
    this.hedUniqueId,
    this.soinvapprovalstatus,
    this.balancequantity,
    this.approvalRemark,
    this.invapprovalRemark,
  });

  SOReportEntity.fromMap(Map<String, dynamic> json) {
    companyId = json['company_id']?.toString();
    emailid = json['email_id']?.toString();
    // mobileNo = json['mobile_no']?.toString();
    uniqueId = json['unique_id']?.toString();
    type = json['type']?.toString();
    partyId = json['party_id']?.toString();
    date = json['date']?.toString();
    time = json['time']?.toString();
    invoiceNo = json['invoice_no']?.toString();
    invId = json['inv_id']?.toString();
    itemId = json['item_id']?.toString();
    itemName = json['item_name']?.toString();
    quantity = json['quantity']?.toString();
    rate = json['rate']?.toString();
    discount = json['discount']?.toString();
    gstRate = json['gst_rate']?.toString();
    cessRate = json['cess_rate']?.toString();
    gstValue = json['gst_value']?.toString();
    cessValue = json['cess_value']?.toString();
    netValue = json['net_value']?.toString();
    value = json['value']?.toString();
    partyName = json['party_name']?.toString();
    hedUniqueId = json['hed_unique_id']?.toString();
    returnQty = json['return_quantity']?.toString();
    vchtypeName = json['vchtype_name']?.toString();
    parent = json['parent']?.toString();
    partyMobileNumber = json['party_mobile_number']?.toString();
    totalAmount = json['total_amount']?.toString();
    salesPerson = json['sales_person']?.toString();
    tallyStatus = json['tally_status']?.toString();
    approver = json['approver']?.toString();
    approverName = json['approver_name']?.toString();
    approvalStatus = json['approval_status']?.toString();
    approvalReason = json['approval_reason']?.toString();
    approvalRemark = json['approval_remark']?.toString();
    userReason = json['user_reason']?.toString();
    userRemark = json['user_remark']?.toString();
    narration = json['narration']?.toString();
    remark = json['remark']?.toString();
    soinvapprovalstatus = json['so_inv_approval_status']?.toString();
    salequantity = json['sales_qty']?.toString();
    balancequantity = json['balance_qty']?.toString();
    preclose = json['pre_close']?.toString();
    invapprovalRemark = json['inv_approval_remark']; //pratiksha p 01-12-2025
    duedate = json['due_date'];//pratiksha p 19-01-2026 add
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    // if (mobileNo != null) {
    //   map['mobile_no'] = mobileNo;
    // }
    if (type != null) {
      map['type'] = type;
    }
    if (partyId != null) {
      map['party_id'] = partyId;
    }
    if (date != null) {
      map['date'] = date;
    }
    if (soinvapprovalstatus != null) {
      //pratiksha p 19-11-2024 add
      map['so_inventory_approval'] = soinvapprovalstatus;
    }
    if (hedUniqueId != null) {
      //pratiksha p 19-11-2024 add
      map['hed_unique_id'] = hedUniqueId;
    }
    //  if (uniqueId != null) { //pratiksha p 19-11-2024 add
    //   map['unique_id'] = uniqueId;
    // }
    if (invId != null) {
      map['unique_id'] = invId;
    }
    if (preclose != null) {
      //pratiksha p 19-11-2024 add
      map['pre_close'] = preclose;
    }
    if (quantity != null) {
      //pratiksha p 19-11-2024 add
      map['quantity'] = quantity;
    }
    if (balancequantity != null) {
      //pratiksha p 19-11-2024 add
      map['balancequantity'] = balancequantity;
    }

    if (approvalRemark != null) {
      map['approval_remark'] = approvalRemark;
    }
    //pratiksha p 17-12-2025 add
    if (duedate != null) {
      map['due_date'] = duedate;
    }

    // if (approvalRemark != null) {
    //   map['approval_remark'] = approvalRemark;
    // }

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
  //   data['user_remark'] = userRemark;    // commented bcze it's removed
  //   data['user_reason'] = userReason;
  //   return data;
  // }
}
