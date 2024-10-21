class DicContraType {
  late int id;
  late String name;

  DicContraType({
    required this.id,
    required this.name,
  });

  factory DicContraType.fromJson(Map<String, dynamic> json) {
    return DicContraType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  DicContraType.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "?";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;

    return map;
  }
}
