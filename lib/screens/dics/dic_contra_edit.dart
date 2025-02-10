import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/model/dic/dic_region.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class DicContraEditPage extends StatefulWidget {
  final DicContra? dicContra;
  final int? typeId;
  final String appBarText;

  const DicContraEditPage({super.key, this.dicContra, this.typeId, required this.appBarText});

  @override
  State<DicContraEditPage> createState() => _DicContraEditPageState();
}

class _DicContraEditPageState extends State<DicContraEditPage> {
  final _formKey = GlobalKey<FormState>();

  List<DicRegion> dicRegion = [];

  TextEditingController name = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(mask: '+998 ## ### ## ##', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController notes = TextEditingController();

  String? regionName;
  int? regionId;

  bool first = true;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();

  @override
  void initState() {
    if (widget.dicContra != null) {
      name.text = widget.dicContra!.name;
      phone.text = widget.dicContra!.phone;
      address.text = widget.dicContra!.address;
      notes.text = widget.dicContra!.notes;
      regionName = widget.dicContra?.regionName;
      regionId = widget.dicContra?.regionId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllRegion(settings);
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarText)),
      body: getBody(settings),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            widget.dicContra == null ? await contraAdd(settings) : await contraEdit(settings);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  getBody(MySettings settings) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  focusNode: focusNode1,
                  controller: name,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(focusNode2);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    labelText: "Ф.И.О",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
                    errorStyle: TextStyle(fontSize: 12, height: 0.8),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Илтимос, Ф.И.О киритинг";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  focusNode: focusNode2,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(focusNode3);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    labelText: "Телефон",
                    hintText: '+998',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
                    errorStyle: TextStyle(fontSize: 12, height: 0.8),
                  ),
                  inputFormatters: [phoneMask],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: address,
                  focusNode: focusNode3,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(focusNode4);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    labelText: "Адрес",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
                    errorStyle: TextStyle(fontSize: 12, height: 0.8),
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     SelectDialog.showModal<String>(
              //       context,
              //       showSearchBox: false,
              //       items: List.generate(dicRegion.length, (index) => dicRegion[index].name),
              //       constraints: BoxConstraints(maxHeight: 200),
              //       itemBuilder: (context, item, isSelected) {
              //         return ListTile(
              //           title: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Divider(thickness: 1, height: 1),
              //               SizedBox(height: 10),
              //               Text(item),
              //               SizedBox(height: 10),
              //               Divider(thickness: 1, height: 1),
              //             ],
              //           ),
              //           selected: isSelected,
              //         );
              //       },
              //       onChange: (newValue) {
              //         setState(() {
              //           regionName = newValue;
              //           regionId = dicRegion.firstWhere((element) => element.name == regionName).id;
              //         });
              //       },
              //     );
              //   },
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       decoration: InputDecoration(
              //         labelText: 'Склад',
              //         contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              //         focusedBorder:
              //         const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
              //         enabledBorder:
              //         const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
              //         suffixIcon: Icon(Icons.arrow_drop_down),
              //         errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
              //         errorStyle: const TextStyle(fontSize: 12, height: 0.8),
              //       ),
              //       autovalidateMode: AutovalidateMode.onUserInteraction,
              //
              //     ),
              //   ),
              // ),
              DropdownButtonFormField<DicRegion>(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onTertiary,
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  labelText: "Выберите регион",
                  labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                ),
                items: dicRegion.map((region) => DropdownMenuItem<DicRegion>(value: region, child: Text(region.name))).toList(),
                onChanged: (newValue) {
                  setState(() {
                    regionName = newValue?.name;
                    regionId = newValue?.id;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return "Илтимос, регионни танланг";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: notes,
                  focusNode: focusNode4,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    labelText: "Примечание",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey, width: 1)),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1)),
                    errorBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
                    errorStyle: TextStyle(fontSize: 12, height: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> contraAdd(MySettings settings) async {
    String body = jsonEncode({
      "type_id": widget.typeId,
      "region_id": regionId,
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
    settings.saveAndNotify();
    debugPrint(res);
  }

  Future<void> contraEdit(MySettings settings) async {
    String body = jsonEncode({
      "address": address.text,
      "birth_date": null,
      "contract_num": widget.dicContra?.contractNum,
      "id": widget.dicContra?.id,
      "inn": widget.dicContra?.inn,
      "is_active": widget.dicContra?.isActive,
      "my_uuid": widget.dicContra?.myUUID,
      "name": name.text,
      "notes": notes.text,
      "phone": phone.text,
      "price_index": widget.dicContra?.priceIndex,
      "region_id": regionId,
      "telegram_chat_id": widget.dicContra?.telegramChatId,
      "type_id": widget.typeId,
      "use_savdo": widget.dicContra?.useSavdo,
      "user_id": widget.dicContra?.userId,
      "cashback_procent": widget.dicContra?.cashbackProcent
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_contra/update/${widget.dicContra?.id}", body, settings);
    settings.saveAndNotify();
    debugPrint("AAAAAAAAAA: $res");
  }

  Future<void> getAllRegion(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_region/get", settings);
    debugPrint(res);
    var data = jsonDecode(res);
    dicRegion = (data as List).map((e) => DicRegion.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }
}
