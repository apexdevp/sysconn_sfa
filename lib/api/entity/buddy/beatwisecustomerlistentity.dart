class BeatCustListGetEntity {
  String? pARTYID;
  String? pARTYNAME;
  String? pRICELEVEL;
  String? cONTACTNUMBER;
  String? cUSTCLASSIFICATION;
  double? sALESLASTMONTH;
  double? sALESCURRENTMONTH;
  double? gROWTH;
  String? eMAILID;
  String? lATITUDE;
  String? lONGITUDE;
  String? locationCITY;

  BeatCustListGetEntity();

  BeatCustListGetEntity.fromJson(Map<String, dynamic> json) {
    pARTYID = json['party_id'];
    pARTYNAME = json['party_name'];
    pRICELEVEL = json['pricelevel'];
    cONTACTNUMBER = json['contact_number'];
    cUSTCLASSIFICATION = json['customer_classification'];
    // sALESLASTMONTH = json['sales_last_month'];
    // sALESCURRENTMONTH = json['sales_current_month'];
    // gROWTH = json['growth'];
     sALESLASTMONTH = (json['sales_last_month'] ?? 0).toDouble();
    sALESCURRENTMONTH = (json['sales_current_month'] ?? 0).toDouble();
    gROWTH = (json['growth'] ?? 0).toDouble();
    eMAILID = json['email_id'];
    lATITUDE = json['latitude'];
    lONGITUDE = json['longitude'];
    locationCITY = json['location_city'];
  }
}