import 'package:flutter_savdogar/share/utils.dart';

class ProdMoveModel {
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
  late String myUuid;
  late String prodFormat;
  late int isActive;
  late String photoFileName;
  late String thumbFileName;
  late String insertedAt;
  late double minOstQty;
  late int isKg;
  late String catName;
  late double ostQty1;
  late double ostQty2;
  late double ostSeb1;
  late double ostSeb2;
  late double ostSumm1;
  late double ostSumm2;

  ProdMoveModel({
    required this.id,
    required this.catId,
    required this.ordNum,
    required this.code,
    required this.name,
    required this.isCur,
    required this.coeff,
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
    required this.mustImei,
    required this.myUuid,
    required this.prodFormat,
    required this.isActive,
    required this.photoFileName,
    required this.thumbFileName,
    required this.insertedAt,
    required this.minOstQty,
    required this.isKg,
    required this.catName,
    required this.ostQty1,
    required this.ostQty2,
    required this.ostSeb1,
    required this.ostSeb2,
    required this.ostSumm1,
    required this.ostSumm2,
  });

  ProdMoveModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    catId = map['cat_id'] ?? 0;
    ordNum = map['ord_num'] ?? 0;
    code = map['code'] ?? "";
    name = map['name'] ?? "";
    isCur = map['is_cur'] ?? 0;
    coeff = map['coeff']?.toDouble() ?? 0.0;
    unit1 = map['unit1'] ?? "";
    unit2 = map['unit2'] ?? "";
    price1 = map['price1']?.toDouble() ?? 0.0;
    price2 = map['price2']?.toDouble() ?? 0.0;
    price3 = map['price3']?.toDouble() ?? 0.0;
    price4 = map['price4']?.toDouble() ?? 0.0;
    price5 = map['price5']?.toDouble() ?? 0.0;
    price6 = map['price6']?.toDouble() ?? 0.0;
    price7 = map['price7']?.toDouble() ?? 0.0;
    price8 = map['price8']?.toDouble() ?? 0.0;
    mustImei = map['must_imei'] ?? 0;
    myUuid = map['my_uuid'] ?? "";
    prodFormat = map['prod_format'] ?? "";
    isActive = map['is_active'] ?? 0;
    photoFileName = map['photo_file_name'] ?? "";
    thumbFileName = map['thumb_file_name'] ?? "";
    insertedAt = map['inserted_at'] ?? "";
    minOstQty = Utils.checkDouble(map['min_ost_qty']);
    isKg = map['is_kg'] ?? 0;
    catName = map['category_name'] ?? "";
    ostQty1 = map['ost_qty1']?.toDouble() ?? 0.0;
    ostQty2 = map['ost_qty2']?.toDouble() ?? 0.0;
    ostSeb1 = map['ost_seb1']?.toDouble() ?? 0.0;
    ostSeb2 = map['ost_seb2']?.toDouble() ?? 0.0;
    ostSumm1 = map['ost_summ1']?.toDouble() ?? 0.0;
    ostSumm2 = map['ost_summ2']?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['cat_id'] = catId;
    map['ord_num'] = ordNum;
    map['code'] = code;
    map['name'] = name;
    map['is_cur'] = isCur;
    map['coeff'] = coeff;
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
    map['must_imei'] = mustImei;
    map['my_uuid'] = myUuid;
    map['prod_format'] = prodFormat;
    map['is_active'] = isActive;
    map['photo_file_name'] = photoFileName;
    map['thumb_file_name'] = thumbFileName;
    map['inserted_at'] = insertedAt;
    map['min_ost_qty'] = minOstQty;
    map['is_kg'] = isKg;
    map['category_name'] = catName;
    map['ost_qty1'] = ostQty1;
    map['ost_qty2'] = ostQty2;
    map['ost_seb1'] = ostSeb1;
    map['ost_seb2'] = ostSeb2;
    map['ost_summ1'] = ostSumm1;
    map['ost_summ2'] = ostSumm2;
    return map;
  }
}
