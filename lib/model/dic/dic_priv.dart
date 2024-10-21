class DicPriv {
  late int id;
  late String name;
  late String groupName;

  DicPriv({
    required this.id,
    required this.name,
    required this.groupName,
  });

  factory DicPriv.fromJson(Map<String, dynamic> json) {
    return DicPriv(
      id: json['id'],
      name: json['name'],
      groupName: json['group_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "group_name": groupName,
      };

  DicPriv.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "?";
    groupName = map['group_name'] ?? "?";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['group_name'] = groupName;

    return map;
  }
}
