class CategoryTypeCategoryEntity {
  String? companyId;
  String? categoryid;
  String? tenantid;
  String? categorytypeid;
  String? type;
  String? name;
  String? workflowtype;
  String? createdat;
  String? updatedat;
   String? subcategorycount;
   String? subcategoryid;
    String? categoriesid;
   int? status;  // Sakshi 27/03/2026

  CategoryTypeCategoryEntity();

  CategoryTypeCategoryEntity.fromMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    categoryid = map['categoryid'];
    tenantid = map['tenantid'];
    categorytypeid = map['categorytypeid'];
    type = map['type'];
    name = map['name'];
    workflowtype = map['workflowtype'];
    createdat = map['createdat'];
    updatedat = map['updatedat'];
     subcategorycount = map['subcategory_count'];
     subcategoryid = map['subcategoryid'];
      categoriesid = map['categoriesid']?.toString();
   status = map['status'];  // // Sakshi 27/03/2026
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (categoryid != null) {
      map['categoryid'] = categoryid;
    }
    if (tenantid != null) {
      map['tenantid'] = tenantid;
    }
    if (categorytypeid != null) {
      map['categorytypeid'] = categorytypeid;
    }
    if (type != null) {
      map['type'] = type;
    }
    if (name != null) {
      map['name'] = name;
    }
    if (workflowtype != null) {
      map['workflowtype'] = workflowtype;
    }
    if (createdat != null) {
      map['createdat'] = createdat;
    }
    if (updatedat != null) {
      map['updatedat'] = updatedat;
    }
     if (subcategorycount != null) {
      map['subcategory_count'] = subcategorycount;
    }
      if (subcategoryid != null) {
      map['subcategoryid'] = subcategoryid;
    }
     if (categoriesid != null) {
      map['categoriesid'] = categoriesid;
    }
     if (status != null) {              // Sakshi 27/03/2026
      map['status'] = status;
    }

    return map;
  }
}