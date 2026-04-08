class GodownMasterEntity {
  String? companyId;
  String? godownId;
  String? godownName;
  String? masterid;
  String? alterid;
  String? primaryGroup;
  String? maxId;
 GodownMasterEntity();
  GodownMasterEntity.formMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    godownId = map['stock_godown_id'];
    godownName = map['stock_godown_name'];  
    masterid = map['tally_master_id'];
    alterid = map['tally_alter_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (godownName != null) {
      map['stock_godown_name'] = godownName;
    }
    if (godownId != null) {
      map['stock_godown_id'] = godownId;
    }
    return map;
  }
}