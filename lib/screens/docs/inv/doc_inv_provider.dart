import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_cat.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/model/dic/dic_wh.dart';
import 'package:flutter_savdogar/model/doc/doc_inv.dart';
import 'package:flutter_savdogar/model/doc/doc_inv_list.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';

import '../../../model/dic/dic_prod.dart';

class DocInvProvider extends ChangeNotifier {
  int whId = 0;
  int contraId = 0;
  int index = 0;
  int dicCatId = 0;

  String searchQuery = '';
  bool isSearching = false;

  List<DicContra> dicContra = [];
  List<DocInvList> invList = [];

  List<DicCat> dicCat = [];
  List<DicCat> filteredDicCat = [];

  List<DicProd> dicProd = [];
  List<DicProd> filteredDicProd = [];

  List<DicWh> dicWh = [];

  DateTime date = DateTime.now();
  final TextEditingController curdate = TextEditingController();
  final TextEditingController contraName = TextEditingController();
  final TextEditingController whName = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController markup = TextEditingController();
  final TextEditingController notes = TextEditingController();

  void loadFields(DocInv docInv) {
    curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, docInv.curdate);
    whId = docInv.whId;
    whName.text = docInv.whName;
    contraId = docInv.contraId;
    contraName.text = docInv.contraName;
    price.text = Utils.myNumFormat0(docInv.itogSumm);
    markup.text = docInv.bnProcent.toString();
    notes.text = docInv.notes;
  }

  void clearField() {
    curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, date.toString());
    contraName.text = "";
    whName.text = "";
    price.text = "";
    markup.text = "";
    notes.text = "";
    invList = [];
  }

  Future<void> getAllContra(MySettings settings, BuildContext context) async {
    try {
      var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
      var data = jsonDecode(res);
      dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
      settings.saveAndNotify();
      notifyListeners();
    } catch (e) {
      debugPrint("getAllContra error: $e");
    }
  }

  Future<void> getAllWh(MySettings settings, BuildContext context) async {
    try {
      var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_wh/get", settings);
      var data = jsonDecode(res);
      dicWh = (data as List).map((e) => DicWh.fromMapObject(e)).toList();
      settings.saveAndNotify();
      if (dicWh.length == 1) {
        whName.text = dicWh.first.name;
        whId = dicWh.first.id;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("getAllWh error: $e");
    }
  }

  Future<void> getInvList(MySettings settings, BuildContext context, int id) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/doc_inv_list/get-by-inv/$id", settings);
    var data = jsonDecode(res);
    invList = (data as List).map((e) => DocInvList.fromMapObject(e)).toList();
    settings.saveAndNotify();
    notifyListeners();
  }

  Future<void> getAllCat(MySettings settings, BuildContext context) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_cat/get", settings);
    var data = jsonDecode(res);
    dicCat = (data as List).map((e) => DicCat.fromMapObject(e)).toList();
    filteredDicCat = dicCat;
    settings.saveAndNotify();
    notifyListeners();
  }

  Future<void> getAllProducts(MySettings settings, BuildContext context) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_prod/get/$dicCatId", settings);
    var data = jsonDecode(res);
    dicProd = (data as List).map((e) => DicProd.fromMapObject(e)).toList();
    filteredDicProd = dicProd;
    settings.saveAndNotify();
    notifyListeners();
  }

  Future<void> addDocInv(MySettings settings, BuildContext context, int typeId) async {
    String body = jsonEncode({
      "type_id": typeId,
      "curdate": date.toString(),
      "curtime1": date.toString(),
      "contra_id": contraId,
      "notes": notes.text,
      "itog_summ": price.text,
      "itod_std_summ": 0,
      "itog_kg": 0,
      "itog_case": 0,
      "itog_pc": 0,
      "wh_id": whId,
      "is_printed": 1,
      "xarajat": null,
      "srok": date.toString(),
      "skidka": null,
      "price_index": 1,
      "to_wh_id": null,
      "has_error": 0,
      "reys": null,
      "procent_price": 0,
      "bn_procent": null,
      "is_cur": 1,
      "cur_rate": 12700,
      "doc_num": 0,
      "annul": null,
      "user_id": 0,
      "is_rass": null,
      "rass_date": null,
      "is_recovered": null,
      "is_sent": null,
      "is_accepted": null,
      "is_draft": null,
      "list": invList
          .map((e) => {
                "prod_id": e.prodId,
                "qty": e.qty,
                "qty_case": e.qtyCase,
                "price": e.price,
                "summ": e.summ,
                "price_std": e.priceStd,
                "status": e.status,
                "list_num": e.listNum,
                "party_price": e.partyPrice,
                "prod_id2": e.prodId2,
                "prod_height": e.prodHeight,
                "prod_width": e.prodWidth,
                "prod_qty": e.prodQty,
                "ost_qty": e.ostQty
              })
          .toList(),
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_inv/add", body, settings);
    var data = jsonDecode(res);
    debugPrint(data.toString());
    notifyListeners();
    settings.saveAndNotify();
  }

  Future<void> editDocInv(MySettings settings, BuildContext context, int invId) async {
    String body = jsonEncode({
      "curdate": date.toString(),
      "contra_id": contraId,
      "notes": notes.text,
      "itog_summ":Utils.parseFormattedCurrency(price.text),
      "itod_std_summ": 0,
      "itog_kg": 0,
      "itog_case": 0,
      "itog_pc": 0,
      "wh_id": whId,
      "is_printed": 1,
      "xarajat": null,
      "srok": date.toString(),
      "skidka": null,
      "price_index": 1,
      "to_wh_id": null,
      "has_error": 0,
      "reys": null,
      "procent_price": 0,
      "bn_procent": null,
      "cur_rate": 12700,
      "doc_num": 0,
      "is_cur": 1,
      "list": invList
          .map((e) => {
                "id": e.id,
                "prod_id": e.prodId,
                "qty": e.qty,
                "qty_case": e.qtyCase,
                "price": e.price,
                "summ": e.summ,
                "price_std": e.priceStd,
                "status": e.status,
                "list_num": e.listNum,
                "party_price": e.partyPrice,
                "prod_id2": e.prodId2,
                "prod_height": e.prodHeight,
                "prod_width": e.prodWidth,
                "prod_qty": e.prodQty,
                "ost_qty": e.ostQty
              })
          .toList(),
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_inv/update/$invId", body, settings);
    var data = jsonDecode(res);
    debugPrint(data.toString());
    notifyListeners();
    settings.saveAndNotify();
  }

  void searchCatData() {
    List<String> ss = searchQuery.split(" ");
    if (searchQuery.isEmpty) {
      filteredDicCat = dicCat;
    } else {
      filteredDicCat = dicCat.where((value) {
        if (ss.length <= 1) {
          return value.name.toLowerCase().contains(searchQuery.toLowerCase());
        } else {
          return value.name.toString().toLowerCase().contains(ss[0].trim()) && value.name.toString().toLowerCase().contains(ss[1].trim());
        }
      }).toList();
    }
    notifyListeners();
  }

  void searchProdData() {
    List<String> ss = searchQuery.split(" ");
    if (searchQuery.isEmpty) {
      filteredDicProd = dicProd;
    } else {
      filteredDicProd = dicProd.where((value) {
        if (ss.length <= 1) {
          return value.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              value.ordNum.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              value.id.toString().toLowerCase().contains(searchQuery.toLowerCase());
        } else {
          return value.name.toString().toLowerCase().contains(ss[0].trim()) && value.name.toString().toLowerCase().contains(ss[1].trim());
        }
      }).toList();
    }
    notifyListeners();
  }
}
