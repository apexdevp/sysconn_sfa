import 'package:sysconn_sfa/utils/databaseconstants.dart';

class LeadDetailsEntity {
  String? companyId;
  String? partnerCode;
  String? itemName;
  String? quantity;
  String? rate;
  String? discount;
  String? mobileNo;
  String? leadId;
  String? visitId;
  String? productId;
  String? date;
  String? value;
  String? productRemark;
  String? productRemark2;
  String? productRemark3;
  String? nextFollowupDate;
  String? leadPriority;
  String? status;
  String? designation;
  String? contactPerson;
  String? emailId;
  String? location;
  String? type;
  String? partyName;
  String? salesPersonName;
  String? partyMobileNo;
  String? hsncode;
  String? taxrate;
  String? unitname;

  LeadDetailsEntity({
    this.itemName,
    this.quantity,
    this.rate,
    this.companyId,
    this.discount,
    this.partnerCode,
    this.mobileNo,
    this.status,
    this.productId,
    this.productRemark,
    this.productRemark2,
    this.productRemark3,
    this.leadId,
    this.visitId,
    this.date,
    this.value,
    this.nextFollowupDate,
    this.leadPriority,
    this.type,
    this.partyName,
    this.salesPersonName,
    this.designation,
    this.contactPerson,
    this.emailId,
    this.location,
    this.partyMobileNo,
    this.hsncode,
    this.taxrate,
    this.unitname,
  });

  LeadDetailsEntity.fromJson(Map<String, dynamic> json) {
    itemName = json['ITEM_NAME'];
    rate = json['RATE'];
    quantity = json['QUANTITY'];
    discount = json['DISCOUNT'];
    productRemark = json['PRODUCT_REMARK'];
    productRemark2 = json['PRODUCT_REMARK_2'];
    productRemark3 = json['PRODUCT_REMARK_3'];
    date = json['DATE'];
    mobileNo = json['MOBILE_NO'];
    companyId = json['COMPANY_ID'];
    partnerCode = json['PARTNER_CODE'];
    value = json['VALUE'];
    leadId = json['LEAD_ID'];
    visitId = json['VISIT_ID'];
    productId = json['PRODUCT_ID'];
    status = json['STATUS'];
    nextFollowupDate = json['NEXT_FOLLOWUP_DATE'];
    leadPriority = json['LEAD_PRIORITY'];
    hsncode = json['HSN_CODE'];
    taxrate = json['TAX_RATE'];
    unitname = json['UNIT_NAME'];
  }

  LeadDetailsEntity.fromLeadRptJson(Map<String, dynamic> json) {
    date = json['date'];
    type = json['type'];
    leadId = json['lead_id'];
    partyName = json['party_name'];
    itemName = json['item_name'];
    quantity = json['quantity'];
    rate = json['rate'];
    value = json['value'] != ''
        ? num.parse(json['value']).toStringAsFixed(2)
        : '';
    status = json['status'];
    nextFollowupDate = json['next_followup_date'];
    salesPersonName = json['sales_person_name'];
    leadPriority = json['lead_priority'];
    productRemark = json['product_remark'];
    productRemark2 = json['product_remark_2'];
    productRemark3 = json['product_remark_3'];
    mobileNo = json['mobile_no'];
    designation = json['designation'];
    contactPerson = json['contact_person'];
    emailId = json['email_id'];
    location = json['location'];
    visitId = json['visit_id'];
    partyMobileNo = json['party_mobile_no'];
    hsncode = json['HSN_CODE'];
    taxrate = json['TAX_RATE'];
    unitname = json['UNIT_NAME'];
    discount = json['discount'];
    productId = json['PRODUCT_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data[DbConstants.companyid] = companyId;
    }
    if (partnerCode != null) {
      data[DbConstants.col2] = partnerCode;
    }
    if (mobileNo != null) {
      data[DbConstants.mobileNo] = mobileNo;
    }
    if (visitId != null) {
      data['VISIT_ID'] = visitId;
    }
    if (productId != null) {
      data['PRODUCT_ID'] = productId;
    }
    if (quantity != null) {
      data['QUANTITY'] = quantity;
    }
    if (rate != null) {
      data['RATE'] = rate;
    }
    if (discount != null) {
      data['DISCOUNT'] = discount;
    }
    if (value != null) {
      data['VALUE'] = value;
    }
    if (productRemark != null) {
      data['PRODUCT_REMARK'] = productRemark;
    }
    if (productRemark2 != null) {
      data['PRODUCT_REMARK_2'] = productRemark2;
    }
    if (productRemark3 != null) {
      data['PRODUCT_REMARK_3'] = productRemark3;
    }
    if (status != null) {
      data['STATUS'] = status;
    }
    if (nextFollowupDate != null) {
      data['NEXT_FOLLOWUP_DATE'] = nextFollowupDate;
    }
    if (leadPriority != null) {
      data['LEAD_PRIORITY'] = leadPriority;
    }
    if (hsncode != null) {
      data['HSN_CODE'] = hsncode;
    }
    if (taxrate != null) {
      data['TAX_RATE'] = taxrate;
    }
    if (unitname != null) {
      data['UNIT_NAME'] = unitname;
    }
    return data;
  }
}
