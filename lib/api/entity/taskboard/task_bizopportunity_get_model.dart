class BizOpportunityListModel {
  String? productDesc;
  String? productCode;
  String? rate;
  String? qty;
  String? total;
  String? taskId;
  String? taskType;

  BizOpportunityListModel.fromJson(Map<String, dynamic> json) {
    productDesc = json['product_desc'];
    productCode = json['product_code'];
    rate = json['rate'];
    qty = json['qty'];
    total = json['total'];
    taskId = json['taskid'];
    taskType = json['tasktype'];
  }
}