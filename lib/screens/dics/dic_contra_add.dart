import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class DicContraAddPage extends StatefulWidget {
  final DicContra? dicContra;

  const DicContraAddPage({super.key, this.dicContra});

  @override
  State<DicContraAddPage> createState() => _DicContraAddPageState();
}

class _DicContraAddPageState extends State<DicContraAddPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController notes = TextEditingController();

  late DicContra dicContra;

  @override
  void initState() {
    if (widget.dicContra != null) {
      name.text = widget.dicContra!.name;
      phone.text = widget.dicContra!.phone;
      address.text = widget.dicContra!.address;
      notes.text = widget.dicContra!.notes;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: widget.dicContra != null ? const Text("Редактировать клиента") : const Text("Добавить новый клиент"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.dicContra != null) const SizedBox(height: 20),
            if (widget.dicContra != null)
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.dicContra!.name, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center)),
            const SizedBox(height: 20),
            myTextFormField("Ф.И.О", name),
            myTextFormField("Телефон", phone),
            myTextFormField("Адрес", address),
            myTextFormField("Выберите регион", address),
            myTextFormField("Примечание", notes),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          if (widget.dicContra == null) {
            contraAdd(settings);
          } else {
            contraEdit(settings);
            setState(() {});
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  myTextFormField(String labelText, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)), borderSide: BorderSide(width: 1, color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
        ),
      ),
    );
  }

  void contraAdd(MySettings settings) async {
    String body = jsonEncode({
      "type_id": 1,
      "region_id": 1,
      "name": name.text,
      "address": address.text,
      "phone": phone.text,
      "price_index": 0,
      "notes": notes.text,
      "cashback_procent": 0,
      "contract_num": null,
      "inn": null,
      "telegram_chat_id": null,
      "birth_date": null
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_contra/add", body, settings);
    print(res);
    setState(() {});
  }

  void contraEdit(MySettings settings) async {
    String body = jsonEncode({
      "type_id": 1,
      "region_id": 1,
      "name": name.text,
      "address": address.text,
      "phone": phone.text,
      "price_index": 0,
      "notes": notes.text,
      "cashback_procent": 0,
      "contract_num": null,
      "inn": null,
      "telegram_chat_id": null,
      "birth_date": null
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_contra/update/${widget.dicContra?.id}", body, settings);
    print("AAAAAAAAAA: $res");
  }
}
