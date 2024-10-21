class DicCat {
  late int id;
  late int ordNum;
  late String name;
  late String myUUID;

  DicCat({
    required this.id,
    required this.ordNum,
    required this.name,
    required this.myUUID,
  });

  factory DicCat.fromJson(Map<String, dynamic> json) {
    return DicCat(
      id: json['id'],
      ordNum: json['ord_num'],
      name: json['name'],
      myUUID: json['my_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ord_num": ordNum,
        "name": name,
        "my_uuid": myUUID,
      };

  DicCat.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    ordNum = map['ord_num'] ?? 0;
    name = map['name'] ?? "?";
    myUUID = map['my_uuid'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['ord_num'] = ordNum;
    map['name'] = name;
    map['my_uuid'] = myUUID;

    return map;
  }
}
