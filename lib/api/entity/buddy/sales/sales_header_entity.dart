import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';

class SalesHeaderEntity {
  String? companyId;
  String? mobileno;
  String? uniqueId;
  String? invoiceNo;
  String? type;
  String? voucherType;
  String? voucherTypeName;
  String? posPayment;
  String? partyId;
  String? partyName;
  String? date;
  String? paymentTerms;
  String? narration;
  String? address;
  String? gstin;
  String? state;
  String? partyMobileNo;
  String? orderDueDate;
  String? vehicleNo;
  String? lrDate;
  String? despatchedthrough;
  String? mailingName;
  String? consigneename;
  String? shippedtoaddress;
  String? shippedtogstin;
  String? shippedToState;
  String? originalInvoiceNo;
  String? originalInvoiceDate;
  String? cnReason;
  String? totalAmount;
  String? pricelist;
  String? cashAmount;
  String? bankInstNo;
  String? bankAmount;
  String? cardInstNo;
  String? cardAmount;
  String? giftReferenceNo;
  String? giftAmount;
  String? shippedTocity;
  String? shippedTopincode;
  String? dueDate;
  String? isGstAutoCal;
  String? isTalyEntry;
  String? instrumentDate;
  String? instrumentNo;
  String? bankName;
  String? transactionType;
  String? recPartyAmt;
  String? bankCashCode;
  String? approver; //snehal 06-11-2024 add for expenses
  String? approvalRemark; //snehal 06-11-2024 add for expenses
  String? approvalDate; //snehal 06-11-2024 add for expenses
  String? approvalStatus; //snehal 08-11-2024 add for expenses
  List<SalesInventoryEntity>? items;
  List<SalesLedgerEntity>? ledger;
  // List<SalesPaymentDetailsEntity>? payment;

  SalesHeaderEntity({this.invoiceNo});

  SalesHeaderEntity.fromALLJson(Map<String, dynamic> json) {
    uniqueId = json['unique_id'];
    invoiceNo = json['invoice_no'];
    type = json['type'];
    voucherType = json['voucher_type'];
    voucherTypeName = json['voucher_type_name'];
    posPayment = json['pos_payment'];
    partyId = json['party_id'];
    partyName = json['party_name'];
    date = json['date'];
    paymentTerms = json['payment_terms'];
    narration = json['narration'];
    address = json["address"];
    gstin = json["gstin"];
    state = json["state"];
    partyMobileNo = json['party_mobile_no'];
    orderDueDate = json['order_due_date'];
    vehicleNo = json["vehicle_no"];
    lrDate = json['lr_date'];
    despatchedthrough = json["despatched_through"];
    mailingName = json["mailing_name"];
    consigneename = json["consignee_name"];
    shippedtoaddress = json["shipped_to_address"];
    shippedtogstin = json["shipped_to_gstin"];
    shippedToState = json["shipped_to_state"];
    originalInvoiceNo = json['original_invoice_no'];
    originalInvoiceDate = json['original_invoice_date'];
    cnReason = json['cn_reason'];
    totalAmount = json['total_amount'];
    pricelist = json['pricelist'];
    cashAmount = json['cash_amount'];
    bankInstNo = json['bank_inst_number'];
    bankAmount = json['bank_amount'];
    cardInstNo = json['card_inst_number'];
    cardAmount = json['card_amount'];
    giftReferenceNo = json['gift_reference'];
    giftAmount = json['gift_amount'];
    shippedTocity = json['shipped_to_city'];
    shippedTopincode = json['shipped_to_pincode'];
    isGstAutoCal = json['enable_auto_gst'];
    isTalyEntry = json['is_tally_entry'];
    instrumentDate = json['instrument_date'];
    instrumentNo = json['instrument_no'];
    bankName = json['bank_name'];
    transactionType = json['rec_transaction_type'];
    recPartyAmt = json['rec_party_amount'];
    bankCashCode = json['bank_cash_code'];
    if (json['inventory'] != null) {
      items = <SalesInventoryEntity>[];
      json['inventory'].forEach((v) {
        items?.add(SalesInventoryEntity.fromMap(v));
      });
    }
    if (json['ledger'] != null) {
      ledger = <SalesLedgerEntity>[];
      json['ledger'].forEach((v) {
        ledger?.add(SalesLedgerEntity.fromMap(v));
      });
    }
    // if (json['payment'] != null) {
    //   payment = <SalesPaymentDetailsEntity>[];
    //   json['payment'].forEach((v) {
    //     payment?.add(SalesPaymentDetailsEntity.fromALLJson(v));
    //   });
    // }
  }

