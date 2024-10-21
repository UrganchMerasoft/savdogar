import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:http_parser/http_parser.dart' as hp;

import 'package:http/http.dart';
import 'package:mime/mime.dart';

Future<String> myHttpGet(
    BuildContext context, String token, String db, String url, DateTime date, GlobalKey<ScaffoldState> key, VoidCallback logOut, MySettings settings) async {
  Response? res;
  try {
    if (settings.timeOut > 0) {
      res = await get(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db))
          .timeout(Duration(seconds: settings.timeOut), onTimeout: () => _onTimeout());
    } else {
      res = await get(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db));
    }
  } catch (e) {
    debugPrint(e.toString());
    return "";
  }

  if (res.statusCode == 404) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Данные не найдены.")));
      }
    } catch (_) {}

    return "";
  }

  if (res.statusCode == 401) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Истекло логин.")));
      }
    } catch (_) {}
    logOut();
    return "";
  }

  if (res.statusCode != 200) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Server response error <> 200.")));
      }
    } catch (_) {}
    return "";
  }

  return res.body;
}

_onTimeout() {
  debugPrint("Time Out occurs");
}

Future<String> myHttpDelete(BuildContext context, String token, String db, String url, DateTime date, GlobalKey<ScaffoldState> key, VoidCallback logOut) async {
  Response? res;
  try {
    res = await delete(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db));
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
    }
    return "";
  }

  if (res.statusCode == 404) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Сервер не найден.")));
    }
    return "";
  }

  if (res.statusCode == 401) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Истекло логин.")));
    }
    logOut();
    return "";
  }

  if (res.statusCode != 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Server response error <> 200.")));
    }
    return "";
  }

  return res.body;
}

Future<String> myHttpPost(BuildContext context, String token, String db, String url, String body, DateTime date, GlobalKey<ScaffoldState>? key, VoidCallback logOut,
    MySettings settings) async {
  Response? res;
  try {
    if (settings.timeOut > 0) {
      res = await post(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db), body: body)
          .timeout(Duration(seconds: settings.timeOut), onTimeout: () => _onTimeout());
    } else {
      res = await post(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db), body: body);
    }
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
    return "";
  }

  if (res.statusCode == 404) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Сервер не найден.")));
    }
    return "";
  }

  if (res.statusCode == 401) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Истекло логин.")));
    }
    logOut();
    return "";
  }

  if (res.statusCode != 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Server response error <> 200.")));
    }
    return "";
  }

  return res.body;
}

Future<String> myHttpPut(BuildContext context, String token, String db, String url, String body, DateTime date, GlobalKey<ScaffoldState> key, VoidCallback logOut,
    MySettings settings) async {
  Response? res;
  try {
    if (settings.timeOut > 0) {
      res = await put(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db), body: body)
          .timeout(const Duration(seconds: 120), onTimeout: () => _onTimeout());
    } else {
      res = await put(Uri.parse(url), headers: Utils.httpSimpleJsonHeader("Bearer $token", date, db), body: body);
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
    }
    return "";
  }

  if (res.statusCode == 401) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Истекло логин.")));
    }
    logOut();
    return "";
  }

  if (res.statusCode != 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Server response error <> 200.")));
    }
    return "";
  }

  return res.body;
}

Future<String> myHttpPostFile(BuildContext context, String phone, String psw, String db, String url, Map<String, String> body, File image, File image2,
    GlobalKey<ScaffoldState> key, VoidCallback logOut) async {
  final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');
  final imageUploadRequest = MultipartRequest('POST', Uri.parse(url));
  final file = await MultipartFile.fromPath('file1', image.path, contentType: hp.MediaType(mimeTypeData[0], mimeTypeData[1]));

  imageUploadRequest.headers['phone'] = phone;
  imageUploadRequest.headers['psw'] = psw;
  imageUploadRequest.headers['db'] = db;
  imageUploadRequest.files.add(file);
  imageUploadRequest.fields.addAll(body);
  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await Response.fromStream(streamedResponse);
    if (response.statusCode != 200) {
      return "";
    }
    final String responseData = response.body;
    return responseData;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
    }
    debugPrint(e.toString());
    return "";
  }
}

Future<String> myHttpPostPic(BuildContext context, String phone, String psw, String url, Map<String, String> body, File image, File image2,
    GlobalKey<ScaffoldState> key, VoidCallback logOut) async {
  final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');
  final imageUploadRequest = MultipartRequest('POST', Uri.parse(url));
  final file = await MultipartFile.fromPath('file1', image.path, contentType: hp.MediaType(mimeTypeData[0], mimeTypeData[1]));

  imageUploadRequest.headers['phone'] = phone;
  imageUploadRequest.headers['psw'] = psw;
  imageUploadRequest.files.add(file);
  imageUploadRequest.fields.addAll(body);
  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await Response.fromStream(streamedResponse);
    print("AA");
    print(response.body);
    if (response.statusCode != 200) {
      return "";
    }
    final String responseData = response.body;

    return responseData;
  } catch (e) {
    print(e);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Нет связь с сервером.")));
    }
    debugPrint(e.toString());
    return "";
  }
}
