import 'package:flutter_savdogar/share/utils.dart';

class WarehouseModel {
  late int id;
  late String name;
  late String regionName;
  late double prodaja;
  late double pay;
  late double dolg;
  late double seb2;
  late String lastInv;
  late double kirim;
  late double chiqim;

  WarehouseModel({
    required this.id,
    required this.name,
    required this.regionName,
    required this.prodaja,
    required this.pay,
    required this.dolg,
    required this.seb2,
    required this.lastInv,
    required this.kirim,
    required this.chiqim,
  });

  WarehouseModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "?";
    regionName = map['region_name'] ?? "?";
    prodaja = Utils.checkDouble(map['prodaja']);
    pay = (map['pay'] ?? 0).toDouble();
    dolg = (map['dolg'] ?? 0).toDouble();
    seb2 = Utils.checkDouble(map['seb2']);
    lastInv = map['last_inv'] ?? "";
    kirim = (map['kirim'] ?? 0).toDouble();
    chiqim = (map['chiqim'] ?? 0).toDouble();
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['region_name'] = regionName;
    map['prodaja'] = prodaja;
    map['pay'] = pay;
    map['dolg'] = dolg;
    map['seb2'] = seb2;
    map['last_inv'] = lastInv;
    map['kirim'] = kirim;
    map['chiqim'] = chiqim;
    return map;
  }
}
