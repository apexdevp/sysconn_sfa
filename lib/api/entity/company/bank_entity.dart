class BankEntity {
  String? accountNo;
  String? ifsc;
  String? bankName;
  String? branch;
  String? type;
  String? dispalyName;
  String? companyid;
  String? accounttype;
  String? bankcode;
  String? bbpsbank; 
  String? vpa; 

  BankEntity({this.accountNo, this.bankName, this.branch, this.dispalyName,this.ifsc, this.type,this.bbpsbank,this.vpa}); // pooja // 01-08-2024 // add bbpsbank and vpa

  BankEntity.fromMap(Map<String, dynamic> json) {
    accountNo = json['account_number'];
    ifsc = json['ifsc'];
    bankName = json['bank_name'];
    branch = json['branch'];
    type = json['type'];
    dispalyName = json['display_name'];
    bankcode = json['bank_code'];
    companyid = json['company_id'];
    accounttype = json['account_type'];
    bbpsbank = json['bbps_bank']; 
    vpa = json['vpa_no'];
  }
 
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_no'] = accountNo;
    data['ifsc'] = ifsc;
    data['bank_name'] = bankName;
    data['branch'] = branch;
    data['type'] = type;
    data['display_name'] = dispalyName;
    data['bank_code'] = bankcode;
    data['company_id'] = companyid;
    data['account_type'] = accounttype;
    data['bbps_bank'] = bbpsbank; 
    data['vpa_no'] = vpa;
    return data;
   }
}