

class CompanyProfileEntity {
  String? customerattributeid;
  String? label;
  String? value;
  String? customerfieldid;
  //TextEditingController controller = TextEditingController(); 

  CompanyProfileEntity({
    this.customerattributeid,
    this.label,
    this.value,
    this.customerfieldid,
  });

  CompanyProfileEntity.fromMap(Map<String, dynamic> map) {
    customerattributeid = map['customerattributeid'];
    label = map['label'];
    value = map['value'];
    customerfieldid = map['customerfieldid'];
  }

  Map<String, dynamic> toMap() {
    return {
      "customerattributeid": customerattributeid,
      "label": label,
      "value": value,
      "customerfieldid": customerfieldid,
    };
  }
}