class SalesDashboardEntity{
  String? id;
  String? name;
  String? amount;
  String? qty;
  String? partname;
  String? invoiceno;
  String? date;
  String? vchparent;
  String? totalqty;
  String? amt;
  String? quantity;//pooja // 22-11-2024
  String? masterid; //pooja // 21-11-2024
  SalesDashboardEntity({this.id,this.name,this.amount,this.qty,this.partname,this.invoiceno,this.amt,this.date,
  this.totalqty,this.vchparent,this.masterid,this.quantity});
  
  SalesDashboardEntity.fromJson(Map<String,dynamic>json){
    id = json['id']?.toString();
    name = json['name']?.toString();
    amount = json['amount'].toString();
    qty = json['qty'].toString();
    partname = json['party_name'].toString();
    invoiceno = json['invoice_no'].toString();
    date = json['date'].toString();
    vchparent = json['vchtype_parent'].toString();
    totalqty = json['total_qty'].toString();
    amt = json['amount'].toString();
    masterid = json['masterid'].toString();
    quantity = json['quantity'].toString();
  }
}