import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/model/dic/dic_wh.dart';
import 'package:flutter_savdogar/model/dic/dic_zatrat.dart';
import 'package:flutter_savdogar/model/doc/doc_cash.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import '../../../service/http_service.dart';

class DocCashEditPage extends StatefulWidget {
  final DocCash? docCash;
  final int tabIndex;

  const DocCashEditPage({super.key, this.docCash, required this.tabIndex});

  @override
  State<DocCashEditPage> createState() => _DocCashEditPageState();
}

class _DocCashEditPageState extends State<DocCashEditPage> {
  List<DicContra> dicContra = [];
  List<DicZatrat> dicZatrat = [];
  List<DicWh> dicWh = [];

  int? typeId;

  int payType = 0;

  TextEditingController curdate = TextEditingController();

  int? whId;
  TextEditingController whName = TextEditingController();

  int? contraId;
  TextEditingController contraName = TextEditingController();

  TextEditingController sum = TextEditingController();
  TextEditingController sumPla = TextEditingController();
  TextEditingController sumClick = TextEditingController();
  TextEditingController sumRet = TextEditingController();
  TextEditingController sumCur = TextEditingController();
  TextEditingController curRate = TextEditingController();
  TextEditingController sumReal = TextEditingController();
  TextEditingController notes = TextEditingController();

  int? zatratId;
  TextEditingController zatratName = TextEditingController();

  int? userId;
  int? forCashback;
  int? forQty;

  bool first = true;

