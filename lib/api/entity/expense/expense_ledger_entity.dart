class ExpensesLedgerEntity {
  // String? mobileno;
  String? groupid;
  String? companyId;
  String? headerUniqueId;
  String? ledUniqueId;
  String? ledgerId;
  String? ledgerName;
  String? ledgerAmount;
  String? claimedAmount;
  String? rejectAmount;
  // String? npciLedgerName;
  // String? type;
  // String? partyName;
  // String? partyId;
  // String? ledgerUniqueId;

  ExpensesLedgerEntity();

  // ExpensesLedgerEntity.fromALLJson(Map<String, dynamic> json) {
  //   companyId = json['company_id'];
  //   headerUniqueId = json['hed_unique_id'];
  //   ledUniqueId = json['ledger_unique_id'];
  //   ledgerId = json['ledger_id'];
  //   ledgerName = json['ledger_name'];
  //   ledgerAmount =json['amount'] != ''?num.parse(json['amount']).toStringAsFixed(2):'';
  //   claimedAmount = json['claimed_amt']!= ''?num.parse(json['claimed_amt']).toStringAsFixed(2):''; 
  //   rejectAmount = json['reject_amt']!= ''?num.parse(json['reject_amt']).toStringAsFixed(2):'';
  //   // ledgerUniqueId =json['unique_id']; 
  // }

 String _toFixed(dynamic value) {
    if (value == null) return '';
    final num? n = num.tryParse(value.toString());
    return n == null ? '' : n.toStringAsFixed(2);
  }

  ExpensesLedgerEntity.fromALLJson(Map<String, dynamic> json) {
    companyId = json['company_id']?.toString();
    headerUniqueId = json['hed_unique_id']?.toString();
    ledUniqueId = json['ledger_unique_id']?.toString();
    ledgerId = json['ledger_id']?.toString();
    ledgerName = json['ledger_name']?.toString();

    ledgerAmount = _toFixed(json['amount']);
    claimedAmount = _toFixed(json['claimed_amt']);
    rejectAmount = _toFixed(json['reject_amt']);
  }
  // ExpensesLedgerEntity.formMap(Map<String, dynamic> map) {
  //   companyId = map['company_id'];
  //   // type = map['type'];
  //   ledgerId = map['ledger_id'];
  //   ledgerName = map['ledger_name'];
  //   // npciLedgerName = map['npci_ledger_name'];
  //   //  partyName =
  //       map['party_name']; 
  //       // partyId = map['party_id'];
  // }
  
  Map<String, dynamic> toALLJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (groupid != null) {
      data['group_id'] = groupid;
    }
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (ledgerId != null) {
      data['ledger_id'] = ledgerId;
    }
    // if (ledgerUniqueId != null) {
    //   data['unique_id'] = ledgerUniqueId;
    // }
    if (headerUniqueId != null) {
      data['hed_unique_id'] = headerUniqueId;
    }
    if (ledUniqueId != null) {
      data['ledger_unique_id'] = ledUniqueId;
    }
    if (ledgerAmount != null) {
      data['amount'] = ledgerAmount;
    }
    if (claimedAmount != null) {
      data['claimed_amt'] = claimedAmount; 
    }
    if (rejectAmount != null) {
      data['reject_amt'] = rejectAmount;
    }

    return data;
  }
}
