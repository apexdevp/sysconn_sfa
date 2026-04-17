import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';
import 'package:sysconn_sfa/api/entity/order/so_inv_report_entity.dart';

class SalesOrderHeaderEntity {
  String? groupId;
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
  String? billaddress2;
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
  String? shippedToPincode;
  String? shippedCity;
  List<SOAddToCartEntity>? items;
  List<SOInvReportEntity>? inventory; //pratiksha p 30-09-2025 add
  String? amount;
  String? invoiceNo;
  String? rateType;
  String? salesPersonName;
  String? userRemark;
  String? approvalRemark;
  String? approvalStatus;
  String? paymentTerms;
  String? giftReferenceNo;
  String? pricelist;
  String? termncondition;
  SalesOrderHeaderEntity();
  //fromALLJson

  // SalesOrderHeaderEntity.fromALLJson(Map<String, dynamic> json) {
  //   uniqueId = json['unique_id'];
  //   invoiceNo = json['invoice_no'];
  //   voucherType = json['voucher_type'];
  //   voucherTypeName = json['voucher_type_name'];
  //   partyId = json['party_id'];
  //   partyName = json['party_name'];
  //   date = json['date'];
  //   narration = json['narration'];
  //   address = json["address"];
  //   gstin = json["gstin"];
  //   state = json["state"];
  //   partyMobileNo = json['party_mobile_no'];
  //   orderDueDate = json['order_due_date'];
  //   vehicleNo = json["vehicle_no"];
  //   lrDate = json['lr_date'];
  //   mailingName = json["mailing_name"];
  //   // totalAmount = json['total_amount'];
  //   //   pricelist = json['pricelist'];
  //   if (json['inventory'] != null) {
  //     inventory = <SOInvReportEntity>[];
  //     json['inventory'].forEach((v) {
  //       inventory?.add(SOInvReportEntity.fromMap(v));
  //     });
  //   }
  // }

  SalesOrderHeaderEntity.fromALLJson(Map<String, dynamic> json) {
    uniqueId = json['unique_id'];
    invoiceNo = json['invoice_no'];
    voucherType = json['voucher_type'];
    voucherTypeName = json['voucher_type_name'];
    partyId = json['party_id'];
    partyName = json['party_name'];
    date = json['date'];
    narration = json['narration'];
    pricelist = json['pricelist'];
    // Party (Billed To)
    address = json["address"];
    billaddress2 = json["bill_to_address2"];
    gstin = json["gstin"];
    state = json["state"];
    partyMobileNo = json['party_mobile_no'];
    // Additional Details
    orderDueDate = json['order_due_date'];
    vehicleNo = json["vehicle_no"];
    lrDate = json['lr_date'];
    despatchedThrough = json['despatched_through'];
    mailingName = json["mailing_name"];
    // --- SHIPPED TO FIELDS (Your missing ones)
    shippedToName = json["consignee_name"];
    shippedToAddress1 = json["shipped_to_address"];
    shippedToAddress2 = json["shipped_to_address_2"];
    shippedToGstin = json["shipped_to_gstin"];
    shippedToState = json["shipped_to_state"];
    // shippedToCity = json["shipped_to_city"];
    shippedToPincode = json["shipped_to_pincode"];
    termncondition = json["terms_n_condition"];

    // Inventory
    if (json['inventory'] != null) {
      inventory = <SOInvReportEntity>[];
      json['inventory'].forEach((v) {
        inventory?.add(SOInvReportEntity.fromMap(v));
      });
    }
  }

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
    state = json['state'];
    orderDueDate = json['order_due_date'];
  }

  Map<String, dynamic> toBilledToMap() {
    var map = <String, dynamic>{};

    if (groupId != null) {
      map['group_id'] = groupId;
    }
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
    if (billaddress2 != null) {
      map['bill_to_address_2'] = billaddress2;
    }
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
    state = json['state'];
    salesPersonName = json['salesperson_name'];
    rateType = json['rate_type'];
    if (json['items'] != null) {
      items = <SOAddToCartEntity>[];
      json['items'].forEach((v) {
        items?.add(SOAddToCartEntity.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (groupId != null) {
      map['group_id'] = groupId;
    }
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
    if (state != null) {
      map['state'] = state;
    }
    if (rateType != null) {
      map['rate_type'] = rateType;
    }
    if (giftReferenceNo != null) {
      map['gift_reference'] = giftReferenceNo;
    }
    if (paymentTerms != null) {
      map['payment_terms'] = paymentTerms;
    }
    if (amount != null) {
      map['total_amount'] = amount;
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
