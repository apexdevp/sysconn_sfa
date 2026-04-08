class ReceiptBillsEntity{
  String? companyId;
  String? hedUniqueId;
  String? billUniqueId;
  String? billno;
  String? billvalue;
  String? totalvalue;

  ReceiptBillsEntity();

  ReceiptBillsEntity.fromJson(Map<String, dynamic> json){
    billno = json["bill_no"];
    billvalue = json["bill_value"];
    totalvalue = json["amount"];
    billUniqueId = json["rec_bill_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if( companyId!= null){
      data['company_id'] = companyId;
    }
    if(hedUniqueId!= null){
      data['hed_unique_id'] = hedUniqueId;
    }
    if(billUniqueId!= null){
      data['rec_bill_id'] = billUniqueId;
    }
    if(billno != null){
      data['bill_no'] = billno;
    }
    if(totalvalue != null){
      data['amount'] = totalvalue;
    }
    return data;
  }
}