import 'package:flutter_savdogar/share/utils.dart';

class OstCatModel {
  late int catId;
  late String catName;
  late int ostQty;
  late double ostSum;

  OstCatModel({
    required this.catId,
    required this.catName,
    required this.ostQty,
    required this.ostSum,
  });

  OstCatModel.fromMapObject(Map<String, dynamic> map) {
    catId = map['cat_id'] ?? 0;
    catName = map['cat_name'] ?? "";
    ostQty = map['ost_qty'] ?? 0;
    ostSum = Utils.checkDouble(map['ost_summ']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['cat_id'] = catId;
    map['cat_name'] = catName;
    map['ost_qty'] = ostQty;
    map['ost_summ'] = ostSum;
    return map;
  }
}

class OstProdModel {
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
  late int catName;
  late int ostQty;
  late double ostSumm;
  late double lastInPrice;

  OstProdModel({
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
    required this.catName,
    required this.ostQty,
    required this.ostSumm,
    required this.lastInPrice,
  });

  OstProdModel.fromMapObject(Map<String, dynamic> map) {
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
    catName = map['cat_name'] ?? "";
    ostQty = map['ost_qty'] ?? 0;
    ostSumm = map['ost_summ'] ?? 0;
    lastInPrice = map['last_in_price'] ?? 0;
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
    map['cat_name'] = catName;
    map['ost_qty'] = ostQty;
    map['ost_summ'] = ostSumm;
    return map;
  }
}
