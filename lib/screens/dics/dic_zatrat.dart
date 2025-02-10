import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_zatrat.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DicZatratPage extends StatefulWidget {
  const DicZatratPage({super.key});

  @override
  State<DicZatratPage> createState() => _DicZatratPageState();
}

class _DicZatratPageState extends State<DicZatratPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  final _formKey = GlobalKey<FormState>();
  int checkName = 0;
  List<DicZatrat> zatratData = [];
  bool first = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabVisible) setState(() => _isFabVisible = false);
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabVisible) setState(() => _isFabVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getZatratData(settings);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Xarajatlar")),
      body: getBody(settings),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                await myShowDialog(context, settings);
                await getZatratData(settings);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  getBody(MySettings settings) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: zatratData.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(zatratData[index].id),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  await deleteZatrat(settings, zatratData[index].id);
                  await getZatratData(settings);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                autoClose: true,
              ),
            ],
          ),
          child: InkWell(
            onTap: () async {
              await myShowDialog(context, settings, zatratData[index].name, zatratData[index].id);
              await getZatratData(settings);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(zatratData[index].name, style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(height: 15),
                const Divider(thickness: 1, height: 1),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getZatratData(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_zatrat/get", settings);
    debugPrint(res);
    var data = jsonDecode(res);
    zatratData = (data as List).map((e) => DicZatrat.fromMapObject(e)).toList();
    setState(() {});
  }

  Future<void> editZatrat(MySettings settings, int id, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_zatrat/update/$id", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> addZatrat(MySettings settings, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_zatrat/add", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> deleteZatrat(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_zatrat/delete/$id", settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> checkNameDate(MySettings settings, String name) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_zatrat/checkname/$name", settings);
    var data = jsonDecode(res);
    checkName = data["cc"];
    debugPrint(checkName.toString());
  }

  getErrorText() {
    if (checkName == 1 || checkName == 2) {
      return "Bunday nomdagi xarajat oldin kiritilgan $checkName";
    }
  }

  Future<void> myShowDialog(BuildContext context, MySettings settings, [String? name, int? id]) async {
    TextEditingController nameController = TextEditingController();
    if (name != null) {
      nameController.text = name;
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name != null ? "Xarajat o'zgartirish" : "Xarajat qo'shish"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Xarajat',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                    errorStyle: TextStyle(fontSize: 12, height: 0.8),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // errorText: getErrorText(),
                  ),
                  onChanged: (value) {
                    checkNameDate(settings, nameController.text);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Xarajat turini kiriting";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  name == null ? await addZatrat(settings, nameController.text) : await editZatrat(settings, id!, nameController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
