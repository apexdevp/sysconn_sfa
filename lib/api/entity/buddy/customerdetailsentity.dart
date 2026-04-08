class CustomerDetailGetEntity {
  double? tOTALOSAMOUNT;
  double? tOTALOSDUEAMOUNT;
  double? pENDINGSOAMOUNT;
  String? lASTSODATE;
  double? lASTCOLLECTIONAMT;
  String? lASTCOLLECTIONDATE;
  double? lASTSALESAMT;
  String? lASTSALESDATE;
  String? cOUNTOSDUEAMOUNT; 
  String? pENDINGLEAD;
  double? pENDINGLEADAMT;
  String? fOLLOWUPCOUNT;
  String? nEXTFOLLOWUPDATE;
  String? pENDINGCOUNT;

  CustomerDetailGetEntity(
      {this.tOTALOSAMOUNT,
        this.tOTALOSDUEAMOUNT,
        this.pENDINGSOAMOUNT,
        this.lASTSODATE,
        this.lASTCOLLECTIONAMT,
        this.lASTCOLLECTIONDATE,
        this.lASTSALESAMT,
        this.lASTSALESDATE,
        this.cOUNTOSDUEAMOUNT,
        this.pENDINGLEAD,
        this.pENDINGLEADAMT,
        this.fOLLOWUPCOUNT,
        this.nEXTFOLLOWUPDATE,
        this.pENDINGCOUNT});

  CustomerDetailGetEntity.fromJson(Map<String, dynamic> json) {
    tOTALOSAMOUNT = json['total_os_amount'];
    tOTALOSDUEAMOUNT = json['total_os_due_amount'];
    pENDINGSOAMOUNT = json['pending_so_amount'];
    lASTSODATE = json['last_so_date'];
    lASTCOLLECTIONAMT = json['last_collection_amt'];
    lASTCOLLECTIONDATE = json['last_collection_date'];
    lASTSALESAMT = json['last_sales_amt'];
    lASTSALESDATE = json['last_sales_date'];
    cOUNTOSDUEAMOUNT = json['count_os_due_amount'];
    pENDINGLEAD = json['pending_lead'];
    pENDINGLEADAMT = json['pending_lead_amount'];
    fOLLOWUPCOUNT = json['followup_count'];
    nEXTFOLLOWUPDATE = json['next_followup_date'];
    //pENDINGCOUNT=json['PENDING_CNT'];  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TOTAL_OS_AMOUNT'] = tOTALOSAMOUNT;
    data['TOTAL_OS_DUE_AMOUNT'] = tOTALOSDUEAMOUNT;
    data['PENDING_SO_AMOUNT'] = pENDINGSOAMOUNT;
    data['LAST_SO_DATE'] = lASTSODATE;
    data['LAST_COLLECTION_AMT'] = lASTCOLLECTIONAMT;
    data['LAST_COLLECTION_DATE'] = lASTCOLLECTIONDATE;
    data['LAST_SALES_AMT'] = lASTSALESAMT;
    data['LAST_SALES_DATE'] = lASTSALESDATE;
    data['COUNT_OS_DUE_AMOUNT'] = cOUNTOSDUEAMOUNT;
    data['PENDING_LEAD'] = pENDINGLEAD;
    data['PENDING_LEAD_AMOUNT'] = pENDINGLEADAMT;
    return data;
  }
}
