class CustomerRefferedbyEntity {
  String? companyId;
  String? groupId;
  String? companyName;

  CustomerRefferedbyEntity({this.companyId, this.groupId, this.companyName});

  factory CustomerRefferedbyEntity.fromJson(Map<String, dynamic> json) {
    return CustomerRefferedbyEntity(
      companyId: json['companyid']?.toString(),
      groupId: json['group_id']?.toString(),
      companyName: json['company_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyid": companyId,
      "group_id": groupId,
      "company_name": companyName,
    };
  }
}
