import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<DicContra> dicContra  =[];
  List<DicZatrat> dicZatrat = [];
  List<DicWh> dicWh = [];
  final _formKey = GlobalKey<FormState>();

  String date = DateTime.now().toString();

  int? typeId;
  int payType = 1;
  int? whId;
  TextEditingController curdate = TextEditingController();
  TextEditingController whName = TextEditingController();
  int contraId = 0;
  TextEditingController contraName = TextEditingController();
  TextEditingController sum = TextEditingController(text: "0");
  TextEditingController sumPla = TextEditingController(text: "0");
  TextEditingController sumClick = TextEditingController(text: "0");
  TextEditingController sumRet = TextEditingController(text: "0");
  TextEditingController sumCur = TextEditingController(text: "0.00");
  TextEditingController curRate = TextEditingController(text: "0");
  TextEditingController sumReal = TextEditingController(text: "-");
  TextEditingController notes = TextEditingController();

  int? zatratId;
  TextEditingController zatratName = TextEditingController();

  int? userId;
  int? forCashback;
  int? forQty;

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllContra(settings);
      getAllZatrat(settings);
      getAllWh(settings);
      getCurRate(settings);
      loadData(settings);
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: widget.docCash != null ? Text("Изменить") : Text("Новый")),
      body: getBody(settings),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            (widget.docCash != null) ? await editCashData(settings) : await addCashDate(settings);
            Navigator.pop(context);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.save),
      ),
    );
  }

  getBody(MySettings settings) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 65,
                      child: TextFormField(
                        onTap: () async {
                          date = await myDatePicker(context);
                          curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, date);
                        },
                        readOnly: true,
                        controller: curdate,
                        decoration: InputDecoration(
                          labelText: "Дата",
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 65,
                      child: GestureDetector(
                        onTap: () {
                          SelectDialog.showModal<String>(
                            context,
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
                                    SizedBox(height: 10),
                                    Divider(thickness: 1, height: 1),
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
                              errorBorder:
                                  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                              errorStyle: const TextStyle(fontSize: 12, height: 0.8),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Складни танланг';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  SelectDialog.showModal<DicContra>(
                    context,
                    items: dicContra,
                    showSearchBox: true,
                    searchBoxDecoration: InputDecoration(
                      labelText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      focusedBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      enabledBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
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
                            Text(
                              item.phone.trim(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Divider(thickness: 1, height: 1),
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
                      focusedBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      enabledBorder:
                          const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                      errorStyle: TextStyle(fontSize: 12, height: 0.8),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Мижозни танланг';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 12),
              Visibility(
                visible: widget.tabIndex == 2,
                child: GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<DicZatrat>(
                      context,
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
                              Divider(thickness: 1, height: 1),
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
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                        errorStyle: TextStyle(fontSize: 12, height: 0.8),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Харажатни танланг';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Сумма, сум',
                sum,
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatter: CurrencyInputFormatter(),
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Пластик',
                sumPla,
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatter: CurrencyInputFormatter(),
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Payme, click',
                sumClick,
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatter: CurrencyInputFormatter(),
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Сдачи',
                sumRet,
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatter: CurrencyInputFormatter(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: buildTextField(
                      "Сумма, \$",
                      sumCur,
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      inputFormatter: CurrencyInputFormatter(),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: buildTextField(
                      "Курс, \$",
                      curRate,
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      inputFormatter: CurrencyInputFormatter(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              buildTextField(
                'Итого',
                sumReal,
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                inputFormatter: CurrencyInputFormatter(),
              ),
              const SizedBox(height: 12),
              buildTextField('Примечание', notes),
            ],
          ),
        ),
      ),
    );
  }

  void loadData(MySettings settings) {
    if (widget.docCash != null) {
      typeId = widget.docCash!.typeId;
      payType = widget.docCash!.payType;
      whId = widget.docCash!.whId;
      date = widget.docCash!.curdate;
      curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, date);
      whName.text = widget.docCash!.whName;
      contraId = widget.docCash!.contraId;
      contraName.text = widget.docCash!.contraName;
      sum.text = Utils.myNumFormat0(widget.docCash!.summ);
      sumPla.text = Utils.myNumFormat0(widget.docCash!.summPla);
      sumClick.text = Utils.myNumFormat0(widget.docCash!.summClick);
      sumRet.text = Utils.myNumFormat0(widget.docCash!.summRet);
      sumCur.text = widget.docCash!.summCur.toString();
      curRate.text = Utils.myNumFormat0(widget.docCash!.curRate);
      sumReal.text = Utils.myNumFormat0(widget.docCash!.summReal);
      notes.text = widget.docCash!.notes;
      zatratId = widget.docCash!.zatratId;
      zatratName.text = widget.docCash!.zatratName;
      userId = widget.docCash!.userId;
      forCashback = widget.docCash!.forCashback;
      forQty = widget.docCash!.forQty;
    } else {
      curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, date);
      curRate.text = settings.curRate.toString();
    }
    settings.saveAndNotify();
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    String? hintText,
    TextInputType? keyboardType,
    TextInputFormatter? inputFormatter,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onTap: () {
          controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        },
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
        ),
        inputFormatters: inputFormatter != null ? [inputFormatter] : [],
      );

  Future<String> myDatePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990, 01, 01),
      lastDate: DateTime(2100, 01, 01),
      helpText: 'Sanani tanlang',
      cancelText: 'Bekor qilish',
      confirmText: 'Tanlash',
      fieldLabelText: 'Sanani kiriting',
    );
    return selectedDate.toString();
  }

  Future<void> editCashData(MySettings settings) async {
    String body = jsonEncode({
      "type_id": typeId,
      "pay_type": payType,
      "wh_id": whId,
      "curdate": Utils.myDateFormatFromStr1(Utils.formatYYYYMMddhhmm, date),
      "contra_id": contraId,
      "summ": Utils.parseFormattedCurrency(sum.text),
      "summ_pla": Utils.parseFormattedCurrency(sumPla.text),
      "summ_bank": 0,
      "summ_click": Utils.parseFormattedCurrency(sumClick.text),
      "summ_discount": 0,
      "summ_cur": Utils.parseFormattedCurrency(sumCur.text),
      "summ_ret": Utils.parseFormattedCurrency(sumRet.text),
      "summ_real": Utils.parseFormattedCurrency(sumReal.text),
      "cur_rate": Utils.parseFormattedCurrency(curRate.text),
      "notes": notes.text,
      "zatrat_id": zatratId,
      "zatrat_name": zatratName.text,
      "user_id": userId,
      "for_cashback": forCashback,
      "for_qty": forQty
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/update/${widget.docCash?.id}", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> addCashDate(MySettings settings) async {
    String body = jsonEncode({
      "type_id": widget.tabIndex + 1,
      "pay_type": payType,
      "annul": 0,
      "wh_id": whId,
      "curdate": Utils.myDateFormatFromStr1(Utils.formatYYYYMMddhhmm, date),
      "contra_id": contraId,
      "is_cur": 0,
      "invert_cur": 0,
      "summ": Utils.parseFormattedCurrency(sum.text),
      "summ_pla": Utils.parseFormattedCurrency(sumPla.text),
      "summ_bank": 0,
      "summ_click": Utils.parseFormattedCurrency(sumClick.text),
      "summ_discount": 0,
      "summ_cur": Utils.parseFormattedCurrency(sumCur.text),
      "summ_ret": Utils.parseFormattedCurrency(sumRet.text),
      "summ_real": Utils.parseFormattedCurrency(sumReal.text),
      "cur_rate": Utils.parseFormattedCurrency(curRate.text),
      "notes": notes.text,
      "zatrat_id": zatratId,
      "zatrat_name": zatratName.text,
      "user_id": userId,
      "for_cashback": forCashback,
      "for_qty": forQty,
      "is_accepted": 1,
      "is_recovered": 0
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/add", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> getAllContra(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
    var data = jsonDecode(res);
    dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
    settings.saveAndNotify();
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
    if (dicWh.length == 1) {
      whName.text = dicWh.first.name;
    }
    setState(() {});
  }

  Future<void> getCurRate(MySettings settings) async {
    String body = jsonEncode({});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/cur_rate", body, settings);
    var data = jsonDecode(res);
    settings.curRate = data['rate'];
    settings.saveAndNotify();
  }
}
