import 'dart:math';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static final Utils _singleton = Utils._internal();

  static Map<String, String> httpSimpleJsonHeader(String token, DateTime date, String db) => {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": token,
        "db": db,
        "date": date.millisecondsSinceEpoch.toString(),
        "charset": "utf-8"
      };

  static DateFormat formatYYYYMMdd = DateFormat('yyyy-MM-dd');
  static DateFormat formatYYYYMMddhhmm = DateFormat('yyyy-MM-dd HH:mm');
  static DateFormat formatDDMMYYYYHHMM = DateFormat('dd.MM.yyyy HH:mm');
  static DateFormat formatDDMMYYYYHHMMSS = DateFormat('dd.MM.yyyy HH:mm:ss');
  static DateFormat formatDDMM = DateFormat('dd.MM');
  static DateFormat formatDDMMYYYY = DateFormat('dd.MM.yyyy');

  static DateFormat formatHHMM = DateFormat('HH:mm');
  static DateFormat formatHHMMSS = DateFormat('HH:mm:ss');
  static NumberFormat numFormat0_00 = NumberFormat.simpleCurrency(name: "", decimalDigits: 2);
  static NumberFormat numFormat0 = NumberFormat.simpleCurrency(name: "", decimalDigits: 0);
  static NumberFormat numFormatCurrent = NumberFormat.simpleCurrency(name: "", decimalDigits: 0);

  static String myDateFormat(DateFormat f, DateTime val) {
    return f.format(val);
  }

  static String myDateFormatFromInt(DateFormat f, int val) {
    return f.format(DateTime.fromMillisecondsSinceEpoch(val * 1000, isUtc: false));
  }

  static String myDateFormatFromStr(DateFormat f, String val) {
    return f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(val) * 1000, isUtc: false));
  }

  static String myDateFormatFromStr1(DateFormat f, String val) {
    DateTime time = DateTime.parse(val);
    return f.format(time);
  }

  static String formatPhone(String phone) {
    if (phone.length == 9) {
      return "${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5)}";
    }
    return phone;
  }

  static String myNumFormat(NumberFormat f, double d) {
    if (d == 0) {
      return "0";
    }
    return f.format(d);
  }

  static String myNumFormat2(double d) {
    if (d == 0) {
      return "0";
    }
    if ((d - d.roundToDouble()).abs() < 0.01) {
      return Utils.numFormatCurrent.format(d).replaceAll(",", "").replaceAll(".", ",");
    } else {
      return Utils.numFormat0_00.format(d).replaceAll(",", "").replaceAll(".", ",");
    }
  }

  static String myNumFormat2_(double d) {
    if (d == 0) {
      return "";
    }
    if ((d - d.roundToDouble()).abs() < 0.01) {
      return Utils.numFormatCurrent.format(d).replaceAll(",", " ").replaceAll(".", ",");
    } else {
      return Utils.numFormat0_00.format(d).replaceAll(",", " ").replaceAll(".", ",");
    }
  }

  static String myNumFormat0(double d) {
    if (d == 0) {
      return "0";
    }
    return Utils.numFormatCurrent.format(d).replaceAll(",", " ").replaceAll(".", ",");
  }

  static String myNumFormat0_(double d) {
    if (d == 0) {
      return "-";
    }
    return Utils.numFormatCurrent.format(d).replaceAll(",", " ").replaceAll(".", ",");
  }

  static String myUUID() {
    return const Uuid().v1();
  }

  static double dp(double val, int places) {
    //double mod = pow(10.0, places);
    return 0.0;
  }

  static double checkDouble(dynamic value) {
    if (value == null) {
      return 0.00;
    }

    if (value is String) {
      if (value == "") {
        return 0.0;
      }
      return double.parse(value);
    } else {
      if (value is int) {
        return value + 0.0;
      } else {
        return value;
      }
    }
  }

  static List<String> get days {
    return ['Все', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  }

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static int getDateInt() {
    DateTime now = DateTime.now();
    DateTime d = DateTime(now.year, now.month, now.day);
    int inSeconds = d.millisecondsSinceEpoch ~/ 1000;
    return inSeconds;
  }

  static DateTime getDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static int getNowInt() {
    double inSeconds = (DateTime.now()).millisecondsSinceEpoch / 1000;
    return inSeconds.toInt();
  }

  static DateTime getNow() {
    return DateTime.now();
  }

  static Map<String, String> httpSimpleHeader() => {
        "Content-Type": "application/json; charset=utf-8",
        "charset": "utf-8",
      };
}
