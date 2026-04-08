

class StockGroupEntity {
  String? companyId;
  String? stockgroupId;
  String? stockgroupName;
  String? maxId;
  String? tallymasterid;
  String? tallyalterid;
  // Manisha 13-12-2024 add column
  String? tallystatus;

  StockGroupEntity();

  StockGroupEntity.formMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    stockgroupId = map['stock_group_id'];
    stockgroupName = map['stock_group_name'];  
    maxId = map['max_id'];
    tallymasterid = map['tally_master_id'];
    tallyalterid = map['tally_alter_id'];
    tallystatus = map['tally_status']; // Manisha 13-12-2024 add column
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (stockgroupName != null) {
      map['stock_group_name'] = stockgroupName;
    }
    if (stockgroupId != null) {
      map['stock_group_id'] = stockgroupId;
    }
    return map;
  }
}