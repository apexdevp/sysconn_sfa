// class AdvExpensesEntity {
//   String? companyId;
//   String? date;
//   String? category;
//   String? expensesDetails;
//   String? amount;
//   String? approvalStatus;
//   String? emailId;
//   String? expensesId;
//   String? approvedbyId;
//   String? approverRemark;
//   String? userName;
//   String? fcmToken;
//   AdvExpensesEntity({
//     this.date,
//     this.category,
//     this.expensesDetails,
//     this.amount,
//     this.approvalStatus,
//     this.emailId,
//     this.expensesId,
//     this.companyId,
//     this.approvedbyId,
//     this.approverRemark,
//     this.userName,
//   });
//   AdvExpensesEntity.fromJson(Map<String, dynamic> map) {
//     expensesId = map['expense_id'];
//     date = map['date'];
//     category = map['category'];
//     expensesDetails = map['expense_details'];
//     amount = map['amount'];
//     approvalStatus = map['approval_status'];
//     approvedbyId = map['approved_by_id'];
//     approverRemark = map['approver_remark'];
//     userName = map['user_name'];
//     expensesId = map['expense_id'];
//     emailId = map['email_id'];
//     fcmToken = map['fcm_ token'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (date != null) {
//       data['date'] = date;
//     }
//     if (amount != null) {
//       data['amount'] = amount;
//     }
//     if (category != null) {
//       data['category'] = category;
//     }

//     if (expensesDetails != null) {
//       data['expense_details'] = expensesDetails;
//     }

//     if (expensesId != null) {
//       data['expense_id'] = expensesId;
//     }
//     if (emailId != null) {
//       data['email_id'] = emailId;
//     }
//     if (approvalStatus != null) {
//       data['APPROVAL_STATUS'] = approvalStatus;
//     }
//     if (companyId != null) {
//       data['company_id'] = companyId;
//     }

//     if (approvedbyId != null) {
//       data['approved_by_id'] = approvedbyId;
//     }

//     if (approverRemark != null) {
//       data['APPROVER_REMARK'] = approverRemark;
//     }

//     if (userName != null) {
//       data['MOB_USER_NAME'] = userName;
//     }
//     return data;
//   }
// }
