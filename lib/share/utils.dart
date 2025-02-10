import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static String convertDateToIso(String date) {
    List<String> parts = date.split('.');
    String day = parts[0];
    String month = parts[1];
    String year = parts[2];

    return '$year-$month-$day';
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
      return Utils.numFormatCurrent.format(d).replaceAll(",", " ").replaceAll(".", ",");
    } else {
      return Utils.numFormat0_00.format(d).replaceAll(",", " ").replaceAll(".", ",");
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

  static Future<DateTime?> myDatePicker(BuildContext context, DateTime date) async {
    DateTime? selectedDate = await showDatePicker(
      initialDate: date,
      context: context,
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2100, 01, 01),
      helpText: 'Sanani tanlang',
      cancelText: 'Bekor qilish',
      confirmText: 'Tanlash',
      fieldLabelText: 'Sanani kiriting',
    );
    return selectedDate;
  }

  static double parseFormattedCurrency(String formattedValue) {
    String cleanedValue = formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanedValue) ?? 0.0;
  }
}

class DateTextFormatter1 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length && newValue.text.isNotEmpty && oldValue.text.isNotEmpty) {
      if (RegExp('[^0-9/]').hasMatch(newValue.text)) return oldValue;
      if (newValue.text.length > 10) return oldValue;
      if (newValue.text.length == 2 || newValue.text.length == 5) {
        return TextEditingValue(
          text: '${newValue.text}/',
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + 1,
          ),
        );
      } else if (newValue.text.length == 3 && newValue.text[2] != '/') {
        return TextEditingValue(
          text: '${newValue.text.substring(0, 2)}/${newValue.text.substring(2)}',
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + 1,
          ),
        );
      } else if (newValue.text.length == 6 && newValue.text[5] != '/') {
        return TextEditingValue(
          text: '${newValue.text.substring(0, 5)}/${newValue.text.substring(5)}',
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + 1,
          ),
        );
      }
    } else if (newValue.text.length == 1 && oldValue.text.isEmpty && RegExp('[^0-9]').hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '.');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.maxDigits = 20});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    if (newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    String newValueText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newValueText.isEmpty) {
      return newValue.copyWith(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    double value = double.parse(newValueText);

    final formatter = NumberFormat.decimalPattern('uz');
    String newText = formatter.format(value);
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
