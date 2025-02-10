import 'package:flutter_savdogar/share/utils.dart';

class DocCashInfo {
  late String name;
  late double ost;
  late double ostCur;
  late double ostPla;

  DocCashInfo({
    required this.name,
    required this.ost,
    required this.ostCur,
    required this.ostPla,
  });

  DocCashInfo.fromMapObject(Map<String, dynamic> map) {
    name = map['name'] ?? "";
    ost = Utils.checkDouble(map['ost']);
    ostCur = Utils.checkDouble(map['ost_cur']);
    ostPla = Utils.checkDouble(map['ost_pla']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['ost'] = ost;
    map['ost_cur'] = ostCur;
    map['ost_pla'] = ostPla;
    return map;
  }
}
