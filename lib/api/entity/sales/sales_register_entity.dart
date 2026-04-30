class SalesRegisterEntity{
  String? uniqueid;
  String? type;
  String? invoiceno;
  String? partyName;
  String? vouchertype;
  String? voucherTypeName;
  String? totalqty;
  String? date;
  String? totalammount;
  String? tallystatus; //pooja // 21-06-2024 // add tallystatus,tallysyncdate,deletestatus,mode
  String? tallysyncdate;
  String? deletestatus;
  String? mode;
  String? approvalstatus; //pratiksha p 20-10-2024 add
  String? companyid; //pratiksha p 21-10-2024 add
  String? issueslipno; //pooja // 17-03-2026 // add
  String? cashamount;
  String? bankamount;
  String? cardamount;
  String? vouchergift;
  String? totalamt;
  String? balance;
  //pooja // 02-04-2026 // add
  String? partyname;
  String? group;
  String? salesperson;
  String? city;
  String? area;
  String? billingamount;
  String? totalcollection;
  String? os;

  SalesRegisterEntity({this.uniqueid,this.invoiceno,this.vouchertype,this.totalqty,this.date,this.totalammount,
   this.tallystatus,this.tallysyncdate,this.deletestatus,this.mode});
  
  SalesRegisterEntity.fromJson(Map<String,dynamic>json){
    uniqueid = json["unique_id"];
    type = json["type"];
    invoiceno = json["invoice_no"];
    partyName = json["party_name"];
    vouchertype = json["voucher_type"];
    voucherTypeName = json["voucher_name"];
    totalqty = json["total_qty"];
    date = json["date"];
    totalammount = json["total_ammount"] == ''?'0':num.parse(json["total_ammount"]).toStringAsFixed(2);
    tallystatus= json["tally_status"]; //pooja // 21-06-2024 // add tallystatus,tallysyncdate,deletestatus,mode
    tallysyncdate= json["tally_status_date"];
    deletestatus= json["delete_status"];
    mode= json["mode"];
    approvalstatus = json['approval_status']; //pratiksha p 20-10-2024
    issueslipno=json['issue_slip_no'];//pratiksha p 17-03-2026 add
        //pooja // 17-03-2026
    cashamount = (num.tryParse(json['cash_amount']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    cardamount = (num.tryParse(json['card_amount']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    bankamount = (num.tryParse(json['bank_amount']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    vouchergift = (num.tryParse(json['voucher_gift']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    totalamt = (num.tryParse(json['amount']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    balance = (num.tryParse(json['balance']?.toString() ?? '') ?? 0).toStringAsFixed(2);
  }

  //pooja // 02-04-2026 // add
  SalesRegisterEntity.fromoutstandingJson(Map<String,dynamic>json){
    partyname = json["party_name"];
    group = json["group"];
    salesperson = json["sales_person"];
    city = json["city"];
    area = json["areaname"];
    billingamount = (num.tryParse(json['billing_amount']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    cashamount = (num.tryParse(json['cash']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    cardamount = (num.tryParse(json['card']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    bankamount = (num.tryParse(json['bank']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    vouchergift = (num.tryParse(json['voucher_gift']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    totalcollection = (num.tryParse(json['total_collection']?.toString() ?? '') ?? 0).toStringAsFixed(2);
    os = (num.tryParse(json['os']?.toString() ?? '') ?? 0).toStringAsFixed(2);
  }

//pratiksha p 21-10-2024 add
    Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uniqueid != null) {
      data['unique_id'] = uniqueid;
    }
    if (approvalstatus != null) {
      data['status'] = approvalstatus;
    }
    if (companyid != null) {
      data['company_id'] = companyid;
    }

    return data;
  }
}