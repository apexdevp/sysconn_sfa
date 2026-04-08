//Rupali 27-11-2024
class GroupMasterEntity {
  String? companyId;
  String? groupId;
  String? groupName;
  String? parentId;
  String? natureofGroup;
  String? primaryGroup;
  String? maxId;
  String? parentName;//snehal 30-11-2024 add
  String? grpCreateType;//snehal 6-12-2024 add
  String? tallystatus; // Manisha 13-12-2024 add
  GroupMasterEntity();

  GroupMasterEntity.formMap(Map<String, dynamic> map) {
    companyId = map['company_id'];
    groupId = map['group_id'];
    groupName = map['group_name'];  
    parentId = map['parent_id'];
    natureofGroup = map['nature_of_group'];
    primaryGroup = map['primarygroup'];
    maxId = map['max_id'];
   parentName = map['parent_name'];
  grpCreateType = map['grp_create_type'];
  // Manisha 13-12-2024
    tallystatus = map['tally_status'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (groupName != null) {
      map['group_name'] = groupName;
    }
    if (natureofGroup != null) {
      map['nature_of_group'] = natureofGroup;
    }
    if (primaryGroup != null) {
      map['primary_group'] = primaryGroup;
    }
    if (parentId != null) {
      map['parent_id'] = parentId;
    }
    if ( groupId!= null) {
      map['group_id'] = groupId;
    }
     if(parentName != null) {
      map['parent_name'] = parentName;
     }
    return map;
  }
  
}