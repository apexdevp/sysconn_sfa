// class ExpensesLedgerEntity {
//   String? partnerCode;
//   String? companyId;
//   String? headerUniqueId;
//   String? ledgerId;
//   String? ledgerName;
//   String? ledgerAmount;
//   int? claimedAmount;
//   int? rejectAmount;
//   String? npciLedgerName;
//   String? type;
//   String? partyName;
//   String? partyId;
//   String? ledgerUniqueId;
//   ExpensesLedgerEntity({
//     this.ledgerAmount,
//     this.companyId,
//     this.partnerCode,
//     this.ledgerId,
//     this.headerUniqueId,
//     this.ledgerName,
//     this.partyName,
//   });

//   ExpensesLedgerEntity.fromALLJson(Map<String, dynamic> json) {
//     ledgerAmount = json['amount'];
//     ledgerId = json['ledger_id'];
//     headerUniqueId = json['header_unique_id'];
//     ledgerName = json['ledger_name'];
//     companyId = json['company_id'];
//     claimedAmount =
//         json['claimed_amt']; 
//     rejectAmount =
//         json['reject_amt']; 
//         ledgerUniqueId =json['unique_id'];
        
//   }

//   ExpensesLedgerEntity.formMap(Map<String, dynamic> map) {
//     companyId = map['company_id'];
//     type = map['type'];
//     ledgerId = map['ledger_id'];
//     ledgerName = map['ledger_name'];
//     npciLedgerName = map['npci_ledger_name'];
//      partyName =
//         map['party_name']; 
//         partyId = map['party_id'];
//   }
//   Map<String, dynamic> toALLJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();

//     if (ledgerAmount != null) {
//       data['AMOUNT'] = this.ledgerAmount;
//     }
//     if (companyId != null) {
//       data['COMPANY_ID'] = this.companyId;
//     }
//     if (partnerCode != null) {
//       data['PARTNER_CODE'] = this.partnerCode;
//     }

//     if (ledgerId != null) {
//       data['LEDGER_ID'] = this.ledgerId;
//     }

//     if (headerUniqueId != null) {
//       data['HEADER_UNIQUE_ID'] = this.headerUniqueId;
//     }
//     if (ledgerName != null) {
//       data['LEDGER_NAME'] = this.ledgerName;
//     }
//     if (claimedAmount != null) {
//       data['CLAIMED_AMT'] =
//           this.claimedAmount; 
//     }
//     if (rejectAmount != null) {
//       data['REJECT_AMT'] =
//           this.rejectAmount;
//     }

//     return data;
//   }
// }
