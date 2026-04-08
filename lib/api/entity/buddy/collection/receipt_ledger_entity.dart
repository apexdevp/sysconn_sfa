class ReceiptLedgerEntity{
  String? companyId;
  String? hedUniqueId;
  String? uniqueId;
  String? partyId;
  String? partyname;
  String? ledgerId;
  String? ledgername;
  String? name;
  String? amount;
  String? type;

  ReceiptLedgerEntity();

  ReceiptLedgerEntity.fromJson(Map<String, dynamic> json){
    partyId = json["ledger_id"];
    uniqueId = json["led_unique_id"];
    amount = json["amount"];
    partyname = json["party_name"];
    ledgername = json["ledger_name"];
    type = json["led_type"];
    name=json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if( companyId!= null){
      data['company_id'] = companyId;
    }
    if(uniqueId!= null){
      data['unique_id'] = uniqueId;
    }
    if(hedUniqueId!= null){
      data['hed_unique_id'] = hedUniqueId;
    }
    if(partyId != null){
      data['party_id'] = partyId;
    }
    if(ledgerId != null){
      data['ledger_id'] = ledgerId;
    }
    if(amount != null){
      data['amount'] = amount;
    }
    if(type != null){
      data['type'] = type;
    }
    return data;
  }
}