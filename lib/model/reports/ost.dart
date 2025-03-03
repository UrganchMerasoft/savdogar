class OstModel {
  late int prodId;
  late int qty;
  late String prodName;
  late String prodCode;
  late String unitName;
  late String catName;

  OstModel({
    required this.prodId,
    required this.qty,
    required this.prodName,
    required this.prodCode,
    required this.unitName,
    required this.catName,
  });

  OstModel.fromMapObject(Map<String, dynamic> map) {
    prodId = map['prod_id'] ?? 0;
    qty = map["qty"] ?? 0;
    prodName = map["prod_name"] ?? "";
    prodCode = map["prod_code"] ?? "";
    unitName = map["unit_name"] ?? "";
    catName = map["cat_name"] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["prod_id"] = prodId;
    map["qty"] = qty;
    map["prod_name"] = prodName;
    map["prod_code"] = prodCode;
    map["unit_name"] = unitName;
    map["cat_name"] = catName;
    return map;
  }
}
