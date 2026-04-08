// import 'package:sysconn_sfa/api/entity/buddy/expenses/expense_document_entity.dart';
// import 'package:sysconn_sfa/api/entity/buddy/expenses/expense_ledger_entity.dart';

// class ExpensesHeaderEntity {
//   String? partnerCode;
//   String? companyId;
//   String? mobileNo;
//   String? vchType;
//   String? vchprefix;
//   String? ledgerId;
//   String? iouLedgerName;
//   String? narration;
//   String? uniqueCode;
//   String? date;
//   String? amount;
//   String? approver;
//   String? approverRemark;
//   String? approvalStatus;
//   String? approverName;
//   String? userName;
//   String? fcmToken;
//   String? istallydownload;
//   String? emailId;
//   String? partyName;
//   List<ExpensesLedgerEntity>? ledger;
//   List<ExpensesDocumentEntity>? document;

//   ExpensesHeaderEntity({
//     this.date,
//     this.amount,
//     this.approvalStatus,
//     this.mobileNo,
//     this.companyId,
//     this.partnerCode,
//     this.approver,
//     this.approverRemark,
//     this.vchprefix,
//     this.ledgerId,
//     this.iouLedgerName,
//     this.uniqueCode,
//     this.narration,
//     this.approverName,
//     this.userName,
//     this.fcmToken,
//     this.emailId,
//   });

//   ExpensesHeaderEntity.fromALLJson(Map<String, dynamic> json) {
//     date = json['date'];
//     amount = json['amount'];
//     // != ''?num.parse(json['amount']).round():0;
//     approvalStatus = json['approval_status'];
//     mobileNo = json['MOBILE_NO'];
//     companyId = json['COMPANY_ID'];
//     approver = json['approver'];
//     approverRemark = json['approval_remark'];
//     vchType = json['vchtype_type'];
//     vchprefix = json['vch_prefix'];
//     ledgerId = json['ledger_id'];
//     iouLedgerName = json['iou_ledger_name'];
//     narration = json['narration'];
//     uniqueCode = json['unique_id'];
//     approverName = json['approver_name'];
//     userName = json['user_name'];
//     fcmToken = json['FCM_TOKEN'];
//     partyName = json['party_name'];

//     if (json['ledger'] != null) {
//       ledger = <ExpensesLedgerEntity>[];
//       json['ledger'].forEach((v) {
//         ledger?.add(ExpensesLedgerEntity.fromALLJson(v));
//       });
//     }
//     if (json['document'] != null) {
//       document = <ExpensesDocumentEntity>[];
//       json['document'].forEach((v) {
//         document?.add(ExpensesDocumentEntity.fromALLJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toALLJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (date != null) {
//       data['DATE'] = this.date;
//     }
//     if (amount != null) {
//       data['AMOUNT'] = this.amount;
//     }
//     if (mobileNo != null) {
//       data['MOBILE_NO'] = this.mobileNo;
//     }
//     if (emailId != null) {
//       data['email_id'] = this.emailId;
//     }
//     if (approvalStatus != null) {
//       data['APPROVAL_STATUS'] = this.approvalStatus;
//     }
//     if (companyId != null) {
//       data['COMPANY_ID'] = this.companyId;
//     }
//     if (partnerCode != null) {
//       data['PARTNER_CODE'] = this.partnerCode;
//     }
//     if (approver != null) {
//       data['APPROVER'] = this.approver;
//     }
//     if (approverRemark != null) {
//       data['APPROVAL_REMARK'] = this.approverRemark;
//     }

//     if (vchprefix != null) {
//       data['VCH_PREFIX'] = this.vchprefix;
//     }

//     if (ledgerId != null) {
//       data['LEDGER_ID'] = this.ledgerId;
//     }
//     if (narration != null) {
//       data['NARRATION'] = this.narration;
//     }
//     if (uniqueCode != null) {
//       data['UNIQUE_ID'] = this.uniqueCode;
//     }
//     if (vchType != null) {
//       data['VCHTYPE_TYPE'] = this.vchType;
//     }
//     if (approverName != null) {
//       data['APPROVER_NAME'] = this.approverName;
//     }
//     if (userName != null) {
//       data['USER_NAME'] = this.userName;
//     }

//     return data;
//   }  A
// }