  SalesHeaderEntity.fromJson(Map<String, dynamic> json) {
    voucherTypeName = json['vchtype_name'];
    date = json['date'];
    dueDate = json['due_date'];
    narration = json['narration'];
    partyName = json['party_name'];
    invoiceNo = json['invoice_no'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (mobileno != null) {
      data['mobile_no'] = mobileno;
    }
    if (uniqueId != null) {
      data['unique_id'] = uniqueId;
    }
    if (invoiceNo != null) {
      data['invoice_no'] = invoiceNo;
    }
    if (type != null) {
      data['type'] = type;
    }
    if (voucherType != null) {
      data['vch_type'] = voucherType;
    }
    if (partyId != null) {
      data['party_id'] = partyId;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (paymentTerms != null) {
      data['payment_terms'] = paymentTerms;
    }
    if (narration != null) {
      data['narration'] = narration;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (gstin != null) {
      data['gstin'] = gstin;
    }
    if (state != null) {
      data['state'] = state;
    }
    if (partyMobileNo != null) {
      data['party_mobile_no'] = partyMobileNo;
    }
    // if (time != null) {
    //   data['time'] = time;
    // }

    if (orderDueDate != null) {
      data['order_due_date'] = orderDueDate;
    }
    if (vehicleNo != null) {
      data['vehicle_no'] = vehicleNo;
    }
    if (lrDate != null) {
      data['lr_date'] = lrDate;
    }
    if (despatchedthrough != null) {
      data['despatched_through'] = despatchedthrough;
    }
    if (mailingName != null) {
      data['mailing_name'] = mailingName;
    }
    if (consigneename != null) {
      data['shipped_to_name'] = consigneename;
    }
    if (shippedtoaddress != null) {
      data['shipped_to_address'] = shippedtoaddress;
    }
    if (shippedtogstin != null) {
      data['shipped_to_gstin'] = shippedtogstin;
    }
    if (shippedToState != null) {
      data['shipped_to_state'] = shippedToState;
    }
    if (originalInvoiceNo != null) {
      data['original_invoice_no'] = originalInvoiceNo;
    }
    if (originalInvoiceDate != null) {
      data['original_invoice_date'] = originalInvoiceDate;
    }
    if (cnReason != null) {
      data['cn_reason'] = cnReason;
    }
    if (totalAmount != null) {
      data['total_amount'] = totalAmount;
    }
    if (cashAmount != null) {
      data['cash_amount'] = cashAmount;
    }
    if (bankInstNo != null) {
      data['bank_inst_number'] = bankInstNo;
    }
    if (bankAmount != null) {
      data['bank_amount'] = bankAmount;
    }
    if (cardInstNo != null) {
      data['card_inst_number'] = cardInstNo;
    }
    if (cardAmount != null) {
      data['card_amount'] = cardAmount;
    }
    if (giftReferenceNo != null) {
      data['gift_reference'] = giftReferenceNo;
    }
    if (giftAmount != null) {
      data['gift_amount'] = giftAmount;
    }
    if (shippedTocity != null) {
      data['shipped_to_city'] = shippedTocity;
    }
    if (shippedTopincode != null) {
      data['shipped_to_pincode'] = shippedTopincode;
    }
    if (isGstAutoCal != null) {
      data['enable_auto_gst'] = isGstAutoCal;
    }
    if (instrumentDate != null) {
      data['instrument_date'] = instrumentDate;
    }
    if (instrumentNo != null) {
      data['instrument_no'] = instrumentNo;
    }
    if (bankName != null) {
      data['bank_name'] = bankName;
    }
    if (transactionType != null) {
      data['rec_transaction_type'] = transactionType;
    }
    if (recPartyAmt != null) {
      data['rec_party_amount'] = recPartyAmt;
    }
    if (bankCashCode != null) {
      data['bank_cash_code'] = bankCashCode;
    }
    if (approver != null) {
      data['approver'] = approver;
    } //snehal 06-11-2024 add for expenses
    if (approvalDate != null) {
      data['approval_date'] = approvalDate;
    } //snehal 06-11-2024 add for expenses
    if (approvalRemark != null) {
      data['approver_remark'] = approvalRemark;
    } //snehal 06-11-2024 add for expenses
    if (approvalStatus != null) {
      data['approval_status'] = approvalStatus;
    } //snehal 08-11-2024 add for expenses
    return data;
  }
}
