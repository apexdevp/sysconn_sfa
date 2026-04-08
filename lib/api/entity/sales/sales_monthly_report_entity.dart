class MonthlySalesEntity {
  String? name;
  String? april;
  String? may;
  String? june;
  String? july;
  String? august;
  String? september;
  String? october;
  String? november;
  String? december;
  String? january;
  String? february;
  String? march;
  String? total;
  String? partyName;
  String? id;

  MonthlySalesEntity(
      {this.name,
      this.april,
      this.may,
      this.june,
      this.july,
      this.august,
      this.september,
      this.october,
      this.november,
      this.december,
      this.january,
      this.february,
      this.march,
      this.total,
      this.partyName,
      this.id});

  MonthlySalesEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    partyName = json['party_name'];
    id = json['group_id'];
    april = json['april'];
    may = json['may'];
    june = json['june'];
    july = json['july'];
    august = json['august'];
    september = json['september'];
    october = json['october'];
    november = json['november'];
    december = json['december'];
    january = json['january'];
    february = json['february'];
    march = json['march'];
    total = json['total'];
  }
}
