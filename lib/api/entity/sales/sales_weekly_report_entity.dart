class WeeklySalesEntity {
  String? name;
  String? weekOne;
  String? weekTwo;
  String? weekThree;
  String? weekFour;
  String? weekFive;
  String? weekSix;
  String? id;
  String? partyName;
  String? total;
  WeeklySalesEntity(
      {this.name,
      this.weekOne,
      this.weekTwo,
      this.weekThree,
      this.weekFour,
      this.weekFive,
      this.weekSix,
      this.total,
      this.partyName,
      this.id});

  WeeklySalesEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    //partyName = json['party_name'];
    id = json['group_id'];
    weekOne = json[
        'week1']; //!= '' ? num.parse(json['week1']).toStringAsFixed(1) : "";
    weekTwo = json['week2'];
    weekThree = json['week3'];
    weekFour = json['week4'];
    weekFive = json['week5'];
    weekSix = json['week6'];
    total = json['total'];
    partyName = json['party_name'];
  }
}
