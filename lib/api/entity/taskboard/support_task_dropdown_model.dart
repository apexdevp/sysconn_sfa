import 'dart:convert';

SupportTaskDropdownModel supportTaskDropdownModelFromJson(String str) =>
    SupportTaskDropdownModel.fromJson(json.decode(str));

class SupportTaskDropdownModel {
  Data? data;

  SupportTaskDropdownModel({this.data});

  SupportTaskDropdownModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {"data": data?.toJson()};
  }
}

class Data {
  List<CustomerList>? customerlist;
  List<EventList>? eventlist;
  List<AssignedTo>? assignedto;
  List<QueryCategory>? querycategory;
  List<SubQueryCategory>? subquerycategory;
  List<OwnershipCategory>? ownershipcategory;

  Data({
    this.customerlist,
    this.eventlist,
    this.assignedto,
    this.querycategory,
    this.subquerycategory,
    this.ownershipcategory,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['customerlist'] != null) {
      customerlist = [];
      json['customerlist'].forEach((v) {
        customerlist!.add(CustomerList.fromJson(v));
      });
    }

    if (json['eventlist'] != null) {
      eventlist = [];
      json['eventlist'].forEach((v) {
        eventlist!.add(EventList.fromJson(v));
      });
    }

    if (json['assignedto'] != null) {
      assignedto = [];
      json['assignedto'].forEach((v) {
        assignedto!.add(AssignedTo.fromJson(v));
      });
    }

    if (json['querycategory'] != null) {
      querycategory = [];
      json['querycategory'].forEach((v) {
        querycategory!.add(QueryCategory.fromJson(v));
      });
    }

    if (json['subquerycategory'] != null) {
      subquerycategory = [];
      json['subquerycategory'].forEach((v) {
        subquerycategory!.add(SubQueryCategory.fromJson(v));
      });
    }

    if (json['ownershipcategory'] != null) {
      ownershipcategory = [];
      json['ownershipcategory'].forEach((v) {
        ownershipcategory!.add(OwnershipCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "customerlist": customerlist?.map((e) => e.toJson()).toList(),
      "eventlist": eventlist?.map((e) => e.toJson()).toList(),
      "assignedto": assignedto?.map((e) => e.toJson()).toList(),
      "querycategory": querycategory?.map((e) => e.toJson()).toList(),
      "subquerycategory": subquerycategory?.map((e) => e.toJson()).toList(),
      "ownershipcategory": ownershipcategory?.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomerList {
  String? companyId;
  String? tallyRetailerCode;
  String? retailerName;

  CustomerList({this.companyId, this.tallyRetailerCode, this.retailerName});

  CustomerList.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    tallyRetailerCode = json['tally_retailer_code'];
    retailerName = json['retailer_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "tally_retailer_code": tallyRetailerCode,
      "retailer_name": retailerName,
    };
  }
}

class EventList {
  String? companyId;
  String? categoryid;
  String? categorytypeid;
  String? name;

  EventList({this.companyId, this.categoryid, this.categorytypeid, this.name});

  EventList.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    categoryid = json['categoryid'];
    categorytypeid = json['categorytypeid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "categoryid": categoryid,
      "categorytypeid": categorytypeid,
      "name": name,
    };
  }
}

class AssignedTo {
  String? userMobileNo;
  String? userName;
  String? userEmailid;

  AssignedTo({this.userMobileNo, this.userName, this.userEmailid});

  AssignedTo.fromJson(Map<String, dynamic> json) {
    userMobileNo = json['user_mobile_no'];
    userName = json['user_name'];
    userEmailid = json['user_emailid'];
  }

  Map<String, dynamic> toJson() {
    return {
      "user_mobile_no": userMobileNo,
      "user_name": userName,
      "user_emailid": userEmailid,
    };
  }
}

class QueryCategory {
  String? companyId;
  String? categoryid;
  String? categorytypeid;
  String? name;

  QueryCategory({
    this.companyId,
    this.categoryid,
    this.categorytypeid,
    this.name,
  });

  QueryCategory.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    categoryid = json['categoryid'];
    categorytypeid = json['categorytypeid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "categoryid": categoryid,
      "categorytypeid": categorytypeid,
      "name": name,
    };
  }
}

class SubQueryCategory {
  String? companyId;
  String? subcategoryid;
  String? categorytypeid;
  String? categoriesid;
  String? name;

  SubQueryCategory({
    this.companyId,
    this.subcategoryid,
    this.categorytypeid,
    this.categoriesid,
    this.name,
  });

  SubQueryCategory.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    subcategoryid = json['subcategoryid'];
    categorytypeid = json['categorytypeid'];
    categoriesid = json['categoriesid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "subcategoryid": subcategoryid,
      "categorytypeid": categorytypeid,
      "name": name,
    };
  }
}

class OwnershipCategory {
  String? companyId;
  String? categoryid;
  String? categorytypeid;
  String? name;

  OwnershipCategory({
    this.companyId,
    this.categoryid,
    this.categorytypeid,
    this.name,
  });

  OwnershipCategory.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    categoryid = json['categoryid'];
    categorytypeid = json['categorytypeid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "categoryid": categoryid,
      "categorytypeid": categorytypeid,
      "name": name,
    };
  }
}
