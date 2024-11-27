import 'package:flutter_savdogar/share/utils.dart';

class DocCashInfo {
  late String name;
  late double ost;

  DocCashInfo({required this.name, required this.ost});

  DocCashInfo.fromMapObject(Map<String, dynamic> map) {
    name = map['name'] ?? "";
    ost = Utils.checkDouble(map['ost']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['ost'] = ost;
    return map;
  }
}
