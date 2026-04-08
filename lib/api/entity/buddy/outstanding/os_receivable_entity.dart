class OutstandingRecPayDetailEntity {
  String? id;
  String? partyname;
  String? pendingamount;
  String? creditdays;
  String? billdate;
  String? billno;
  String? duedate;
  String? type;
  String? masterid;
  String? bankName;
 String? ifcsCode;
  String? accountNo;
   String? branch;
  OutstandingRecPayDetailEntity({
    this.billdate,
    this.billno,
    this.creditdays,
    this.duedate,
    this.id,
    this.partyname,
    this.pendingamount,
    this.type,
    this.masterid,
    this.accountNo,this.bankName,this.branch,this.ifcsCode
  });

  OutstandingRecPayDetailEntity.fromJson(Map<String, dynamic> json) {
    pendingamount = json['pending_amount'];
    billdate = json['bill_date'];
    billno = json['bill_no'];
    duedate = json['due_date'];
    type = json['type'];
    masterid=json['master_id'];
    bankName=json['bank_name'];
    ifcsCode =json['ifsc_code'];
   branch= json['branch'];
   accountNo=json['account_no'];
  }
}
