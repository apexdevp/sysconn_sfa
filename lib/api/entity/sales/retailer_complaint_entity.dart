class RetailerComplaintRequestEntity {
  List<RetailerComplaintData>? retailerComplaintData;

  RetailerComplaintRequestEntity({this.retailerComplaintData});

  RetailerComplaintRequestEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      retailerComplaintData = <RetailerComplaintData>[];
      json['data'].forEach((v) {
        retailerComplaintData?.add(RetailerComplaintData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (retailerComplaintData != null) {
      data['data'] = retailerComplaintData?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RetailerComplaintData {
  String? pARTNERCODE;
  String? cOMPANYID;
  String? mOBILENO;
  String? dATE;
  String? pARTYID;
  String? rEASONS;
  String? rEMARK;
  String? visitId;
  RetailerComplaintData(
      {this.pARTNERCODE,
        this.cOMPANYID,
        this.mOBILENO,
        this.dATE,
        this.pARTYID,
        this.rEASONS,
        this.rEMARK,
        this.visitId});

  RetailerComplaintData.fromJson(Map<String, dynamic> json) {
    pARTNERCODE = json['PARTNER_CODE'];
    cOMPANYID = json['COMPANY_ID'];
    mOBILENO = json['MOBILE_NO'];
    dATE = json['DATE'];
    pARTYID = json['PARTY_ID'];
    rEASONS = json['REASONS'];
    rEMARK = json['REMARK'];
    visitId = json['VISIT_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PARTNER_CODE'] = pARTNERCODE;
    data['company_id'] = cOMPANYID;
    data['MOBILE_NO'] = mOBILENO;
    data['date'] = dATE;
    data['party_id'] = pARTYID;
    data['reasons'] = rEASONS;
    data['remark'] = rEMARK;
    data['visit_id'] = visitId;
    return data;
  }
}