class PartyNotesResponse {
  final List<PartyNotesDetailsEntity> notesdetails;
  final List<PartyNotesCategoryEntity> category;

  PartyNotesResponse({required this.notesdetails, required this.category});
}

class PartyNotesDetailsEntity {
  String? noteId;
  String? categoryId;
  String? companyId;
  String? retailerCode;
  String? categoryName;
  String? title;
  String? description;
  String? createdat;
  String? updatedat;

  String? emailId;              //shweta 19-04-26
  String? type;                   //shweta 19-04-26
  String? typeId;                   //shweta 19-04-26

  PartyNotesDetailsEntity();

  PartyNotesDetailsEntity.formPartyMap(Map<String, dynamic> map) {
    noteId = map['noteid'];
    categoryId = map['categoryid'];
    companyId = map['company_id'];
    retailerCode = map['retailer_code'];
    categoryName = map['categoryname'];
    title = map['title'];
    description = map['description'];
    createdat = map['createdat'];
    updatedat = map['updatedat'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (noteId != null) {
      map['noteid'] = noteId;
    }
    if (categoryId != null) {
      map['categoryid'] = categoryId;
    }
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (retailerCode != null) {
      map['retailer_code'] = retailerCode;
    }
    if (categoryName != null) {
      map['categoryname'] = categoryName;
    }
    if (title != null) {
      map['title'] = title;
    }
    if (description != null) {
      map['description'] = description;
    }
    if (createdat != null) {
      map['createdat'] = createdat;
    }
    if (updatedat != null) {
      map['updatedat'] = updatedat;
    }

    if (emailId != null) {                      //shweta 19-04-26
      map['email_id'] = emailId;
    }

    if (type != null) {                           //shweta 19-04-26
      map['type'] = type;
    }

    if (typeId != null) {                           //shweta 19-04-26
      map['typeId'] = typeId;
    }

    return map;
  }
}

class PartyNotesCategoryEntity {
  String? categoryId;
  String? name;

  PartyNotesCategoryEntity();

  PartyNotesCategoryEntity.formPartyDesignationMap(Map<String, dynamic> map) {
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
