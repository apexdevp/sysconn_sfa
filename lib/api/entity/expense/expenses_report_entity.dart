class ExpensesReportEntity {
  String? pending;
  String? approved;
  String? rejected;
  List<ExpensesDetailsReportEntity>? expense;
  
  ExpensesReportEntity({
    this.pending,
    this.approved,
    this.rejected,
  });

  ExpensesReportEntity.fromALLJson(Map<String, dynamic> json) {
    pending = json['pending'];
    approved = json['approved'];
    rejected = json['rejected'];
     if (json['expense'] != null) {
      expense = <ExpensesDetailsReportEntity>[];
      json['expense'].forEach((v) {
        expense?.add(ExpensesDetailsReportEntity.fromALLJson(v));
      });
    }  
  }
}

class ExpensesDetailsReportEntity {
  String? employeeid;
  String? uniqueId;
  // String? vchType;
  String? vchprefix;
  String? maxNo;
  // String? ledgerId;
  String? date;
  String? remark;
  int? amount;
  String? approver;
  String? approverRemark;
  String? approvalStatus;
  String? approverName;
  String? deleteStatus;
  String? employeeName;
  String? fcmToken;
  String? istallydownload;
  num? approvedamt;
  num? rejectAmount;
  num? claimedAmount;

  // List<ExpensesLedgerEntity>? ledger;
  // List<ExpensesDocumentEntity>? document;

  ExpensesDetailsReportEntity();

  ExpensesDetailsReportEntity.fromALLJson(Map<String, dynamic> json) {
    // companyId = json['company_id'];
    employeeid = json['employee_id'];
    uniqueId = json['unique_id'];
    // vchType = json['vch_type_id'];
    vchprefix = json['vch_prefix'];
    maxNo = json['max_no'];
    date = json['date'];
    remark = json['remark'];
    amount = json['amount'] != '' ? num.parse(json['amount']).round() : 0;
    approver = json['approver'];
    approvalStatus = json['approval_status'];
    //mobileNo = json['MOBILE_NO'];
    approverRemark = json['approval_remark'];
    // ledgerId = json['ledger_id'];
    // approverName = json['approver_name'];
    // deleteStatus = json['delete_status'];
    employeeName = json['employee_name'];
    fcmToken = json['fcm_token'];
    approvedamt =json['approved_amt'] == '' || json['approved_amt'] == null?0:num.parse(json['approved_amt']);
    rejectAmount = json['rejected_amt'] == '' || json['rejected_amt'] == null?0:num.parse(json['rejected_amt']);
    claimedAmount = json['claimed_amt'] == '' || json['claimed_amt'] == null?0:num.parse(json['claimed_amt']);
    istallydownload = json['tally_download']; // Manisha 06-08-2025

    // if (json['ledger'] != null) {
    //   ledger = <ExpensesLedgerEntity>[];
    //   json['ledger'].forEach((v) {
    //     ledger?.add(ExpensesLedgerEntity.fromALLJson(v));
    //   });
    // }
    // if (json['document'] != null) {
    //   document = <ExpensesDocumentEntity>[];
    //   json['document'].forEach((v) {
    //     document?.add(ExpensesDocumentEntity.fromALLJson(v));
    //   });
    // }
  }
}