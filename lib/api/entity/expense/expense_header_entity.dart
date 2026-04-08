

import 'package:sysconn_sfa/api/entity/expense/expense_document_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';

class ExpensesHeaderEntity {
  String? groupId;
  String? companyId;
  // String? mobileNo;
  String? employeeid;
  String? uniqueId;
  String? vchType;
  String? vchprefix;
  String? maxNo;
  // String? ledgerId;
  String? date;
  String? remark;
  String? amount;
  String? approver;
  String? approverRemark;
  String? approvalStatus;
  String? approverName;
  String? deleteStatus;
  String? employeeName;
  String? fcmToken;
  String? mobileno; //snehal 28-07-2025 add
  String? istallydownload;
  // int? approvedamt;
  // int? rejectAmount;
  String? emailid;//Snehal 8-01-2025 add
   String? vchprefixname;
  List<ExpensesLedgerEntity>? ledger;
  List<ExpensesDocumentEntity>? document;

  ExpensesHeaderEntity();

  ExpensesHeaderEntity.fromALLJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    employeeid = json['employee_id'];
    uniqueId = json['unique_id'];
    // vchType = json['vch_type_id'];
    vchprefix = json['vch_prefix'];
    maxNo = json['max_no'];
    date = json['date'];
    remark = json['remark'];
    amount = json['amount'] ;//json['amount'] != '' ? num.parse(json['amount']).round() : 0;
    approver = json['approver'];
    approvalStatus = json['approval_status'];
    //mobileNo = json['MOBILE_NO'];
    approverRemark = json['approval_remark'];
    // ledgerId = json['ledger_id'];
    // approvalStatus = json['approver_status'];
    approverName = json['approver_name'];
    deleteStatus = json['delete_status'];
    employeeName = json['employee_name'];
    fcmToken = json['fcm_token'];
    // approvedamt =json['approved_amt'] != '' &&  json['approved_amt'] != null? num.parse(json['approved_amt']).round() : 0;
    // rejectAmount = int.tryParse(json['rejected_amt']?.toString() ?? '') ?? 0;
    mobileno = json['mobile_no'];//snehal 28-07-2025 add
    employeeid = json['employee_id'];//snehal 28-07-2025 add
    vchprefixname=json['vch_name'];//snehal 9-02-2026 add
    if (json['ledger'] != null) {
      ledger = <ExpensesLedgerEntity>[];
      json['ledger'].forEach((v) {
        ledger?.add(ExpensesLedgerEntity.fromALLJson(v));
      });
    }
    if (json['document'] != null) {
      document = <ExpensesDocumentEntity>[];
      json['document'].forEach((v) {
        document?.add(ExpensesDocumentEntity.fromALLJson(v));
      });
    }
  }

  Map<String, dynamic> toALLJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (groupId != null) {
      data['group_id'] = groupId;
    }
    if (employeeid != null) {
      data['employee_id'] = employeeid;
    }
    if (uniqueId != null) {
      data['unique_id'] = uniqueId;
    }
    if (vchType != null) {
      data['vchtype_type'] = vchType;
    }
    if (vchprefix != null) {
      data['vch_prefix'] = vchprefix;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (remark != null) {
      data['narration'] = remark;
    }
    if (amount != null) {
      data['amount'] = amount;
    }
    // if (mobileNo != null) {
    //   data['mobile_no'] = mobileNo;
    // }
    if (approver != null) {
      data['approver'] = approver;
    }
    if (approvalStatus != null) {
      data['approval_status'] = approvalStatus;
    }
    if (approverRemark != null) {
      data['approval_remark'] = approverRemark;
    }
    // if (ledgerId != null) {
    //   data['ledger_id'] = ledgerId;
    // }
    
    // if (userName != null) {
    //   data['USER_NAME'] = userName;
    // }

      if (emailid != null) {
      data['email_id'] = emailid;
    }

    return data;
  }
}
