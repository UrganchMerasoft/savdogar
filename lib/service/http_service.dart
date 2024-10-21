import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:http/http.dart';

class MyHttpService {
  static Future<String> GET(BuildContext context, String url, String body, MySettings settings) async {
    Response? res;

    try {
      res = await get(
        Uri.parse(url),
        headers: Utils.httpSimpleHeader(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
      return "";
    }
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res.body;
    }
    return res.statusCode.toString();
  }
}
