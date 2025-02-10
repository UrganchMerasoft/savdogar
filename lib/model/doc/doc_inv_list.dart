import 'package:flutter_savdogar/share/utils.dart';

class DocInvList {
  late int id;
  late int invId;
  late int prodId;
  late double qty;
  late double qtyCase;
  late double price;
  late double summ;
  late double priceStd;
  late int status;
  late int listNum;
  late double partyPrice;
  late String myUUID;
  late int prodId2;
  late double prodHeight;
  late double prodWidth;
  late double prodQty;
  late double ostQty;
  late String prodName;

  DocInvList({
    required this.id,
    required this.invId,
    required this.prodId,
    required this.qty,
    required this.qtyCase,
    required this.price,
    required this.summ,
    required this.priceStd,
    required this.status,
    required this.listNum,
    required this.partyPrice,
    required this.myUUID,
    required this.prodId2,
    required this.prodHeight,
    required this.prodWidth,
    required this.prodQty,
    required this.ostQty,
    required this.prodName,
  });

  factory DocInvList.fromJson(Map<String, dynamic> json) {
    return DocInvList(
      id: json['id'],
      invId: json['inv_id'],
      prodId: json['prod_id'],
      qty: json['qty'].toDouble(),
      qtyCase: json['qty_case'].toDouble(),
      price: json['price'].toDouble(),
      summ: json['summ'].toDouble(),
      priceStd: json['price_std'].toDouble(),
      status: json['status'],
      listNum: json['list_num'],
      partyPrice: json['party_price'].toDouble(),
      myUUID: json['my_uuid'],
      prodId2: json['prod_id2'],
      prodHeight: json['prod_height'].toDouble(),
      prodWidth: json['prod_width'].toDouble(),
      prodQty: json['prod_qty'].toDouble(),
      ostQty: json['ost_qty'].toDouble(),
      prodName: json['prod_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inv_id': invId,
      'prod_id': prodId,
      'qty': qty,
      'qty_case': qtyCase,
      'price': price,
      'summ': summ,
      'price_std': priceStd,
      'status': status,
      'list_num': listNum,
      'party_price': partyPrice,
      'my_uuid': myUUID,
      'prod_id2': prodId2,
      'prod_height': prodHeight,
      'prod_width': prodWidth,
      'prod_qty': prodQty,
      'ost_qty': ostQty,
      'prod_name': prodName,
    };
  }

  DocInvList.fromMapObject(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    invId = map['inv_id'] ?? 0;
    prodId = map['prod_id'] ?? 0;
    qty = Utils.checkDouble(map['qty']);
    qtyCase = Utils.checkDouble(map['qty_case']);
    price = Utils.checkDouble(map['price']);
    summ = Utils.checkDouble(map['summ']);
    priceStd = Utils.checkDouble(map['price_std']);
    status = map['status'] ?? 0;
    listNum = map['list_num'] ?? 0;
    partyPrice = Utils.checkDouble(map['party_price']);
    myUUID = map['my_uuid'] ?? "";
    prodId2 = map['prod_id2'] ?? 0;
    prodHeight = Utils.checkDouble(map['prod_height']);
    prodWidth = Utils.checkDouble(map['prod_width']);
    prodQty = Utils.checkDouble(map['prod_qty']);
    ostQty = Utils.checkDouble(map['ost_qty']);
    prodName = map['prod_name'] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inv_id': invId,
      'prod_id': prodId,
      'qty': qty,
      'qty_case': qtyCase,
      'price': price,
      'summ': summ,
      'price_std': priceStd,
      'status': status,
      'list_num': listNum,
      'party_price': partyPrice,
      'my_uuid': myUUID,
      'prod_id2': prodId2,
      'prod_height': prodHeight,
      'prod_width': prodWidth,
      'prod_qty': prodQty,
      'ost_qty': ostQty,
      'prod_name': prodName,
    };
  }
}
