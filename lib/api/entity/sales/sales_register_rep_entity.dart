class SalesRegisterReportEntity {
  String? uniqueid;
  String? type;
  String? invoiceno;
  String? partyName;
  String? vouchertype;
  String? totalqty;
  String? date;
  String? totalammount;
  String? tallystatus;
  String? tallysyncdate;
  String? deletestatus;
  String? mode;
  String? bbpsUploadStatus;
  String? bbpsB2bId;
  String? vouchername;//komal d 23-11-2024 added


  SalesRegisterReportEntity(
      {this.uniqueid,
      this.invoiceno,
      this.vouchertype,
      this.totalqty,
      this.date,
      this.totalammount,
      this.tallystatus,
      this.tallysyncdate,
      this.deletestatus,
      this.mode,
      this.bbpsUploadStatus,
      this.vouchername});

  SalesRegisterReportEntity.fromJson(Map<String, dynamic> json) {
    uniqueid = json["unique_id"];
    type = json["type"];
    invoiceno = json["invoice_no"];
    partyName = json["party_name"];
    vouchertype = json["voucher_type"];
    totalqty = json["total_qty"];
    date = json["date"];
    totalammount = json["total_ammount"];
    tallystatus = json["tally_status"];
    tallysyncdate = json["tally_status_date"];
    deletestatus = json["delete_status"];
    mode = json["mode"];
    bbpsUploadStatus = json['bbps_upload_status'];
    bbpsB2bId = json['bbps_b2b_id'];
    vouchername = json['voucher_name'];
  }

  SalesRegisterReportEntity.fromallJson(Map<String, dynamic> json) {
    uniqueid = json['unique_id'];
    partyName = json['party_name'];
    totalammount = json['totalammount'];
    invoiceno = json['invoice_no'];
    date = json['date'];
    vouchertype = json['voucher_type'];
    totalqty = json['total_qty'];
    type = json["type"];
  }
}
