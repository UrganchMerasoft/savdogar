import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:http/http.dart';
import 'package:toastification/toastification.dart';

class MyHttpService {
  static Future<String> GET(BuildContext context, String url, MySettings settings) async {
    Response? res;
    try {
      res = await get(
        Uri.parse(url),
        headers: Utils.httpSimpleHeader(),
      );
    } catch (e) {
      _showToast(context, "Xato", "Server bilan aloqa yo'q: $e", ToastificationType.error);
      return "";
    }
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body;
    }
    return _handleResponse(context, res);
  }

  static Future<String> POST(BuildContext context, String url, String body, MySettings settings) async {
    Response? res;
    try {
      res = await post(
        Uri.parse(url),
        headers: Utils.httpSimpleHeader(),
        body: body,
      );
    } catch (e) {
      _showToast(context, "Xato", "Server bilan aloqa yo'q: $e", ToastificationType.error);
      return "";
    }

    return _handleResponse(context, res);
  }

  static Future<String> DELETE(BuildContext context, String url, MySettings settings) async {
    Response? res;

    try {
      res = await post(
        Uri.parse(url),
        headers: Utils.httpSimpleHeader(),
      );
    } catch (e) {
      _showToast(context, "Xato", "Server bilan aloqa yo'q: $e", ToastificationType.error);
      return "";
    }
    if (res.statusCode == 200 || res.statusCode == 201) {
      _showToast(context, "Malumot", "Muvaffaqiyatli o'chirildi", ToastificationType.success);
      return res.body;
    }

    return _handleResponse(context, res);
  }

  static String _handleResponse(BuildContext context, Response res) {
    switch (res.statusCode) {
      case 200:
      case 201:
        _showToast(context, "Muvaffaqiyatli", "Amal bajarildi.", ToastificationType.success);
        return res.body;
      case 400:
        _showToast(context, "Ogohlantirish", "Noto'g'ri so'rov (Bad Request 400)", ToastificationType.warning);
        return res.statusCode.toString();
      case 401:
        _showToast(context, "Xatolik mavjud", "Avtorizatsiya talab qilinadi (Unauthorized 401)", ToastificationType.error);
        return res.statusCode.toString();
      case 403:
        _showToast(context, "Xatolik mavjud", "Ruxsat yo'q (Forbidden 403)", ToastificationType.error);
        return res.statusCode.toString();
      case 404:
        _showToast(context, "Xatolik mavjud", "Topilmadi (Not Found 404)", ToastificationType.error);
        return res.statusCode.toString();
      case 500:
        _showToast(context, "Xatolik mavjud", "Serverda ichki xatolik (Internal Server Error 500)", ToastificationType.error);
        return res.statusCode.toString();
      case 502:
        _showToast(context, "Xatolik mavjud", "Noto'g'ri server javobi (Bad Gateway 502)", ToastificationType.error);
        return res.statusCode.toString();
      case 503:
        _showToast(context, "Xatolik mavjud", "Xizmat vaqtincha mavjud emas (Service Unavailable 503)", ToastificationType.error);
        return res.statusCode.toString();
      default:
        _showToast(context, "Xatolik mavjud", "Noma'lum xato: ${res.statusCode}", ToastificationType.error);
        return res.statusCode.toString();
    }
  }

  static void _showToast(BuildContext context, String title, String description, ToastificationType type) {
    toastification.show(
      context: context,
      type: type,
      title: Text(title),
      description: Text(description),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 3),
      progressBarTheme: ProgressIndicatorThemeData(color: _getProgressColor(type)),
      showProgressBar: true,
      backgroundColor: _getBackgroundColor(type),
      foregroundColor: Colors.white,
    );
  }

  static Color _getProgressColor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.info:
        return Colors.blue;
      case ToastificationType.warning:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  static Color _getBackgroundColor(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Colors.green;
      case ToastificationType.info:
        return Colors.blue;
      case ToastificationType.warning:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
