class DicContra {
  late int id;
  late int typeId;
  late int regionId;
  late String name;
  late String address;
  late String phone;
  late int isActive;
  late int priceIndex;
  late int useSavdo;
  late String myUUID;
  late String notes;
  late double cashbackProcent;
  late String contractNum;
  late String inn;
  late String telegramChatId;
  late int userId;
  late String birthDate;
  late String regionName;

  DicContra({
    required this.id,
    required this.typeId,
    required this.regionId,
    required this.name,
    required this.address,
    required this.phone,
    required this.isActive,
    required this.priceIndex,
    required this.useSavdo,
    required this.myUUID,
    required this.notes,
    required this.cashbackProcent,
    required this.contractNum,
    required this.inn,
    required this.telegramChatId,
    required this.userId,
    required this.birthDate,
    required this.regionName,
  });

  factory DicContra.fromJson(Map<String, dynamic> json) {
    return DicContra(
      id: json['id'],
      typeId: json['type_id'],
      regionId: json['region_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      isActive: json['is_active'],
      priceIndex: json['price_index'],
      useSavdo: json['use_savdo'],
      myUUID: json['my_uuid'],
      notes: json['notes'],
      cashbackProcent: (json['cashback_procent'] as num).toDouble(),
      contractNum: json['contract_num'],
      inn: json['inn'],
      telegramChatId: json['telegram_chat_id'],
      userId: json['user_id'],
      birthDate: json['birth_date'],
      regionName: json['region_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_id": typeId,
        "region_id": regionId,
        "name": name,
        "address": address,
        "phone": phone,
        "is_active": isActive,
        "price_index": priceIndex,
        "use_savdo": useSavdo,
        "my_uuid": myUUID,
        "notes": notes,
        "cashback_procent": cashbackProcent,
        "contract_num": contractNum,
        "inn": inn,
        "telegram_chat_id": telegramChatId,
        "user_id": userId,
        "birth_date": birthDate,
        "region_name": regionName,
      };

  DicContra.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    typeId = map['type_id'] ?? 0;
    regionId = map['region_id'] ?? 0;
    name = map['name'] ?? "?";
    address = map['address'] ?? "?";
    phone = map['phone'] ?? "?";
    isActive = map['is_active'] ?? 0;
    priceIndex = map['price_index'] ?? 0;
    useSavdo = map['use_savdo'] ?? 0;
    myUUID = map['my_uuid'] ?? "";
    notes = map['notes'] ?? "";
    cashbackProcent = (map['cashback_procent'] as num?)?.toDouble() ?? 0.0;
    contractNum = map['contract_num'] ?? "";
    inn = map['inn'] ?? "";
    telegramChatId = map['telegram_chat_id'] ?? "";
    userId = map['user_id'] ?? 0;
    birthDate = map['birth_date'] ?? "";
    regionName = map['region_name'] ?? "?";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['type_id'] = typeId;
    map['region_id'] = regionId;
    map['name'] = name;
    map['address'] = address;
    map['phone'] = phone;
    map['is_active'] = isActive;
    map['price_index'] = priceIndex;
    map['use_savdo'] = useSavdo;
    map['my_uuid'] = myUUID;
    map['notes'] = notes;
    map['cashback_procent'] = cashbackProcent;
    map['contract_num'] = contractNum;
    map['inn'] = inn;
    map['telegram_chat_id'] = telegramChatId;
    map['user_id'] = userId;
    map['birth_date'] = birthDate;
    map['region_name'] = regionName;

    return map;
  }
}
