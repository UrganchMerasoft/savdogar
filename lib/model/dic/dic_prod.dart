import 'package:flutter_savdogar/share/utils.dart';

class DicProd {
  late int id;
  late int catId;
  late int ordNum;
  late String code;
  late String name;
  late int isCur;
  late double coeff;
  late String unit1;
  late String unit2;
  late double price1;
  late double price2;
  late double price3;
  late double price4;
  late double price5;
  late double price6;
  late double price7;
  late double price8;
  late int mustImei;
  late String myUUID;
  late String prodFormat;
  late int isActive;
  late int isNew;
  late String insertedAt;
  late double minOstQty;
  late int isKg;

  DicProd({
    required this.id,
    required this.catId,
    required this.ordNum,
    required this.code,
    required this.name,
    required this.unit1,
    required this.unit2,
    required this.price1,
    required this.price2,
    required this.price3,
    required this.price4,
    required this.price5,
    required this.price6,
    required this.price7,
    required this.price8,
    required this.isCur,
    required this.coeff,
    required this.mustImei,
    required this.myUUID,
    required this.prodFormat,
    required this.isActive,
    required this.isNew,
    required this.insertedAt,
    required this.minOstQty,
    required this.isKg,
  });

  factory DicProd.fromJson(Map<String, dynamic> json) {
    return DicProd(
      id: json['id'],
      catId: json['cat_id'],
      ordNum: json['ord_num'],
      code: json['code'],
      name: json['name'],
      unit1: json['unit1'],
      unit2: json['unit2'],
      price1: Utils.checkDouble(json['price1']),
      price2: Utils.checkDouble(json['price2']),
      price3: Utils.checkDouble(json['price3']),
      price4: Utils.checkDouble(json['price4']),
      price5: Utils.checkDouble(json['price5']),
      price6: Utils.checkDouble(json['price6']),
      price7: Utils.checkDouble(json['price7']),
      price8: Utils.checkDouble(json['price8']),
      isCur: json['is_cur'],
      coeff: Utils.checkDouble(json['coeff']),
      mustImei: json['must_imei'],
      myUUID: json['my_uuid'],
      prodFormat: json['prod_format'],
      isActive: json['is_active'],
      isNew: json['is_new'],
      insertedAt: json['inserted_at'],
      minOstQty: Utils.checkDouble(json['min_ost_qty']),
      isKg: json['is_kg'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "ord_num": ordNum,
        "code": code,
        "name": name,
        "unit1": unit1,
        "unit2": unit2,
        "price1": price1,
        "price2": price2,
        "price3": price3,
        "price4": price4,
        "price5": price5,
        "price6": price6,
        "price7": price7,
        "price8": price8,
        "is_cur": isCur,
        "coeff": coeff,
        "must_imei": mustImei,
        "my_uuid": myUUID,
        "prod_format": prodFormat,
        "is_active": isActive,
        "is_new": isNew,
        "inserted_at": insertedAt,
        "min_ost_qty": minOstQty,
        "is_kg": isKg,
      };

  DicProd.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    catId = map['cat_id'] ?? 0;
    ordNum = map['ord_num'] ?? 0;
    code = map['code'] ?? "?";
    name = map['name'] ?? "?";
    unit1 = map['unit1'] ?? "?";
    unit2 = map['unit2'] ?? "?";
    price1 = Utils.checkDouble(map['price1']);
    price2 = Utils.checkDouble(map['price2']);
    price3 = Utils.checkDouble(map['price3']);
    price4 = Utils.checkDouble(map['price4']);
    price5 = Utils.checkDouble(map['price5']);
    price6 = Utils.checkDouble(map['price6']);
    price7 = Utils.checkDouble(map['price7']);
    price8 = Utils.checkDouble(map['price8']);
    isCur = map['is_cur'] ?? 0;
    coeff = Utils.checkDouble(map['coeff']);
    mustImei = map['must_imei'] ?? 0;
    myUUID = map['my_uuid'] ?? "?";
    prodFormat = map['prod_format'] ?? "?";
    isActive = map['is_active'] ?? 0;
    isNew = map['is_new'] ?? 0;
    insertedAt = map['inserted_at'] ?? "?";
    minOstQty = Utils.checkDouble(map['min_ost_qty']);
    isKg = map['is_kg'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['cat_id'] = catId;
    map['ord_num'] = ordNum;
    map['code'] = code;
    map['name'] = name;
    map['unit1'] = unit1;
    map['unit2'] = unit2;
    map['price1'] = price1;
    map['price2'] = price2;
    map['price3'] = price3;
    map['price4'] = price4;
    map['price5'] = price5;
    map['price6'] = price6;
    map['price7'] = price7;
    map['price8'] = price8;
    map['is_cur'] = isCur;
    map['coeff'] = coeff;
    map['must_imei'] = mustImei;
    map['my_uuid'] = myUUID;
    map['prod_format'] = prodFormat;
    map['is_active'] = isActive;
    map['is_new'] = isNew;
    map['inserted_at'] = insertedAt;
    map['min_ost_qty'] = minOstQty;
    map['is_kg'] = isKg;

    return map;
  }
}
