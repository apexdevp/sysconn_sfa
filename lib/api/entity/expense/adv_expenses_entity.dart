class AdvExpensesEntity {
  String? groupId;
  String? companyId;
  String? employeeid;
  String? uniqueId;
  String? date;
  String? category;
  String? expensesDetails;
  String? amount;
  String? approvedbyId;
  String? approvalStatus;
  String? approverRemark;
  String? empname;
  String? fcmToken;
  String? mobileno;//snehal 28-07-2025 add
String? emailId;//Snehal 5-01-2026 add
  AdvExpensesEntity();

  AdvExpensesEntity.fromJson(Map<String, dynamic> map) {
    employeeid = map['employee_id'];
    uniqueId = map['unique_id'];
    date = map['date'];
    category = map['category'];
    expensesDetails = map['expense_details'];
    amount = map['amount'];
    approvedbyId = map['approved_by_id'];
    approvalStatus = map['approval_status'];
    approverRemark = map['approver_remark'];
    empname = map['employee_name'];
    //uniqueId = map['expense_id'];
    // mobileno = map['mobile_no'];
    fcmToken = map['fcm_token'];
    mobileno = map['mobile_no'];//28-07-2025 add
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (groupId != null) {
      data['group_id'] = groupId;
    }
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (employeeid != null) {
      data['employee_id'] = employeeid;
    }
    if (uniqueId != null) {
      data['unique_id'] = uniqueId;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (category != null) {
      data['category'] = category;
    }
    if (expensesDetails != null) {
      data['expense_details'] = expensesDetails;
    }
    if (amount != null) {
      data['amount'] = amount;
    }
    if (approvedbyId != null) {
      data['approved_by_id'] = approvedbyId;
    }
    if (approvalStatus != null) {
      data['approval_status'] = approvalStatus;
    }
    if (approverRemark != null) {
      data['approver_remark'] = approverRemark;
    }
    // if (userName != null) {
    //   data['MOB_USER_NAME'] = userName;
    // }
     if (emailId != null) {
      data['email_id'] = emailId;
    }
    return data;
  }
}