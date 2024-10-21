class DicWh {
  late int id;
  late String name;
  late String myUUID;

  DicWh({
    required this.id,
    required this.name,
    required this.myUUID,
  });

  factory DicWh.fromJson(Map<String, dynamic> json) {
    return DicWh(
      id: json['id'],
      name: json['name'],
      myUUID: json['my_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "my_uuid": myUUID,
  };

  DicWh.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "?";
    myUUID = map['my_uuid'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['my_uuid'] = myUUID;

    return map;
  }
}
