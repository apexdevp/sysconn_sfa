class SOAddToCartEntity {
  String? companyId;
  String? mobileNo;
  String? hedUniqueId;
  String? partyName;
  String? date;
  String? issueSlipNo;
  String? itemId;
  String? quantity;
  String? rate;
  String? discount;
  String? value;
  String? imagePath;
  String? itemName;
  String? gstRate;
  String? cessRate;
  String? gstValue;
  String? cessValue;
  String? netValue;
  String? returnQty;
  String? hsnCode;
  String? unitName;
  String? remark; //pratiksha p 01-07-2023 add remark
  String? totalPoints; //snehal 29-04-2023 add for scheme module
  String? pointsPerUnit; //snehal 29-04-2023 add for scheme module
  String? approvalstatus; //pratiksha p 06-02-2025 add
  SOAddToCartEntity();

  SOAddToCartEntity.fromMap(Map<String, dynamic> json) {
    companyId = json['Company_Id'];
    mobileNo = json['Mobile_No'];
    hedUniqueId = json['hed_unique_id'];
    partyName = json['party_name'];
    date = json['date'];
    issueSlipNo = json['issue_slip_no'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    rate = json['rate'];
    discount = json['discount'];
    value = json['value'];
    imagePath = json['image_path'];
    itemName = json['item_name'];
    gstRate = json['gst_rate'];
    cessRate = json['cess_rate'];
    gstValue = json['gst_value'];
    cessValue = json['cess_value'];
    netValue = json['net_value'];
    returnQty = json['return_quantity'];
    // rateController = new TextEditingController();
    // discountController = new TextEditingController();
    // quantityController = new TextEditingController();
    hsnCode = json['hsn_code']; //snehal 06-08-2022 add hsncode
    unitName = json['unit_name']; //snehal 06-08-2022 add unit_name
    remark = json['remark']; //pratiksha p 01-07-2023 add remark
    pointsPerUnit =
        json['points_per_unit']; //snehal 29-04-2023  add for scheme module
    totalPoints = json['total_points']; //snehal 29-04-2023
    approvalstatus =
        json['so_inv_approval_status']; //pratiksha p 06-02-2025 add
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (mobileNo != null) {
      map['mobile_no'] = mobileNo;
    }
    if (hedUniqueId != null) {
      map['hed_unique_id'] = hedUniqueId;
    }
    if (itemId != null) {
      map['item_id'] = itemId;
    }
    if (quantity != null) {
      map['quantity'] = quantity;
    }
    if (rate != null) {
      map['rate'] = rate;
    }
    if (discount != null) {
      map['discount'] = discount;
    }
    if (value != null) {
      map['value'] = value;
    }
    if (gstRate != null) {
      map['gst_rate'] = gstRate;
    }
    if (cessRate != null) {
      map['cess_rate'] = cessRate;
    }
    if (gstValue != null) {
      map['gst_value'] = gstValue;
    }
    if (cessValue != null) {
      map['cess_value'] = cessValue;
    }
    if (netValue != null) {
      map['net_value'] = netValue;
    }
    if (returnQty != null) {
      map['return_quantity'] = returnQty;
    }
    if (remark != null) {
      //pratiksha p 01-07-2023
      map['remark'] = remark;
    }
    if (approvalstatus != null) {//pratiksha p 06-02-2025 add
      map['so_approval_status'] = approvalstatus;
    }
    if (pointsPerUnit != null) {
      map['points_per_unit'] = pointsPerUnit;
    }
    if (totalPoints != null) {
      map['total_points'] = totalPoints;
    }
    return map;
  }
}
