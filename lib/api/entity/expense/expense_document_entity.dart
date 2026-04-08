class ExpensesDocumentEntity {
  // String? partnerCode;
  // String? companyId;
  // String? mobileNo;
  String? headerUniqueId;
  String? documentId;
  String? maxNo;
  String? documentPath;
  // String? amount;
  // String? date;
  String? remark;
  String? imageEvent;
  String? imageSelectedFilepath;

  ExpensesDocumentEntity();

  ExpensesDocumentEntity.fromALLJson(Map<String, dynamic> json) {
    // companyId = json['company_id'];
    // amount = json['AMOUNT'];
    headerUniqueId = json['hed_unique_id'];
    // mobileNo = json['MOBILE_NO'];
    maxNo = json['max_no'];
    documentId = json['document_id'];
    documentPath = json['document_path'];
    remark = json['remark'];
    // date = json['DATE'];
  }

  Map<String, dynamic> toALLJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // if (amount != null) {
    //   data['AMOUNT'] = amount;
    // }
    // if (companyId != null) {
    //   data['COMPANY_ID'] = companyId;
    // }
    // if (partnerCode != null) {
    //   data['PARTNER_CODE'] = partnerCode;
    // }
    if (headerUniqueId != null) {
      data['hed_unique_id'] = headerUniqueId;
    }
    // if (documentPath != null) {
    //   data['document_path'] = documentPath;
    // }
    if (documentId != null) {
      data['document_id'] = documentId;
    }
    if (remark != null) {
      data['remark'] = remark;
    }
    // if (date != null) {
    //   data['DATE'] = date;
    // }
    if(imageEvent !=null){
      data['image_event'] = imageEvent;
    }
    if(imageSelectedFilepath !=null){
      data['image_selected_file_path'] = imageSelectedFilepath;
    }
    return data;
  }
}