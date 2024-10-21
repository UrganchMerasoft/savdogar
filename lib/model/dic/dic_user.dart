class DicUser {
  late int id;
  late String name;
  late String phone;
  late String psw;
  late String fcmToken;
  late bool isBoss;

  DicUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.psw,
    required this.fcmToken,
    required this.isBoss,
  });

  factory DicUser.fromJson(Map<String, dynamic> json) {
    return DicUser(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      psw: json['psw'],
      fcmToken: json['fcm_token'],
      isBoss: json['is_boss'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "psw": psw,
        "fcm_token": fcmToken,
        "is_boss": isBoss,
      };

  DicUser.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "?";
    phone = map['phone'] ?? "?";
    psw = map['psw'] ?? "?";
    fcmToken = map['fcm_token'] ?? "?";
    isBoss = map['is_boss'] ?? "?";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['psw'] = psw;
    map['fcm_token'] = fcmToken;
    map['is_boss'] = isBoss;

    return map;
  }
}
