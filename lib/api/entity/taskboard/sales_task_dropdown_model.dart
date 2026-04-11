import 'dart:convert';

SalesTaskDropdownModel salesTaskDropdownModelFromJson(String str) =>
    SalesTaskDropdownModel.fromJson(json.decode(str));

class SalesTaskDropdownModel {
  Data? data;

  SalesTaskDropdownModel({this.data});

  SalesTaskDropdownModel.fromJson(Map<String, dynamic> json) {
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
  List<BizCategory>? bizopportunity;
  List<TargetCategory>? targetcategory;

  Data({
    this.customerlist,
    this.eventlist,
    this.assignedto,
    this.bizopportunity,
    this.targetcategory,
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

    if (json['bizopportunity'] != null) {
      bizopportunity = [];
      json['bizopportunity'].forEach((v) {
        bizopportunity!.add(BizCategory.fromJson(v));
      });
    }

    if (json['targetcategory'] != null) {
      targetcategory = [];
      json['targetcategory'].forEach((v) {
        targetcategory!.add(TargetCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "customerlist": customerlist?.map((e) => e.toJson()).toList(),
      "eventlist": eventlist?.map((e) => e.toJson()).toList(),
      "assignedto": assignedto?.map((e) => e.toJson()).toList(),
      "bizopportunity": bizopportunity?.map((e) => e.toJson()).toList(),
      "targetcategory": targetcategory?.map((e) => e.toJson()).toList(),
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

class BizCategory {
  String? companyId;
  String? businessopportunityid;
  String? retailerCode;
  String? title;

  BizCategory({
    this.companyId,
    this.businessopportunityid,
    this.retailerCode,
    this.title,
  });

  BizCategory.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    businessopportunityid = json['businessopportunityid'];
    retailerCode = json['retailer_Code'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    return {
      "company_id": companyId,
      "businessopportunityid": businessopportunityid,
      "retailer_Code": retailerCode,
      "title": title,
    };
  }
}

class TargetCategory {
  String? companyId;
  String? categoryid;
  String? categorytypeid;
  String? name;

  TargetCategory({
    this.companyId,
    this.categoryid,
    this.categorytypeid,
    this.name,
  });

  TargetCategory.fromJson(Map<String, dynamic> json) {
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
