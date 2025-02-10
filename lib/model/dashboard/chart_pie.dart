import '../../share/utils.dart';

class ChartPie {
  late int catId;
  late String catName;
  late double summ;

  ChartPie({required this.catId, required this.catName, required this.summ});

  ChartPie.fromMapObject(Map<String, dynamic> map) {
    catId = map['cat_id'] ?? 0;
    catName = map['cat_name'] ?? "";
    summ = Utils.checkDouble( map['summ'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['cat_id'] = catId;
    map['cat_name'] = catName;
    map['summ'] = summ;
    return map;
  }
}
