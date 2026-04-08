// class ExpensesDocumentEntity {
//   String? partnerCode;
//   String? companyId;
//   String? mobileNo;
//   String? headerUniqueId;
//   String? documentPath;
//   String? documentId;
//   String? amount;
//   String? date;
//   String? remark;
//  String? maxNo;

//   ExpensesDocumentEntity(
//       {this.amount,
//       this.companyId,
//       this.partnerCode,
//       this.mobileNo,
//       this.headerUniqueId,
//       this.documentPath,
//       this.documentId,
//       this.date,
//       this.remark,
//       this.maxNo});

//   ExpensesDocumentEntity.fromALLJson(Map<String, dynamic> json) {
//     companyId = json['company_id'];
//     amount = json['AMOUNT'];
//     headerUniqueId = json['header_unique_id'];
//     mobileNo = json['MOBILE_NO'];
//     documentPath = json['document_path'];
//     documentId = json['document_id'];
//     remark = json['remark'];
//     date = json['DATE'];
//     maxNo = json['max_no'];
//   }

//   Map<String, dynamic> toALLJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();

//     if (amount != null) {
//       data['AMOUNT'] = this.amount;
//     }
//     if (companyId != null) {
//       data['COMPANY_ID'] = this.companyId;
//     }
//     if (partnerCode != null) {
//       data['PARTNER_CODE'] = this.partnerCode;
//     }

//     if (mobileNo != null) {
//       data['MOBILE_NO'] = this.mobileNo;
//     }

//     if (headerUniqueId != null) {
//       data['HEADER_UNIQUE_ID'] = this.headerUniqueId;
//     }
//     if (documentPath != null) {
//       data['DOCUMENT_PATH'] = this.documentPath;
//     }

//     if (documentId != null) {
//       data['DOCUMENT_ID'] = this.documentId;
//     }
    
//     if (remark != null) {
//       data['Remark'] = this.remark;
//     }
//     if (date != null) {
//       data['DATE'] = this.date;
//     }

//     return data;
//   }
// }
