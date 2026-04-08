class BeatListEntity {
  String? iD;
  String? nAME;
  String? count;

  BeatListEntity();

  BeatListEntity.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    nAME = json['name'];
    count = json['total_count']; 
    }
}