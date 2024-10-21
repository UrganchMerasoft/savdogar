class DocImei {
  late int id;
  late int invId;
  late int prodId;
  late double qty;
  late String imei;
  late int typeId;
  late String curdate;
  late int listNum;

  DocImei({
    required this.id,
    required this.invId,
    required this.prodId,
    required this.qty,
    required this.imei,
    required this.typeId,
    required this.curdate,
    required this.listNum,
  });

  factory DocImei.fromJson(Map<String, dynamic> json) {
    return DocImei(
      id: json['id'],
      invId: json['inv_id'],
      prodId: json['prod_id'],
      qty: json['qty'],
      imei: json['imei'],
      typeId: json['type_id'],
      curdate: json['curdate'],
      listNum: json['list_num'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inv_id': invId,
      'prod_id': prodId,
      'qty': qty,
      'imei': imei,
      'type_id': typeId,
      'curdate': curdate,
      'list_num': listNum,
    };
  }

  DocImei.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    invId = map['inv_id'] ?? 0;
    prodId = map['prod_id'] ?? 0;
    qty = map['qty'] ?? 0;
    imei = map['imei'] ?? "?";
    typeId = map['type_id'] ?? 0;
    curdate = map['curdate'] ?? 0;
    listNum = map['list_num'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['inv_id'] = invId;
    map['prod_id'] = prodId;
    map['qty'] = qty;
    map['imei'] = imei;
    map['type_id'] = typeId;
    map['curdate'] = curdate;
    map['list_num'] = listNum;

    return map;
  }
}
