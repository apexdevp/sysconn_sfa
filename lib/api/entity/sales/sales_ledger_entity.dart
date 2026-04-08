class SalesLedgerEntity{
  String? companyid;
  String? mobileno;
  String? ledgerUniqueId;
  String? hedUniqueId;
  String? ledgerId;
  String? discount;
  String? ledgerName;
  String? amount;
 String? partyName;
  String? hsnCode;
  String? taxRate;
  String? cessper;
  String? dutyType;
  String? ledType;
  String? claimedAmount;
  String? rejectAmount;

  SalesLedgerEntity({
    this.companyid,
    this.mobileno,
    this.ledgerUniqueId,
    this.hedUniqueId,
    this.ledgerId,
    this.ledgerName,
    this.amount,
    this.cessper,this.discount,this.dutyType,this.hsnCode,this.partyName,this.taxRate
  });

  SalesLedgerEntity.fromMap(Map<String,dynamic> json){
    ledgerId = json['ledger_id'];
    ledgerName   = json['ledger_name'];
    amount = double.parse(json["amount"].toString()).toStringAsFixed(1);
    discount   = json['discount'];
    ledgerUniqueId = json["led_unique_id"];
    ledType = json["led_type"];
  }

  SalesLedgerEntity.fromJson(Map<String, dynamic> json) {
    partyName = json['party_name'];
    amount = json['amount'];
  hsnCode = json['hsn_code'];
    taxRate = json['gstper'];
    cessper = json['cessper'];
    dutyType = json['duty_type'];
  }
  
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (companyid != null) {
      data['company_id'] = companyid;
    }
    if (mobileno != null) {
      data['mobile_no'] = mobileno;
    }
    if (ledgerUniqueId != null) {
      data['led_unique_id'] = ledgerUniqueId;
    }
    if (hedUniqueId != null) {
      data['hed_unique_id'] = hedUniqueId;
    }
    if (ledgerId != null) {
      data['ledger_id'] = ledgerId;
    }
    if (ledgerName != null) {
      data['ledger_name'] = ledgerName;
    }
    if (amount != null) {
      data['amount'] = amount;
    }
    if (discount != null) {
      data['discount'] = discount;
    }
    //snehal add for expenses
    if (claimedAmount != null) {
      data['claimed_amt'] = claimedAmount;
    }
    if (rejectAmount != null) {
      data['reject_amt'] = rejectAmount;
    }
    return data;
  }
}