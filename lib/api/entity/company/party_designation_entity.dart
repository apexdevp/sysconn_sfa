class PartyDesignationEntity {
  String? categoryId;
  String? name;

  PartyDesignationEntity();

  PartyDesignationEntity.formPartyDesignationMap(Map<String, dynamic> map) {
    categoryId = map['categoryid'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (categoryId != null) {
      map['categoryid'] = categoryId;
    }
    if (name != null) {
      map['name'] = name;
    }

    return map;
  }
}
