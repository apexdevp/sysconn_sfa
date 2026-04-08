class RetailerComplaintEntity {
  String? cOMPANYID;
  String? mOBILENO;
  String? dATE;
  String? pARTYID;
  String? rEASONS;
  String? rEMARK;
  String? visitId;
  String? emailid;

  RetailerComplaintEntity(
      {this.cOMPANYID,
      this.mOBILENO,
      this.dATE,
      this.pARTYID,
      this.rEASONS,
      this.rEMARK,
      this.visitId,
      this.emailid});

  RetailerComplaintEntity.fromJson(Map<String, dynamic> json) {
    cOMPANYID = json['company_id'];
    mOBILENO = json['mobile_no'];
    dATE = json['date'];
    pARTYID = json['party_id'];
    rEASONS = json['reasons'];
    rEMARK = json['remark'];
    visitId = json['visit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = cOMPANYID;
    data['mobile_no'] = mOBILENO;
    data['date'] = dATE;
    data['party_id'] = pARTYID;
    data['reasons'] = rEASONS;
    data['remark'] = rEMARK;
    data['visit_id'] = visitId;
    data['email_id'] = emailid;
    return data;
  }
}
