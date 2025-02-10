import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

import '../../core/mysettings.dart';
import '../../model/dic/dic_cat.dart';
import '../../service/http_service.dart';

class DicProdEditPage extends StatefulWidget {
  final int? catId;
  final DicProd? dicProd;
  final List<DicCat>? dicCat;

  const DicProdEditPage({super.key, this.dicProd, this.dicCat, this.catId});

  @override
  State<DicProdEditPage> createState() => _DicProdEditPageState();
}

class _DicProdEditPageState extends State<DicProdEditPage> {
  TextEditingController name = TextEditingController();
  TextEditingController ordNum = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController coeff = TextEditingController();
  TextEditingController format = TextEditingController();
  TextEditingController price1 = TextEditingController();
  TextEditingController price2 = TextEditingController();
  TextEditingController price3 = TextEditingController();
  TextEditingController price4 = TextEditingController();
  TextEditingController price5 = TextEditingController();
  TextEditingController price6 = TextEditingController();
  TextEditingController price7 = TextEditingController();
  TextEditingController price8 = TextEditingController();
  TextEditingController minZapas = TextEditingController();
  int isCurrency = 0;
  int checkName = 0;
  final _formKey = GlobalKey<FormState>();

  int? selectedId;
  bool first = true;

  @override
  void initState() {
    if (widget.dicProd != null) {
      name.text = widget.dicProd!.name;
      ordNum.text = widget.dicProd!.ordNum.toString();
      code.text = widget.dicProd!.code;
      coeff.text = widget.dicProd!.coeff.toString();
      format.text = widget.dicProd!.unit1;
      price1.text = Utils.myNumFormat0(widget.dicProd!.price1);
      price2.text = Utils.myNumFormat0(widget.dicProd!.price2);
      price3.text = widget.dicProd!.price3.toString();
      price4.text = widget.dicProd!.price4.toString();
      price5.text = widget.dicProd!.price5.toString();
      price6.text = widget.dicProd!.price6.toString();
      price7.text = widget.dicProd!.price7.toString();
      price8.text = widget.dicProd!.price8.toString();
      isCurrency = widget.dicProd!.isCur;
      selectedId = widget.dicProd!.catId;
      minZapas.text = widget.dicProd!.minOstQty.toString();
    } else {
      selectedId = widget.catId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.dicProd == null ? Text("Добавить товары") : Text("Редактировать товары"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                widget.dicProd == null ? await addProduct(settings) : await editProduct(settings);
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: getBody(settings),
    );
  }

  getBody(MySettings settings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(height: 150, decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/default.png")))),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: DropdownButtonFormField<int>(
                  value: selectedId,
                  decoration: InputDecoration(
                    labelText: "Название категории",
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                  ),
                  style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black),
                  items: widget.dicCat!.map((DicCat category) => DropdownMenuItem<int>(value: category.id, child: Text(category.name))).toList(),
                  menuMaxHeight: 400,
                  onChanged: (int? id) => setState(() => selectedId = id),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "Iltimos kategoriyani kiriting";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  myTextField(
                    "Наименование товара",
                    name,
                    TextInputType.text,
                    (value) {
                      if (checkName == 1 || checkName == 2) {
                        return "Bunday nomdagi tavar oldin kiritilgan $checkName";
                      }
                      if (value!.isEmpty) return "Tovar nomini kiriting";
                      return null;
                    },
                    null,
                    () => checkNameDate(settings),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: true, child: myTextField('Штрих код', code, TextInputType.text)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: true, child: myTextField('Coeff', coeff, TextInputType.number)),
                  Visibility(visible: true, child: myTextField('Формат', format, TextInputType.text)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField(
                    'Цена-1',
                    price1,
                    TextInputType.numberWithOptions(signed: false, decimal: true),
                    (value) {
                      if (value!.isEmpty) return "Цена-1 narxini kiriting";
                      return null;
                    },
                    CurrencyInputFormatter(),
                  ),
                  myTextField('Цена-2', price2, TextInputType.numberWithOptions(signed: false, decimal: true), null, CurrencyInputFormatter()),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: false, child: myTextField('Цена-3', price3, TextInputType.numberWithOptions(signed: false, decimal: true))),
                  Visibility(visible: false, child: myTextField('Цена-4', price4, TextInputType.numberWithOptions(signed: false, decimal: true))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: false, child: myTextField('Цена-5', price5, TextInputType.numberWithOptions(signed: false, decimal: true))),
                  Visibility(visible: false, child: myTextField('Цена-6', price6, TextInputType.numberWithOptions(signed: false, decimal: true))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: false, child: myTextField('Цена-7', price7, TextInputType.numberWithOptions(signed: false, decimal: true))),
                  Visibility(visible: false, child: myTextField('Цена-8', price8, TextInputType.numberWithOptions(signed: false, decimal: true))),
                ],
              ),
              Row(
                children: [
                  myTextField('Порядок номер', ordNum, TextInputType.numberWithOptions(signed: false, decimal: true)),
                  myTextField('Мин. запас', minZapas, TextInputType.numberWithOptions(signed: false, decimal: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(
    String text,
    TextEditingController controller,
    TextInputType keyboard, [
    String? Function(String?)? validator,
    CurrencyInputFormatter? inputFormatter,
    Function()? function,
  ]) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          onChanged: (value) {
            function!();
          },
          onTap: () {
            controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
          },
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
            errorStyle: TextStyle(fontSize: 12, height: 0.8),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          inputFormatters: inputFormatter != null ? [inputFormatter] : [],
        ),
      ),
    );
  }

  Future<void> addProduct(MySettings settings) async {
    String body = jsonEncode({
      "cat_id": selectedId,
      "ord_num": Utils.checkDouble(ordNum.text),
      "code": code.text,
      "name": name.text,
      "is_cur": isCurrency,
      "coeff": coeff.text,
      "unit1": format.text,
      "unit2": "",
      "price1": Utils.parseFormattedCurrency(price1.text),
      "price2": Utils.parseFormattedCurrency(price2.text),
      "price3": Utils.checkDouble(price3.text),
      "price4": Utils.checkDouble(price4.text),
      "price5": Utils.checkDouble(price5.text),
      "price6": Utils.checkDouble(price6.text),
      "price7": Utils.checkDouble(price7.text),
      "price8": Utils.checkDouble(price8.text),
      "must_imei": 0,
      "prod_format": "-",
      "min_ost_qty": null,
      "is_kg": null
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_prod/add", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> editProduct(MySettings settings) async {
    String body = jsonEncode({
      "cat_id": selectedId,
      "ord_num": ordNum.text,
      "code": code.text,
      "name": name.text,
      "is_cur": isCurrency,
      "coeff": coeff.text,
      "unit1": format.text,
      "unit2": widget.dicProd!.unit2,
      "price1": Utils.parseFormattedCurrency(price1.text),
      "price2": Utils.parseFormattedCurrency(price2.text),
      "price3": price3.text,
      "price4": price4.text,
      "price5": price5.text,
      "price6": price6.text,
      "price7": price7.text,
      "price8": price8.text,
      "must_imei": widget.dicProd!.mustImei,
      "prod_format": widget.dicProd!.prodFormat,
      "min_ost_qty": widget.dicProd!.minOstQty,
      "is_kg": widget.dicProd!.isKg
    });
    debugPrint(body);
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_prod/update/${widget.dicProd?.id}", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> checkNameDate(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_prod/checkname/${name.text}", settings);
    var data = jsonDecode(res);
    checkName = data["cc"];
    print(checkName);
    settings.saveAndNotify();
  }

  getErrorText() {}
}
