class LedgerMasterEntity {
  String? companyId;
  String? type;
  String? ledgerId;
  String? ledgerName;
  String? npciLedgerName;
  String? partyId;
  String? partyName;
  LedgerMasterEntity();

  LedgerMasterEntity.formMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    type = map['type'];
    ledgerId = map['ledger_id'];  
    ledgerName = map['ledger_name'];
    npciLedgerName = map['npci_ledger_name'];
    partyId = map['party_id'];
    partyName = map['party_name'];
  }
 LedgerMasterEntity.formJson(Map<String, dynamic> map) {
    companyId = map['company_id'];
    type = map['type'];
    ledgerId = map['party_id'];  
    ledgerName = map['party_name'];
    npciLedgerName = map['npci_ledger_name'];
    partyId = map['party_id'];
    partyName = map['party_name'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (type != null) {
      map['type'] = type;
    }
    if (ledgerId != null) {
      map['ledger_id'] = ledgerId;
    }
    if (ledgerName != null) {
      map['ledger_name'] = ledgerName;
    }
    if(npciLedgerName != null) {
      map['npci_ledger_name'] = npciLedgerName;
    }
    return map;
  }
}