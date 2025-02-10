import 'package:flutter_savdogar/share/utils.dart';

class DebModel {
  late int id;
  late int typeId;
  late int regionId;
  late String name;
  late String address;
  late String phone;
  late int isActive;
  late int priceIndex;
  late int useSavdo;
  late String myUuid;
  late String notes;
  late int cashbackProcent;
  late String contractNum;
  late String inn;
  late String telegramChatId;
  late int userId;
  late String birthDate;
  late String routeName;
  late String invDate;
  late String payDate;
  late double cashback;
  late double summRass;
  late String rassDate;
  late String maxRassDate;
  late String minRassDate;
  late double summ;
  late double summCur;
  late double summDolg;
  late double summPred;
  late int dayCount;

  DebModel({
    required this.id,
    required this.typeId,
    required this.regionId,
    required this.name,
    required this.address,
    required this.phone,
    required this.isActive,
    required this.priceIndex,
    required this.useSavdo,
    required this.myUuid,
    required this.notes,
    required this.cashbackProcent,
    required this.contractNum,
    required this.inn,
    required this.telegramChatId,
    required this.userId,
    required this.birthDate,
    required this.routeName,
    required this.invDate,
    required this.payDate,
    required this.cashback,
    required this.summRass,
    required this.rassDate,
    required this.maxRassDate,
    required this.minRassDate,
    required this.summ,
    required this.summCur,
    required this.summDolg,
    required this.summPred,
    required this.dayCount,
  });

  factory DebModel.fromMap(Map<String, dynamic> json) => DebModel(
        id: json["id"] ?? 0,
        typeId: json["type_id"] ?? 0,
        regionId: json["region_id"] ?? 0,
        name: json["name"] ?? "",
        address: json["address"] ?? "",
        phone: json["phone"] ?? "",
        isActive: json["is_active"] ?? 0,
        priceIndex: json["price_index"] ?? 0,
        useSavdo: json["use_savdo"] ?? 0,
        myUuid: json["my_uuid"] ?? "",
        notes: json["notes"] ?? '',
        cashbackProcent: json["cashback_procent"] ?? 0,
        contractNum: json["contract_num"] ?? "",
        inn: json["inn"] ?? "",
        telegramChatId: json["telegram_chat_id"] ?? "",
        userId: json["user_id"] ?? 0,
        birthDate: json["birth_date"] ?? "",
        routeName: json["route_name"] ?? "",
        invDate: json["inv_date"] ?? "",
        payDate: json["pay_date"] ?? "",
        cashback: json["cashback"] ?? 0,
        summRass: json["summ_rass"] ?? 0,
        rassDate: json["rass_date"] ?? "",
        maxRassDate: json["max_rass_date"] ?? "",
        minRassDate: json["min_rass_date"] ?? "",
        summ: Utils.checkDouble(json["summ"]),
        summCur: json["summ_cur"]?.toDouble(),
        summDolg: json["summ_dolg"]?.toDouble(),
        summPred: json["summ_pred"]?.toDouble(),
        dayCount: json["day_count"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type_id": typeId,
        "region_id": regionId,
        "name": name,
        "address": address,
        "phone": phone,
        "is_active": isActive,
        "price_index": priceIndex,
        "use_savdo": useSavdo,
        "my_uuid": myUuid,
        "notes": notes,
        "cashback_procent": cashbackProcent,
        "contract_num": contractNum,
        "inn": inn,
        "telegram_chat_id": telegramChatId,
        "user_id": userId,
        "birth_date": birthDate,
        "route_name": routeName,
        "inv_date": invDate,
        "pay_date": payDate,
        "cashback": cashback,
        "summ_rass": summRass,
        "rass_date": rassDate,
        "max_rass_date": maxRassDate,
        "min_rass_date": minRassDate,
        "summ": summ,
        "summ_cur": summCur,
        "summ_dolg": summDolg,
        "summ_pred": summPred,
        "day_count": dayCount,
      };
}
