class OborModel {
  late int id;
  late String curdate;
  late int contraId;
  late int whId;
  late int prodId;
  late int qty;
  late int price;
  late int summ;
  late int sebprice;
  late int seb;
  late int docInvId;
  late int docInvListId;
  late int typeId;
  late String curtime;
  late int partyPrice;
  late int reys;
  late int docActId;
  late int docActListId;
  late String contraName;
  late String contraPhone;
  late String imei;
  late int docNum;
  late String whName;
  late String prodName;
  late String catName;

  OborModel({
    required this.id,
    required this.curdate,
    required this.contraId,
    required this.whId,
    required this.prodId,
    required this.qty,
    required this.price,
    required this.summ,
    required this.sebprice,
    required this.seb,
    required this.docInvId,
    required this.docInvListId,
    required this.typeId,
    required this.curtime,
    required this.partyPrice,
    required this.reys,
    required this.docActId,
    required this.docActListId,
    required this.contraName,
    required this.contraPhone,
    required this.imei,
    required this.docNum,
    required this.whName,
    required this.prodName,
    required this.catName,
  });

  factory OborModel.fromMap(Map<String, dynamic> json) => OborModel(
        id: json["id"] ?? 0,
        curdate: json["curdate"] ?? "",
        contraId: json["contra_id"] ?? 0,
        whId: json["wh_id"] ?? 0,
        prodId: json["prod_id"] ?? 0,
        qty: json["qty"] ?? 0,
        price: json["price"] ?? 0,
        summ: json["summ"] ?? 0,
        sebprice: json["sebprice"] ?? 0,
        seb: json["seb"] ?? 0,
        docInvId: json["doc_inv_id"] ?? 0,
        docInvListId: json["doc_inv_list_id"] ?? 0,
        typeId: json["type_id"] ?? 0,
        curtime: json["curtime"] ?? "",
        partyPrice: json["party_price"] ?? 0,
        reys: json["reys"] ?? 0,
        docActId: json["doc_act_id"] ?? 0,
        docActListId: json["doc_act_list_id"] ?? 0,
        contraName: json["contra_name"] ?? "",
        contraPhone: json["contra_phone"] ?? "",
        imei: json["imei"] ?? "",
        docNum: json["doc_num"] ?? 0,
        whName: json["wh_name"] ?? "",
        prodName: json["prod_name"] ?? "",
        catName: json["cat_name"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "curdate": curdate,
        "contra_id": contraId,
        "wh_id": whId,
        "prod_id": prodId,
        "qty": qty,
        "price": price,
        "summ": summ,
        "sebprice": sebprice,
        "seb": seb,
        "doc_inv_id": docInvId,
        "doc_inv_list_id": docInvListId,
        "type_id": typeId,
        "curtime": curtime,
        "party_price": partyPrice,
        "reys": reys,
        "doc_act_id": docActId,
        "doc_act_list_id": docActListId,
        "contra_name": contraName,
        "contra_phone": contraPhone,
        "imei": imei,
        "doc_num": docNum,
        "wh_name": whName,
        "prod_name": prodName,
        "cat_name": catName,
      };
}
