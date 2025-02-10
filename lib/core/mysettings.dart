import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettings with ChangeNotifier {
  static int syncVersion = 0;
  static String version = "";

  SharedPreferences prefs;

  String serverUrl = "http://176.221.28.227:3333";
  String token = "";
  String userPhone = "";
  String userPsw = "";
  String userName = "";
  String avatarUrl = "";

  int curRate = 0;

  //Sprovochnik filter uchun fieldlar
  String contraFilter = "";

  // Kassa document uchun fieldlar
  String selectedDocCash = "";
  String statusDocCash = "";

  // Document sklady uchun fieldlar
  String selectedDocInv = "";
  String statusDocInv = "";

  late Locale locale = const Locale("ru", "RU");

  int timeOut = 0;

  late int newButtonHider = 0;

  MySettings(this.prefs) {
    load();
  }

  void load() {
    token = prefs.getString("token") ?? "";
    userName = prefs.getString("userName") ?? "";
    userPhone = prefs.getString("userPhone") ?? "";
    userPsw = prefs.getString("userPsw") ?? "";
    avatarUrl = prefs.getString("avatarUrl") ?? "";
    timeOut = prefs.getInt("timeOut") ?? 0;
    newButtonHider = prefs.getInt("newButtonHider") ?? 0;

    curRate = prefs.getInt("curRate") ?? 0;

    selectedDocCash = prefs.getString("selectedDocCash") ?? "";
    statusDocCash = prefs.getString("statusDocCash") ?? "";

    selectedDocInv = prefs.getString("selectedDocInv") ?? "";
    statusDocInv = prefs.getString("statusDocInv") ?? "";
    contraFilter = prefs.getString("contraFilter") ?? "";
  }

  Future<void> saveAndNotify() async {
    await save();
    notifyListeners();
  }

  save() async {
    await prefs.setString("token", token);
    await prefs.setString("userName", userName);
    await prefs.setString("userPhone", userPhone);
    await prefs.setString("userPsw", userPsw);
    await prefs.setString("avatarUrl", avatarUrl);
    await prefs.setInt("timeOut", timeOut);
    await prefs.setInt("newButtonHider", newButtonHider);

    await prefs.setInt("curRate", curRate);

    await prefs.setString("selectedDocCash", selectedDocCash);
    await prefs.setString("statusDocCash", statusDocCash);

    await prefs.setString("selectedDocInv", selectedDocInv);
    await prefs.setString("statusDocInv", statusDocInv);

    await prefs.setString("contraFilter", contraFilter);
  }

  void logout() {
    userName = "";
    userPhone = "";
    userPsw = "";
    token = "";
    saveAndNotify();
  }

  void cancelAll() {
    load();
    saveAndNotify();
  }
}
