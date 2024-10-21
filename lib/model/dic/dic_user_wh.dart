class DicUserWh {
  late int id;
  late int userId;
  late int whId;
  late bool done;

  DicUserWh({
    required this.id,
    required this.userId,
    required this.whId,
    required this.done,
  });

  factory DicUserWh.fromJson(Map<String, dynamic> json) {
    return DicUserWh(
      id: json['id'],
      userId: json['user_id'],
      whId: json['wh_id'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "wh_id": whId,
        "done": done,
      };

  DicUserWh.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    userId = map['user_id'] ?? 0;
    whId = map['wh_id'] ?? "?";
    done = map['done'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['wh_id'] = whId;
    map['done'] = done;

    return map;
  }
}
