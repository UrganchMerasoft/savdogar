import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

import '../../core/mysettings.dart';
import '../../model/dic/dic_cat.dart';
import '../../service/http_service.dart';

class DicProdEditPage extends StatefulWidget {
  final DicProd? dicProd;
  final List<DicCat>? dicCat;

  const DicProdEditPage({super.key, this.dicProd, this.dicCat});

  @override
  State<DicProdEditPage> createState() => _DicProdEditPageState();
}

class _DicProdEditPageState extends State<DicProdEditPage> {
  TextEditingController name = TextEditingController();
  TextEditingController ordNum = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController format = TextEditingController();
  TextEditingController price1 = TextEditingController();
  TextEditingController price2 = TextEditingController();
  TextEditingController price3 = TextEditingController();
  TextEditingController price4 = TextEditingController();
  TextEditingController price5 = TextEditingController();
  TextEditingController price6 = TextEditingController();
  TextEditingController price7 = TextEditingController();
  TextEditingController price8 = TextEditingController();
  int isCurrency = 0;

  int? selectedId;
  bool first = true;

  @override
  void initState() {
    if (widget.dicProd != null) {
      name.text = widget.dicProd!.name;
      ordNum.text = widget.dicProd!.ordNum.toString();
      code.text = widget.dicProd!.code;
      format.text = widget.dicProd!.unit1;
      price1.text = widget.dicProd!.price1.toString();
      price2.text = widget.dicProd!.price2.toString();
      price3.text = widget.dicProd!.price3.toString();
      price4.text = widget.dicProd!.price4.toString();
      price5.text = widget.dicProd!.price5.toString();
      price6.text = widget.dicProd!.price6.toString();
      price7.text = widget.dicProd!.price7.toString();
      price8.text = widget.dicProd!.price8.toString();
      isCurrency = widget.dicProd!.isCur;
      selectedId = widget.dicProd!.catId;
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
              if (widget.dicProd == null) {
                await addProduct(settings);
              } else {
                await editProduct(settings);
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(height: 200, decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/default.png")))),
              DropdownButtonFormField<int>(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                value: selectedId,
                decoration: InputDecoration(
                  labelText: "Название категории",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                ),
                items: widget.dicCat!.map((DicCat category) {
                  return DropdownMenuItem<int>(value: category.id, child: Text(category.name));
                }).toList(),
                menuMaxHeight: 400,
                onChanged: (int? id) {
                  setState(() {
                    selectedId = id;
                  });
                },
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Наименование товара",
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField('Код', code, TextInputType.text),
                  myTextField('Формат', format, TextInputType.text),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField('Цена-1', price1, TextInputType.number),
                  myTextField('Цена-2', price2, TextInputType.number),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField('Цена-3', price3, TextInputType.number),
                  myTextField('Цена-4', price4, TextInputType.number),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField('Цена-5', price5, TextInputType.number),
                  myTextField('Цена-6', price6, TextInputType.number),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTextField('Цена-7', price7, TextInputType.number),
                  myTextField('Цена-8', price8, TextInputType.number),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                height: 60,
                width: 150,
                child: TextFormField(
                  controller: ordNum,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Порядковый номер',
                    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(String text, TextEditingController controller, TextInputType keyboard) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 5),
        height: 60,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
          ),
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
      "coeff": 1,
      "unit1": format.text,
      "unit2": "",
      "price1": Utils.checkDouble(price1.text),
      "price2": Utils.checkDouble(price2.text),
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
    print(res);
    settings.saveAndNotify();
  }

  Future<void> editProduct(MySettings settings) async {
    String body = jsonEncode({
      "cat_id": selectedId,
      "ord_num": ordNum.text,
      "code": code.text,
      "name": name.text,
      "is_cur": isCurrency,
      "coeff": widget.dicProd!.coeff,
      "unit1": format.text,
      "unit2": widget.dicProd!.unit2,
      "price1": price1.text,
      "price2": price2.text,
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
    print(body);
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_prod/update/${widget.dicProd?.id}", body, settings);
    print(res);
    settings.saveAndNotify();
  }
}
