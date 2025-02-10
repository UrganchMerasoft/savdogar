import '../../share/utils.dart';

class ZatratModel {
  late int id;
  late int catId;
  late int ordNum;
  late String code;
  late String name;
  late int isCur;
  late int coeff;
  late String unit1;
  late String unit2;
  late double price1;
  late double price2;
  late int price3;
  late int price4;
  late int price5;
  late int price6;
  late int price7;
  late double price8;
  late int mustImei;
  late String myUuid;
  late String prodFormat;
  late int isActive;
  late int isNew;
  late String photoFileName;
  late String thumbFileName;
  late String insertedAt;
  late int minOstQty;
  late int isKg;

  ZatratModel({
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
    required this.isNew,
    required this.photoFileName,
    required this.thumbFileName,
    required this.insertedAt,
    required this.minOstQty,
    required this.isKg,
  });

  factory ZatratModel.fromMap(Map<String, dynamic> json) => ZatratModel(
    id: json["id"] ?? 0,
    catId: json["cat_id"] ?? 0,
    ordNum: json["ord_num"] ?? 0,
    code: json["code"] ?? "",
    name: json["name"] ?? "",
    isCur: json["is_cur"] ?? 0,
    coeff: json["coeff"] ?? 0,
    unit1: json["unit1"] ?? "",
    unit2: json["unit2"] ?? "",
    price1: Utils.checkDouble(json["price1"]),
    price2: Utils.checkDouble(json["price2"]),
    price3: json["price3"],
    price4: json["price4"] ?? 0,
    price5: json["price5"] ?? 0,
    price6: json["price6"] ?? 0,
    price7: json["price7"] ?? 0,
    price8: json["price8"]?.toDouble() ?? 0,
    mustImei: json["must_imei"] ?? 0,
    myUuid: json["my_uuid"] ?? "",
    prodFormat: json["prod_format"] ?? "",
    isActive: json["is_active"] ?? 0,
    isNew: json["is_new"] ?? 0,
    photoFileName: json["photo_file_name"] ?? "",
    thumbFileName: json["thumb_file_name"] ?? "",
    insertedAt: json["inserted_at"] ?? "",
    minOstQty: json["min_ost_qty"] ?? 0,
    isKg: json["is_kg"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "cat_id": catId,
    "ord_num": ordNum,
    "code": code,
    "name": name,
    "is_cur": isCur,
    "coeff": coeff,
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
    "must_imei": mustImei,
    "my_uuid": myUuid,
    "prod_format": prodFormat,
    "is_active": isActive,
    "is_new": isNew,
    "photo_file_name": photoFileName,
    "thumb_file_name": thumbFileName,
    "inserted_at": insertedAt,
    "min_ost_qty": minOstQty,
    "is_kg": isKg,
  };
}
