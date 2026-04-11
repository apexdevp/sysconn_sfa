class TaskBoardEntity {
  String? supportTaskId;
  String? salesTaskId;
  String? companyId;
  String? retailerCode;
  String? retailerName;
  String? assignedUserTo;
  String? assignedUserName;
  String? title;
  String? description;
  String? categoryId;
  String? categoryName;
  String? status;
  String? todoDate;
  String? dueDate;
  String? checkInAt;
  String? checkOutAt;
  String? isDeviation;
  String? isPined;
  String? privateId;
  String? ownershipCategoryId;
  String? ownershipCategoryName;
  String? supportCategoryId;
  String? supportCategoryName;
  String? supportSubCategoryId;
  String? supportSubCategoryName;
  String? rating;
  String? bizModel;
  String? bizModelId;
  String? bizModelName;
  String? divisionCategory;
  String? targetCategory;
  String? targetCategoryName;

  String? emailId;
  String? activity;
  String? activityDescription;

  String? createdAt;
  String? updatedAt;

  TaskBoardEntity();

  TaskBoardEntity.fromMap(Map<String, dynamic> json) {
    print("API ROW DATA: $json");

    supportTaskId = json['supporttaskid'];
    salesTaskId = json['salestaskid'];
    companyId = json['company_id'];
    retailerCode = json['retailer_code'];
    retailerName = json['retailer_name'];
    assignedUserTo = json['assigneduserto'];
    assignedUserName = json['assignedusername'];
    title = json['title'];
    description = json['description'];
    categoryId = json['categoryid'];
    categoryName = json['categoryname'];
    status = json['status'];
    rating = json['rating'];
    todoDate = json['tododate'];
    dueDate = json['duedate'];
    checkInAt = json['checkinat'];
    checkOutAt = json['checkoutat'];
    isDeviation = json['isdeviated'];
    isPined = json['ispined'];
    privateId = json['privateid'];
    ownershipCategoryId = json['ownershipcategoryid'];
    ownershipCategoryName = json['ownershipcategoryname'];
    supportCategoryId = json['supportcategoryid'];
    supportCategoryName = json['supportcategoryname'];
    supportSubCategoryId = json['supportsubcategoryid'];
    supportSubCategoryName = json['supportsubcategoryname'];
    createdAt = json['createdat'];
    updatedAt = json['updatedat'];
    bizModel = json['model'];
    bizModelId = json['modelid'];
    bizModelName = json['modelname'];
    divisionCategory = json['divisioncategory'];
    targetCategory = json['targetcategoryid'];
    targetCategoryName = json['targetcategoryname'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (supportTaskId != null) {
      map['SUPPORTTASKID'] = supportTaskId;
    }

    if (salesTaskId != null) {
      map['SALESTASKID'] = salesTaskId;
    }

    if (companyId != null) {
      map['COMPANY_ID'] = companyId;
    }

    if (retailerCode != null) {
      map['RETAILER_CODE'] = retailerCode;
    }

    if (assignedUserTo != null) {
      map['ASSIGNEDUSERTO'] = assignedUserTo;
    }

    if (title != null) {
      map['TITLE'] = title;
    }

    if (description != null) {
      map['DESCRIPTION'] = description;
    }

    if (categoryId != null) {
      map['CATEGORYID'] = categoryId;
    }

    if (status != null) {
      map['STATUS'] = status;
    }

    if (todoDate != null) {
      map['TODODATE'] = todoDate;
    }

    if (dueDate != null) {
      map['DUEDATE'] = dueDate;
    }

    if (ownershipCategoryId != null) {
      map['OWNERSHIPCATEGORYID'] = ownershipCategoryId;
    }

    if (supportCategoryId != null) {
      map['SUPPORTCATEGORYID'] = supportCategoryId;
    }

    if (supportSubCategoryId != null) {
      map['SUPPORTSUBCATEGORYID'] = supportSubCategoryId;
    }
    if (bizModel != null) {
      map['MODEL'] = bizModel;
    }
    if (bizModelId != null) {
      map['MODELID'] = bizModelId;
    }
    if (divisionCategory != null) {
      map['DIVISIONCATEGORY'] = divisionCategory;
    }
    if (targetCategory != null) {
      map['TARGETCATEGORYID'] = targetCategory;
    }

    if (emailId != null) {
      map['EMAIL_ID'] = emailId;
    }
    if (activity != null) {
      map['ACTIVITY'] = activity;
    }
    if (activityDescription != null) {
      map['ACTIVITYDESCRIPTION'] = activityDescription;
    }

    return map;
  }
}
