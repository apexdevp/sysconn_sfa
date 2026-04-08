class TargetVsActualDetEntity{
  String? companyId;
  String? partnerCode;
  String? hedUniqueId;
  String? monthDate;
  String? amount;
  TargetVsActualDetEntity({this.monthDate,this.amount,this.hedUniqueId});

  TargetVsActualDetEntity.fromJson(Map<String, dynamic> json) {
    companyId = json["company_id"];
    partnerCode = json["partner_code"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['company_id'] = companyId;
    //data['partner_code'] = partnerCode;
    data['hed_unique_id'] = hedUniqueId;
    data['month_date'] = monthDate;
    data['amount'] = amount;
    return data;
  }
}