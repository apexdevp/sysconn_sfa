class VoucherEntity {
  String? companyId;
  String? vchTypeCode;
  String? vchTypeName;
  String? parent;
  String? cyDate;
  String? cyPfx;
  String? nyDate;
  String? nyPfx;
  String? bankName;
  String? posPaymentEnable;
  String? bankCode;
  String? vchCreateType;

  VoucherEntity();

  VoucherEntity.formMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    vchTypeCode = map['vchtype_code'];  
    vchTypeName = map['vchtype_name'];
    parent = map['parent'];
    cyDate = map['cy_date'];//map['cy_date'] == ''?'':DateFormat('yyyy-MM-dd').format(map['cy_date']);
    cyPfx = map['cy_prefix'];
    nyDate = map['ny_date'];//map['ny_date'] == ''?'':DateFormat('yyyy-MM-dd').format(map['ny_date']);
    nyPfx = map['ny_prefix'];
    bankName = map['bank_name'];
    posPaymentEnable = map['pos_payment'];
    bankCode = map['bank_code'];
    vchCreateType = map['vch_create_type'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (vchTypeCode != null) {
      map['vchtype_code'] = vchTypeCode;
    }
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (vchTypeName != null) {
      map['vchtype_name'] = vchTypeName;
    }
    if (parent != null) {
      map['parent'] = parent;
    }
    if (cyDate != null) {
      map['cy_date'] = cyDate;//DateFormat('yyyy-MM-dd').format(cyDate!);
    }
    if(cyPfx != null) {
      map['cy_prefix'] = cyPfx;
    }
    if(nyDate != null) {
      map['ny_date'] = nyDate;//DateFormat('yyyy-MM-dd').format(nyDate!);
    }
    if(nyPfx != null) {
      map['ny_prefix'] = nyPfx;
    }
    if(posPaymentEnable != null) {
      map['pos_payment'] = posPaymentEnable; //komal D 18-10-2024
    }
    if(bankName != null) {
      map['bank_name'] = bankName; //komal D 18-10-2024
    }
    if(bankCode != null) {
      map['bank_code'] = bankCode; //Sonali  16-11-2024
    }
    return map;
  }
}