class UnbilledItemEntity {
  String? id;
  String? name;
  String? date;
  String? amount;
  String? closingValue;

  UnbilledItemEntity(
      {this.id, this.amount, this.closingValue, this.date, this.name});

  UnbilledItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    amount = json['amount'];
    closingValue = json['closingvalue'];
  }
}
