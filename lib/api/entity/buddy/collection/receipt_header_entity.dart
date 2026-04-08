
import 'package:sysconn_sfa/api/entity/buddy/collection/receipt_bill_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/collection/receipt_ledger_entity.dart';

class ReceiptHeaderEntity {
  String? groupId;
  String? companyId;
  String? emailid;
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
  String? shippedTocity; //pooja // 08-08-2024 // add city and pincode
  String? shippedTopincode;
  String? instrumentDate;
  String? instrumentNo;
  String? bankName;
  String? transactionType;
  String? recBankAmt;
  String? bankCashCode;
  String? bankCashName;
  String? isGstAutoCal;
  String? isTalyEntry;
  List<ReceiptBillsEntity>? recBills;
  List<ReceiptLedgerEntity>? recLedger;

  ReceiptHeaderEntity();

  ReceiptHeaderEntity.fromJson(Map<String, dynamic> json) {
    uniqueId = json['unique_id'];
    invoiceNo = json['invoice_no'];
    type = json['type'];
    voucherType = json['voucher_type'];
    voucherTypeName = json['voucher_type_name'];
    date = json['date'];
    paymentTerms = json['payment_terms'];
    lrDate = json['lr_date'];
    originalInvoiceNo = json['original_invoice_no'];
    originalInvoiceDate = json['original_invoice_date'];
    totalAmount = json['total_amount'] == ''
        ? '0'
        : num.parse(json['total_amount']).toStringAsFixed(2);
    cashAmount = json['cash_amount'];
    bankInstNo = json['bank_inst_number'];
    bankAmount = json['bank_amount'];
    cardInstNo = json['card_inst_number'];
    cardAmount = json['card_amount'];
    instrumentDate = json['instrument_date'];
    instrumentNo = json['instrument_no'];
    bankName = json['bank_name'];
    transactionType = json['rec_transaction_type'];
    recBankAmt = json['rec_party_amount'];
    bankCashCode = json['bank_cash_code'];
    bankCashName = json['bank_cash_name'];
    isGstAutoCal = json['enable_auto_gst'];
    isTalyEntry = json['is_tally_entry'];
    if (json['bills'] != null) {
      recBills = <ReceiptBillsEntity>[];
      json['bills'].forEach((v) {
        recBills?.add(ReceiptBillsEntity.fromJson(v));
      });
    }
    if (json['ledger'] != null) {
      recLedger = <ReceiptLedgerEntity>[];
      json['ledger'].forEach((v) {
        recLedger?.add(ReceiptLedgerEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (emailid != null) {
      data['email_id'] = emailid;
    }
    if (uniqueId != null) {
      data['unique_id'] = uniqueId;
    }
    if (invoiceNo != null) {
      data['receipt_no'] = invoiceNo; // data['invoice_no'] = invoiceNo;
    }
    if (type != null) {
      data['type'] = type;
    }
    if (voucherType != null) {
      data['vchtype_code'] = voucherType; // data['vch_type'] = voucherType;
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
    if (isGstAutoCal != null) {
      data['enable_auto_gst'] = isGstAutoCal;
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
    if (vehicleNo != null) {
      data['vehicle_no'] = vehicleNo;
    }
    if (lrDate != null) {
      data['lr_date'] = lrDate;
    }
    if (originalInvoiceNo != null) {
      data['original_invoice_no'] = originalInvoiceNo;
    }
    if (originalInvoiceDate != null) {
      data['original_invoice_date'] = originalInvoiceDate;
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
      data['transaction_type'] = transactionType;
    }
    return data;
  }
}
