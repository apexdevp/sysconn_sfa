//Rupai 21-10-2024
class PendingClosingStockEntity {
  String? iD;
  String? nAME;
  String? iTEMID;
  String? iTEMNAME;
  String? sTOCKGODOWNNAME;
  String? bATCH;
  String? cLOSINGQTY;
  String? cLOSINGVALUE;
  String? uNIT;    
  String? oRDERQUANTITY; 

  PendingClosingStockEntity(
      {this.iTEMID,
      this.iTEMNAME,
      this.iD,
      this.nAME,
      this.sTOCKGODOWNNAME,
      this.bATCH,
      this.cLOSINGQTY,
      this.cLOSINGVALUE,
      this.uNIT,
      this.oRDERQUANTITY});


  PendingClosingStockEntity.fromJson(Map<String, dynamic> json) {
    iTEMID = json['item_id'];
    iTEMNAME = json['item_name'];
    iD = json['id'];
    nAME = json['name'];
    sTOCKGODOWNNAME = json['stock_godown_name'];
    bATCH = json['batch'];
    cLOSINGQTY = json['closingqty'] == ''?'0':num.parse(json['closingqty']).toStringAsFixed(0);
    cLOSINGVALUE = json['closingvalue'] == ''?'0':num.parse(json['closingvalue']).toStringAsFixed(0);
    uNIT = json['unit_name'];
    oRDERQUANTITY = json['orderquantity'];    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = iTEMID;
    data['item_name'] = iTEMNAME;
    data['id'] = iD;
    data['name'] = nAME;
    data['stock_godown_name'] = sTOCKGODOWNNAME;
    data['batch'] = bATCH;
    data['closingqty'] = cLOSINGQTY;
    data['closingvalue'] = cLOSINGVALUE;
    data['unit_name'] = uNIT;
    data['orderquantity'] = oRDERQUANTITY;   
    return data;
  }
}