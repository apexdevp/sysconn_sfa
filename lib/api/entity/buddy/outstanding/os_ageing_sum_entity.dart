// class OutstandingRecPayAgeSumEntity {
//   String? iD;
//   String? nAME;
//   String? sALESPERSON;
//   String? cREDITDAYS;
//   String? nOTDUE;
//   String? dAYS0TO30;
//   String? dAYS31TO60;
//   String? dAYS61TO90;
//   String? dAYS91TO120;
//   String? dAYS121TO180;
//   String? mORETHAN180DAYS;
//   String? pENDINGAMOUNT;
//   String? nEXTFOLLOWUPDATE;
//   String? dUE;
//   String? followUpType;
//   String? ledgerGroup;
//   String? onAccount;

//   OutstandingRecPayAgeSumEntity(
//       {this.iD,
//       this.nAME,
//       this.sALESPERSON,
//       this.cREDITDAYS,
//       this.nOTDUE,
//       this.dAYS0TO30,
//       this.dAYS31TO60,
//       this.dAYS61TO90,
//       this.dAYS91TO120,
//       this.dAYS121TO180,
//       this.mORETHAN180DAYS,
//       this.pENDINGAMOUNT,
//       this.nEXTFOLLOWUPDATE,
//       this.dUE,
//       this.followUpType,
//       this.ledgerGroup,
//       this.onAccount});

//   OutstandingRecPayAgeSumEntity.fromJson(Map<String, dynamic> json) {
//     iD = json['id'];
//     nAME = json['name'];
//     nOTDUE = json['notdue'];
//     dAYS0TO30 = json['days_0_30'];
//     dAYS31TO60 = json['days_31_60'];
//     dAYS61TO90 = json['days_61_90'];
//     dAYS91TO120 = json['days_91_120'];
//     dAYS121TO180 = json['days_121_180'];
//     mORETHAN180DAYS = json['morethan_180_days'];
//     pENDINGAMOUNT = json['pending_amount'];
//     nEXTFOLLOWUPDATE = json['next_followup_date'];
//     dUE = json['due'];
//     followUpType = json['followup_type'];
//     ledgerGroup = json['ledger_group_name'];
//     onAccount = json['on_account'];
//     sALESPERSON = json['sales_person'];
//     cREDITDAYS = json['credit_days'];
//   }


    
// }
class OutstandingRecPayAgeSumEntity {
  String? iD;
  String? nAME;
  // String? sALESPERSON;
  // String? aREA;
  // String? bEAT;
  // String? cUSTOMERCLASSIFICATION;
  String? cREDITDAYS;
  double? nOTDUE;
  double? dAYS0TO30;
  double? dAYS31TO60;
  double? dAYS61TO90;
  double? dAYS91TO120;
  double? dAYS121TO180;
  double? mORETHAN180DAYS;
  double? pENDINGAMOUNT;
  String?
      nEXTFOLLOWUPDATE; // komal // 19-5-2022 // next followup added bcze entity changed in dash report
  double? dUE; // komal // 19-5-2022 // due node added
  String? followUpType; //snehal 30-07-2022 add followup type node

  OutstandingRecPayAgeSumEntity({
    this.iD,
    this.nAME,
    // this.sALESPERSON,
    // this.aREA,
    // this.bEAT,
    // this.cUSTOMERCLASSIFICATION,
    this.cREDITDAYS,
    this.nOTDUE,
    this.dAYS0TO30,
    this.dAYS31TO60,
    this.dAYS61TO90,
    this.dAYS91TO120,
    this.dAYS121TO180,
    this.mORETHAN180DAYS,
    this.pENDINGAMOUNT,
    this.nEXTFOLLOWUPDATE,
    this.dUE,
    this.followUpType, //snehal 30-07-2022 add this node
  });
  OutstandingRecPayAgeSumEntity.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    nAME = json['name'];
    nOTDUE = json['notdue'];
    dAYS0TO30 = json['days_0_30'];
    dAYS31TO60 = json['days_31_60'];
    dAYS61TO90 = json['days_61_90'];
    dAYS91TO120 = json['days_91_120'];
    dAYS121TO180 = json['days_121_180'];
    mORETHAN180DAYS = json['morethan_180_days'];
    pENDINGAMOUNT = json['pending_amount'];
    nEXTFOLLOWUPDATE = json['next_followup_date'];
    dUE = json['due'];
    followUpType = json['followup_type'];
    // ledgerGroup = json['ledger_group_name'];
    // onAccount = json['on_account'];
    // sALESPERSON = json['sales_person'];
    cREDITDAYS = json['credit_days'];
  }



  // OutstandingRecPayAgeSumEntity.fromJson(Map<String, dynamic> json) {
  //   iD = json['ID'];
  //   nAME = json['NAME'];
  //   // sALESPERSON = json['SALES_PESRON'];
  //   // aREA = json['AREA'];
  //   // bEAT = json['BEAT'];
  //   // cUSTOMERCLASSIFICATION = json['CUSTOMER_CLASSIFICATION'];
  //   cREDITDAYS = json['CREDIT_DAYS'];
  //   nOTDUE = json['NOTDUE'];
  //   dAYS0TO30 = json['DAYS_0_30'];
  //   dAYS31TO60 = json['DAYS_31_60'];
  //   dAYS61TO90 = json['DAYS_61_90'];
  //   dAYS91TO120 = json['DAYS_91_120'];
  //   dAYS121TO180 = json['DAYS_121_180'];
  //   mORETHAN180DAYS = json['MORETHAN_180_DAYS'];
  //   pENDINGAMOUNT = json['PENDING_AMOUNT'];
  //   nEXTFOLLOWUPDATE = json[
  //       'NEXT_FOLLOWUP_DATE']; // komal // 19-5-2022 // next followup added bcze entity changed in dash report
  //   dUE = json['DUE']; // komal // 19-5-2022 // due node added
  //   followUpType =
  //       json['FOLLOWUP_TYPE']; //SNEHAL 30-07-2022 ADD FOLLOWUP TYPE NODE
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['ID'] = iD;
  //   data['NAME'] = nAME;
  //   data['SALES_PESRON'] = sALESPERSON;
  //   data['AREA'] = aREA;
  //   data['BEAT'] = bEAT;
  //   data['CUSTOMER_CLASSIFICATION'] = cUSTOMERCLASSIFICATION;
  //   data['CREDIT_DAYS'] = cREDITDAYS;
  //   data['NOTDUE'] = nOTDUE;
  //   data['DAYS_0_30'] = dAYS0TO30;
  //   data['DAYS_31_60'] = dAYS31TO60;
  //   data['DAYS_61_90'] = dAYS61TO90;
  //   data['DAYS_91_120'] = dAYS91TO120;
  //   data['DAYS_121_180'] = dAYS121TO180;
  //   data['MORETHAN_180_DAYS'] = mORETHAN180DAYS;
  //   data['PENDING_AMOUNT'] = pENDINGAMOUNT;
  //   return data;
  // }
}
