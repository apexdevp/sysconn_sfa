class FilterTypeCategoryListEntity {
  String? distributorcode;
  String? partyid;
  String? salesperson;
  String? area;
  String? beat;
  String? route;
  String? customertype;
  String? customerclassification;

  FilterTypeCategoryListEntity();

  FilterTypeCategoryListEntity.fromMap(Map<String, dynamic> map) {
    distributorcode = map['distributor_code'];
    partyid = map['party_id'];
    salesperson = map['sales_person'];
    area = map['area'];
    beat = map['beat'];
    route = map['route'];
    customertype = map['customertype'];
    customerclassification = map['customerclassification'];
  }
}