import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';

class SalesOrderHeaderEntity {
  String? companyId;
  String? mobileNo;
  String? voucherType;
  String? voucherTypeName;
  String? uniqueId;
  String? partyId;
  String? partyName;
  String? date;
  // String? issueSlipNo;
  String? narration;
  String? address;
  // String? address1;
  // String? address2;
  // String? address3;
  String? gstin;
  String? partyMobileNo;
  String? state;
  // String? ewbNo;
  String? orderDueDate;
  String? vehicleNo;
  String? lrDate;
  String? despatchedThrough;
  String? mailingName;
  String? shippedToName;
  String? shippedToAddress1;
  String? shippedToAddress2;
  String? shippedToAddress3;
  String? shippedToGstin;
  String? shippedToState;
  List<SOAddToCartEntity>? items;
  String? amount;
  String? invoiceNo;
  String? rateType;
  String? salesPersonName;
  String? userRemark;
  String? approvalRemark;
  String? approvalStatus;
  SalesOrderHeaderEntity();

  SalesOrderHeaderEntity.fromMap(Map<String, dynamic> json) {
    companyId = json['company_id'];
    mobileNo = json['mobile_no'];
    uniqueId = json['unique_id'];
    voucherType = json['voucher_type'];
    partyId = json['party_id'];
    date = json['date'];
    amount = json['amount'] != ''
        ? num.parse(json['amount']).toStringAsFixed(1)
        : '';
    shippedToName = json['shipped_to_name'];
    shippedToAddress1 = json['shipped_to_address_1'];
    shippedToAddress2 = json['shipped_to_address_2'];
    shippedToAddress3 = json['shipped_to_address_3'];
    shippedToGstin = json['shipped_to_gstin'];
    shippedToState = json['shipped_to_state'];
    invoiceNo = json['invoice_no'];
    state = json['state']; // Manoj add state 16-11-2022
    orderDueDate = json['order_due_date']; // Manoj add ewb_date 16-11-2022
  }

  Map<String, dynamic> toBilledToMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (mobileNo != null) {
      map['mobile_no'] = mobileNo;
    }
    if (uniqueId != null) {
      map['unique_id'] = uniqueId;
    }
    if (address != null) {
      map['address'] = address;
    }
    // if (address1 != null) {
    //   map['address_1'] = address1;
    // }
    // if (address2 != null) {
    //   map['address_2'] = address2;
    // }
    // if (address3 != null) {
    //   map['address_3'] = address3;
    // }
    if (gstin != null) {
      map['gstin'] = gstin;
    }
    if (partyMobileNo != null) {
      map['party_mobile_no'] = partyMobileNo;
    }
    if (state != null) {
      map['state'] = state;
    }
    // if (ewbNo != null) {
    //   map['party_mobile_no'] = ewbNo;
    // }
    if (orderDueDate != null) {
      map['order_due_date'] = orderDueDate;
    }
    if (vehicleNo != null) {
      map['vehicle_no'] = vehicleNo;
    }
    if (lrDate != null) {
      map['lr_date'] = lrDate;
    }
    if (despatchedThrough != null) {
      map['despatched_through'] = despatchedThrough;
    }
    if (mailingName != null) {
      map['mailing_name'] = mailingName;
    }
    if (shippedToName != null) {
      map['shipped_to_name'] = shippedToName;
    }
    if (shippedToAddress1 != null) {
      map['shipped_to_address_1'] = shippedToAddress1;
    }
    if (shippedToAddress2 != null) {
      map['shipped_to_address_2'] = shippedToAddress2;
    }
    if (shippedToAddress3 != null) {
      map['shipped_to_address_3'] = shippedToAddress3;
    }
    if (shippedToGstin != null) {
      map['shipped_to_gstin'] = shippedToGstin;
    }
    if (shippedToState != null) {
      map['shipped_to_state'] = shippedToState;
    }
    if (narration != null) {
      map['narration'] = narration;
    }
    return map;
  }

  SalesOrderHeaderEntity.fromAllMap(Map<String, dynamic> json) {
    companyId = json['company_id'];
    mobileNo = json['mobile_no'];
    date = json['date'];
    uniqueId = json['unique_id'];
    voucherType = json['voucher_type'];
    voucherTypeName = json['voucher_type_name'];
    partyName = json['party_name'];
    address = json['address'];
    // address1 = json['address1'];
    // address2 = json['address2'];
    // address3 = json['address3'];
    gstin = json['gstin'];
    partyMobileNo = json['party_mobile_no'];
    // ewbNo = json['party_mobile_no'];
    invoiceNo = json['invoice_no'];
    orderDueDate = json['order_due_date'];
    state = json['state']; // komal // 11-3-2023 // state node added
    salesPersonName =
        json['salesperson_name']; //snehal 06-08-2022 add salesperson
    rateType = json['rate_type']; // komal // 14-3-2023 // rate type node added
    if (json['items'] != null) {
      items = <SOAddToCartEntity>[];
      json['items'].forEach((v) {
        items?.add(SOAddToCartEntity.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (mobileNo != null) {
      map['mobile_no'] = mobileNo;
    }
    if (uniqueId != null) {
      map['unique_id'] = uniqueId;
    }
    if (voucherType != null) {
      map['voucher_type'] = voucherType;
    }
    if (partyId != null) {
      map['party_id'] = partyId;
    }
    if (date != null) {
      map['date'] = date;
    }
    // if (issueSlipNo != null) {
    //   map['issue_slip_no'] = issueSlipNo;
    // }
    if (invoiceNo != null) {
      map['invoice_no'] = invoiceNo;
    }
    if (rateType != null) {
      map['rate_type'] = rateType;
    }
    return map;
  }

  Map<String, dynamic> toMapApprovalStatus() {
    Map<String, dynamic> map = {};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (mobileNo != null) {
      map['mobile_no'] = mobileNo;
    }
    if (uniqueId != null) {
      map['unique_id'] = uniqueId;
    }
    if (approvalRemark != null) {
      map['approval_remark'] = approvalRemark;
    }
    if (approvalStatus != null) {
      map['approval_status'] = approvalStatus;
    }
    return map;
  }
}
