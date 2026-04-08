class PartyContactEntity {
  String? contactId;
  String? companyId;
  String? retailerCode;
  String? categoryId;
  String? categoryName;
  String? firstName;
  String? lastName;
  String? email1;
  String? email2;
  String? contact1;
  String? contact2;
  String? status;
  String? remark;
  String? isPrimary; //Manisha C 28-03-2026 added

  PartyContactEntity();

  PartyContactEntity.formPartyMap(Map<String, dynamic> map) {
    contactId = map['contactid'];
    companyId = map['companyid'];
    retailerCode = map['retailer_code'];
    categoryId = map['categoryid'];
    categoryName = map['categoryname'];
    firstName = map['firstname'];
    lastName = map['lastname'];
    email1 = map['email1'];
    email2 = map['email2'];
    contact1 = map['contact1'];
    contact2 = map['contact2'];
    status = map['status'];
    remark = map['remark'];
    isPrimary = map['isprimary']; //Manisha C 28-03-2026 added
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (contactId != null) {
      map['contactid'] = contactId;
    }
    if (companyId != null) {
      map['companyid'] = companyId;
    }
    if (retailerCode != null) {
      map['retailer_code'] = retailerCode;
    }
    if (categoryId != null) {
      map['categoryid'] = categoryId;
    }
    if (categoryName != null) {
      map['categoryname'] = categoryName;
    }
    if (firstName != null) {
      map['firstname'] = firstName;
    }
    if (lastName != null) {
      map['lastname'] = lastName;
    }
    if (email1 != null) {
      map['email1'] = email1;
    }
    if (email2 != null) {
      map['email2'] = email2;
    }
    if (contact1 != null) {
      map['contact1'] = contact1;
    }
    if (contact2 != null) {
      map['contact2'] = contact2;
    }
    if (status != null) {
      map['status'] = status;
    }
    if (remark != null) {
      map['remark'] = remark;
    }
    //Manisha C 28-03-2026 added
    if (isPrimary != null) {
      map['isprimary'] = isPrimary;
    }
    
    return map;
  }
}
