class DicZatrat {
  late int id;
  late String name;
  late String myUUID;

  DicZatrat({
    required this.id,
    required this.name,
    required this.myUUID,
  });

  factory DicZatrat.fromJson(Map<String, dynamic> json) {
    return DicZatrat(
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

  DicZatrat.fromMapObject(Map<String, dynamic> map) {
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
