import '../../share/utils.dart';

class ChartLine {
  late String curdate;
  late double summProdaja;
  late double summPayment;

  ChartLine({required this.curdate, required this.summProdaja, required this.summPayment});

  factory ChartLine.fromJson(Map<String, dynamic> json) {
    return ChartLine(
      curdate: json['type_name'],
      summProdaja: json['summ_prodaja'],
      summPayment: json['summ_payment'],
    );
  }

  Map<String, dynamic> toJson() => {"curdate": curdate, "summ_prodaja": summProdaja, "summ_payment": summPayment};

  ChartLine.fromMapObject(Map<String, dynamic> map) {
    curdate = map['curdate'] ?? "";
    summProdaja = Utils.checkDouble(map['summ_prodaja']);
    summPayment = Utils.checkDouble(map['summ_payment']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['curdate'] = curdate;
    map['summ_prodaja'] = summProdaja;
    map['summ_payment'] = summPayment;
    return map;
  }
}