  String curdateMySql = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllContra(settings);
      getAllZatrat(settings);
      getAllWh(settings);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: widget.docCash != null ? Text("Изменить") : Text("Новый")),
      body: getBody(settings),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          (widget.docCash != null) ? await editCashData(settings) : await addCashDate(settings);
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
        child: Icon(Icons.save),
      ),
    );
  }

  getBody(MySettings settings) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: TextFormField(
                      onTap: () {
                        myDatePicker(context, settings);
                      },
                      readOnly: true,
                      controller: curdate,
                      decoration: InputDecoration(
                        labelText: "Дата",
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      ),
                    )),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: GestureDetector(
                    onTap: () {
                      SelectDialog.showModal<String>(
                        context,
                        label: "Склад",
                        selectedValue: whId == null || whId == "" ? null : dicWh.firstWhere((element) => element.id == whId).name,
                        items: List.generate(dicWh.length, (index) => dicWh[index].name),
                        showSearchBox: true,
                        searchBoxDecoration: InputDecoration(
                          labelText: 'Search',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          focusedBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          enabledBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                        ),
                        onFind: (text) async {
                          return dicWh.where((element) => element.name.toLowerCase().contains(text.toLowerCase())).map((e) => e.name).toList();
                        },
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item),
                                Divider(),
                              ],
                            ),
                            selected: isSelected,
                          );
                        },
                        onChange: (newValue) {
                          setState(() {
                            whName.text = newValue;
                            whId = dicWh.firstWhere((element) => element.name == whName.text).id;
                          });
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: whName,
                        decoration: InputDecoration(
                          labelText: 'Склад',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          focusedBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          enabledBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                print(contraId);
                print(contraName.text);
                SelectDialog.showModal<DicContra>(
                  context,
                  label: "Мижоз",
                  selectedValue: contraId == null || contraId == "" ? null : dicContra.firstWhere((element) => element.id == contraId),
                  items: dicContra,
                  showSearchBox: true,
                  searchBoxDecoration: InputDecoration(
                    labelText: 'Search',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                  ),
                  onFind: (String filter) async {
                    return dicContra.where((item) {
                      return item.name.toLowerCase().contains(filter.toLowerCase()) ||
                          item.address.toLowerCase().contains(filter.toLowerCase()) ||
                          item.phone.toLowerCase().contains(filter.toLowerCase()) ||
                          item.contractNum.toLowerCase().contains(filter.toLowerCase());
                    }).toList();
                  },
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.address.trim(),
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.phone.trim(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      selected: isSelected,
                    );
                  },
                  onChange: (newValue) {
                    setState(() {
                      contraId = newValue.id;
                      contraName.text = newValue.name;
                    });
                  },
                );
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: contraName,
                  decoration: InputDecoration(
                    labelText: 'Мижоз',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            Visibility(visible: widget.tabIndex == 2, child: SizedBox(height: 12)),
            Visibility(
              visible: widget.tabIndex == 2,
              child: GestureDetector(
                onTap: () {
                  print(zatratId);
                  print(zatratName.text);
                  SelectDialog.showModal<DicZatrat>(
                    context,
                    label: "Харажат",
                    selectedValue: zatratId == null || zatratId == "" ? null : dicZatrat.firstWhere((element) => element.id == zatratId),
                    items: dicZatrat,
                    showSearchBox: true,
                    searchBoxDecoration: InputDecoration(
                      labelText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      focusedBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      enabledBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                    ),
                    onFind: (text) async {
                      return dicZatrat.where((element) => element.name.toLowerCase().contains(text.toLowerCase())).toList();
                    },
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name),
                            Divider(),
                          ],
                        ),
                        selected: isSelected,
                      );
                    },
                    onChange: (newValue) {
                      setState(() {
                        zatratName.text = newValue.name;
                        zatratId = newValue.id;
                      });
                    },
                  );
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: zatratName,
                    decoration: InputDecoration(
                      labelText: 'Харажат',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      focusedBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      enabledBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            buildTextField('Сумма, сум', sum),
            const SizedBox(height: 12),
            buildTextField('Пластик', sumPla),
            const SizedBox(height: 12),
            buildTextField('Payme, click', sumClick),
            const SizedBox(height: 12),
            buildTextField('Сдачи', sumRet),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(flex: 2, child: buildTextField("Сумма, \$", sumCur)),
                SizedBox(width: 5),
                Expanded(flex: 1, child: buildTextField("Курс, \$", curRate)),
              ],
            ),
            const SizedBox(height: 12),
            buildTextField('Итого', sumReal),
            const SizedBox(height: 12),
            buildTextField('Примечание', notes),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {String? hintText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
      ),
    );
  }

  void loadData() {
    if (widget.docCash != null) {
      typeId = widget.docCash!.typeId;
      payType = widget.docCash!.payType;
      whId = widget.docCash!.whId;
      curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, widget.docCash!.curdate);
      curdateMySql = Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd, widget.docCash!.curdate);
      whName.text = widget.docCash!.whName;
      contraId = widget.docCash!.contraId;
      contraName.text = widget.docCash!.contraName;
      zatratId = widget.docCash!.zatratId;
      zatratName.text = widget.docCash!.zatratName;
      sum.text = widget.docCash!.summ.toString();
      sumPla.text = widget.docCash!.summPla.toString();
      sumClick.text = widget.docCash!.summClick.toString();
      sumRet.text = widget.docCash!.summRet.toString();
      sumCur.text = widget.docCash!.summCur.toString();
      curRate.text = widget.docCash!.curRate.toString();
      sumReal.text = widget.docCash!.summReal.toString();
      notes.text = widget.docCash!.notes;
    }
  }

  Future<void> myDatePicker(BuildContext context, MySettings settings) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2100, 01, 01),
      helpText: 'Sanani tanlang',
      cancelText: 'Bekor qilish',
      confirmText: 'Tanlash',
      fieldLabelText: 'Sanani kiriting',
    );

    if (selectedDate != null) {
      curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, selectedDate.toString());
      curdateMySql = Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd, selectedDate.toString());
      print(curdate.text);
    }
  }

  Future<void> editCashData(MySettings settings) async {
    String body = jsonEncode({
      "type_id": typeId,
      "pay_type": payType,
      "wh_id": whId,
      "curdate": curdateMySql,
      "contra_id": contraId,
      "summ": Utils.checkDouble(sum.text),
      "summ_pla": Utils.checkDouble(sumPla.text),
      "summ_bank": 0,
      "summ_click": Utils.checkDouble(sumClick.text),
      "summ_discount": 0,
      "summ_cur": Utils.checkDouble(sumCur.text),
      "summ_ret": Utils.checkDouble(sumRet.text),
      "summ_real": Utils.checkDouble(sumReal.text),
      "cur_rate": Utils.checkDouble(curRate.text),
      "notes": notes.text,
      "zatrat_id": zatratId,
      "zatrat_name": zatratName.text,
      "user_id": widget.docCash?.userId,
      "for_cashback": forCashback,
      "for_qty": forQty
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/update/${widget.docCash?.id}", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> addCashDate(MySettings settings) async {
    String body = jsonEncode({
      "type_id": widget.tabIndex + 1,
      "pay_type": 0,
      "annul": 0,
      "wh_id": whId,
      "curdate": curdateMySql,
      "contra_id": contraId,
      "is_cur": 0,
      "invert_cur": 0,
      "summ": Utils.checkDouble(sum.text),
      "summ_pla": Utils.checkDouble(sumPla.text),
      "summ_bank": 0,
      "summ_click": Utils.checkDouble(sumClick.text),
      "summ_discount": 0,
      "summ_cur": Utils.checkDouble(sumCur.text),
      "summ_ret": Utils.checkDouble(sumRet.text),
      "summ_real": Utils.checkDouble(sumReal.text),
      "cur_rate": Utils.checkDouble(curRate.text),
      "notes": notes.text,
      "zatrat_id": zatratId,
      "zatrat_name": zatratName.text,
      "user_id": 0,
      "for_cashback": forCashback,
      "for_qty": forQty,
      "is_accepted": 1,
      "is_recovered": 0
    });
    print("AAAAAAAA $body");
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/add", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> getAllContra(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
    var data = jsonDecode(res);
    dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
    setState(() {});
  }

  Future<void> getAllZatrat(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_zatrat/get", settings);
    var data = jsonDecode(res);
    dicZatrat = (data as List).map((e) => DicZatrat.fromMapObject(e)).toList();
    setState(() {});
  }

  Future<void> getAllWh(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_wh/get", settings);
    var data = jsonDecode(res);
    dicWh = (data as List).map((e) => DicWh.fromMapObject(e)).toList();
    setState(() {});
  }
}
