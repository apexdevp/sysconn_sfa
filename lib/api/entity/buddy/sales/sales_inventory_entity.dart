class SalesInventoryEntity{
  String? companyid;
  String? mobileno;
  String? invId;
  String? hedUniqueId;
  String? itemId;
  String? itemName;
  String? qty;
  String? rate;
  // String? partyId;
  String? discount;
  String? value;
  String? gstrate;
  String? cessrate;
  String? gstvalue;
  String? cessvalue;
  String? netValue;
  String? remark;
  String? soVchNo;
  String? soVchDate;
  // String? soVchQty;
  // String? soVchAmt;
  String? hsnCode;
  String? unit;
  String? altQty;
  String? altQtyPer;
  String? itemDescription;
  double? taxRate;
  double? cessper;
  String? unitName;
  String? postingledgerid;//pooja // 13-11-2024
  String? godownid;//pooja // 13-11-2024
  String? postingledgerName;
  String? godownName;

  SalesInventoryEntity({
    this.companyid,
    this.mobileno,
    this.invId,
    this.hedUniqueId,
    this.itemId,
    this.qty,
    this.rate,
    // this.partyId,
    this.discount,
    this.value,
    this.gstrate,
    this.cessrate,
    this.gstvalue,
    this.cessvalue,
    this.netValue,
    this.remark,
    this.soVchNo,
    this.soVchDate,
    this.postingledgerid,//pooja // 13-11-2024 
    this.godownid, //pooja // 13-11-2024 
  });

  SalesInventoryEntity.fromMap(Map<String,dynamic> json){
    invId = json['inv_id'];
    itemId = json["item_id"];
    itemName = json["item_name"];
    qty = json['qty'];
    rate = json['rate'];
    discount = json['discount'];
    hsnCode = json["hsn_code"];
    unit = json["unit"];
    gstrate = json["gst_rate"];
    cessrate = json["cess_rate"];
    gstvalue = json["gst_value"];
    cessvalue = json["cess_value"];
    netValue = json["net_value"];
    remark = json["remark"];
    value = json["value"];
    altQty = json['alt_qty'];
    altQtyPer = json['alt_qty_per'];
    postingledgerid = json['posting_led_id'];
    postingledgerName = json['posting_led_name'];
    godownid = json['godown_id'];
    godownName = json['godown_name'];
  }
  
  SalesInventoryEntity.fromJson(Map<String, dynamic> json) {
    itemDescription = json['item_description'];
    qty = json['qty'];
    rate = json['rate'];
    discount = json['discount'];
    value = json['value'];
    hsnCode = json['hsn_code'];
    taxRate = json['gstper'];
    cessper = json['cessper'];
    unitName = json['unit_name'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (companyid != null) {
      data['company_id'] = companyid;
    }
    if (mobileno != null) {
      data['mobile_no'] = mobileno;
    }
    if (invId != null) {
      data['inv_id'] = invId;
    }
    if (hedUniqueId != null) {
      data['hed_unique_id'] = hedUniqueId;
    }
    if (itemId != null) {
      data['item_id'] = itemId;
    }
    if (qty != null) {
      data['qty'] = qty;
    }
    if (rate != null) {
      data['rate'] = rate;
    }
    // if (partyId != null) {
    //   data['party_id'] = partyId;
    // }
    if (discount != null) {
      data['discount'] = discount;
    }
    if (value != null) {
      data['value'] = value;
    }
    if (gstrate != null) {
      data['gst_rate'] = gstrate;
    }
    if (cessrate != null) {
      data['cess_rate'] = cessrate;
    }
    if (gstvalue != null) {
      data['gst_value'] = gstvalue;
    }
    if (cessvalue != null) {
      data['cess_value'] = cessvalue;
    }
    if (netValue != null) {
      data['net_value'] = netValue;
    }
    if (remark != null) {
      data['remark'] = remark;
    }
    if (altQty != null) {
      data['alt_qty'] = altQty;
    }
    if(altQtyPer != null) {
      data['alt_qty_per'] = altQtyPer;
    }
    if (soVchNo != null) {
      data['so_vch_no'] = soVchNo;
    }
    if (soVchDate != null) {
      data['so_vch_date'] = soVchDate;
    }
    //pooja// 13-11-2024 // add 
    if (postingledgerid != null) {
      data['posting_ledger_id'] = postingledgerid;
    }
    if (godownid != null) {
      data['godown_id'] = godownid;
    }
    return data;
  }
}