import 'package:flutter_savdogar/share/utils.dart';

class Info {
  late String typName;
  late double summ;

  Info({
    required this.typName,
    required this.summ,
  });

  Info.fromMapObject(Map<String, dynamic> map) {
    typName = map['typ_name'] ?? 0;
    summ = Utils.checkDouble(map['summ'] );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['typ_name'] = typName;
    map['summ'] = summ;
    return map;
  }
}

class ListElement {
  late int id;
  late String curdate;
  late int whId;
  late int contraId;
  late double summ;
  late int curRate;
  late int isCur;
  late int docInvId;
  late int docCashId;
  late int docActId;
  late String curtime;
  late int userId;
  late double typeId;
  late String notesInv;
  late String userName;
  late int itogQty;
  late String notesCash;
  late int forQtyCash;

  ListElement({
    required this.id,
    required this.curdate,
    required this.whId,
    required this.contraId,
    required this.summ,
    required this.curRate,
    required this.isCur,
    required this.docInvId,
    required this.docCashId,
    required this.docActId,
    required this.curtime,
    required this.userId,
    required this.typeId,
    required this.notesInv,
    required this.userName,
    required this.itogQty,
    required this.notesCash,
    required this.forQtyCash,
  });

  ListElement.fromMapObject(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    curdate = json["curdate"] ?? "?";
    whId = json["wh_id"] ?? 0;
    contraId = json["contra_id"] ?? 0;
    summ = Utils.checkDouble(json["summ"]);
    curRate = json["cur_rate"] ?? 0;
    isCur = json["is_cur"] ?? 0;
    docInvId = json["doc_inv_id"] ?? 0;
    docCashId = json["doc_cash_id"] ?? 0;
    docActId = json["doc_act_id"] ?? 0;
    curtime = json["curtime"] ?? "?";
    userId = json["user_id"] ?? 0;
    typeId = Utils.checkDouble(json["type_id"]);
    notesInv = json["notes_inv"] ?? "?";
    userName = json["user_name"] ?? "?";
    itogQty = json["itog_qty"] ?? 0;
    notesCash = json["notes_cash"] ?? "?";
    forQtyCash = json["for_qty_cash"] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["curdate"] = curdate;
    map["wh_id"] = whId;
    map["contra_id"] = contraId;
    map["summ"] = summ;
    map["cur_rate"] = curRate;
    map["is_cur"] = isCur;
    map["doc_inv_id"] = docInvId;
    map["doc_cash_id"] = docCashId;
    map["doc_act_id"] = docActId;
    map["curtime"] = curtime;
    map["user_id"] = userId;
    map["type_id"] = typeId;
    map["notes_inv"] = notesInv;
    map["user_name"] = userName;
    map["itog_qty"] = itogQty;
    map["notes_cash"] = notesCash;
    map["for_qty_cash"] = forQtyCash;
    return map;
  }
}

class Product {
  late String curdate;
  late int whId;
  late int prodId;
  late int qty;
  late double price;
  late double summ;
  late String curtime;
  late int typeId;
  late String productName;
  late int productCoeff;
  late String productUnit1;
  late String productUnit2;
  late String productCategory;

  Product({
    required this.curdate,
    required this.whId,
    required this.prodId,
    required this.qty,
    required this.price,
    required this.summ,
    required this.curtime,
    required this.typeId,
    required this.productName,
    required this.productCoeff,
    required this.productUnit1,
    required this.productUnit2,
    required this.productCategory,
  });

  Product.fromMapObject(Map<String, dynamic> json) {
    curdate = (json["curdate"]) ?? "?";
    whId = json["wh_id"] ?? 0;
    prodId = json["prod_id"] ?? 0;
    qty = json["qty"] ?? 0;
    price = Utils.checkDouble(json["price"] );
    summ = Utils.checkDouble(json["summ"]);
    curtime = json["curtime"] ?? "?";
    typeId = json["type_id"] ?? 0;
    productName = json["product_name"] ?? "?";
    productCoeff = json["product_coeff"] ?? 0;
    productUnit1 = json["product_unit1"] ?? "?";
    productUnit2 = json["product_unit2"] ?? "?";
    productCategory = json["product_category"] ?? "?";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["curdate"] = curdate;
    map["wh_id"] = whId;
    map["prod_id"] = prodId;
    map["qty"] = qty;
    map["price"] = price;
    map["summ"] = summ;
    map["curtime"] = curtime;
    map["type_id"] = typeId;
    map["product_name"] = productName;
    map["product_coeff"] = productCoeff;
    map["product_unit1"] = productUnit1;
    map["product_unit2"] = productUnit2;
    map["product_category"] = productCategory;
    return map;
  }
}
