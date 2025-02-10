import 'package:flutter_savdogar/share/utils.dart';

class Main {
  late String typeName;
  late double summ;

  Main({required this.typeName, required this.summ});

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(typeName: json['type_name'], summ: json['summ']);
  }

  Map<String, dynamic> toJson() => {"type_name": typeName, "summ": summ};

  Main.fromMapObject(Map<String, dynamic> map) {
    typeName = map['type_name'] ?? 0;
    summ = Utils.checkDouble(map['summ']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['type_name'] = typeName;
    map['summ'] = summ;
    return map;
  }
}
