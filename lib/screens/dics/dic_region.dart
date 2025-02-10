import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_region.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DicRegionPage extends StatefulWidget {
  const DicRegionPage({super.key});

  @override
  State<DicRegionPage> createState() => _DicRegionPageState();
}

class _DicRegionPageState extends State<DicRegionPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  List<DicRegion> dicRegion = [];
  bool first = true;
  final _formKey = GlobalKey<FormState>();

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
      getAllRegion(settings).then((value) => debugPrint("Ok"));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Регионы")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: dicRegion.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(dicRegion[index].id),
            endActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await deleteRegion(settings, dicRegion[index].id);
                    await getAllRegion(settings);
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
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                await showRegionDialog(context, settings, dicRegion[index].name, dicRegion[index].id);
                await getAllRegion(settings);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(dicRegion[index].name, style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1, height: 1),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                await showRegionDialog(context, settings);
                await getAllRegion(settings);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> getAllRegion(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_region/get", settings);
    var data = jsonDecode(res);
    dicRegion = (data as List).map((e) => DicRegion.fromMapObject(e)).toList();
    setState(() {});
    debugPrint(res);
  }

  Future<void> editRegion(MySettings settings, int id, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_region/update/$id", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> addRegion(MySettings settings, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_region/add", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> deleteRegion(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_region/delete/$id", settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> showRegionDialog(BuildContext context, MySettings settings, [String? regionName, int? id]) async {
    TextEditingController nameController = TextEditingController();
    if (regionName != null) {
      nameController.text = regionName;
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(regionName != null ? 'Регион изменить' : 'Регион добавить'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Регионы',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                    errorStyle: const TextStyle(fontSize: 12, height: 0.5),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Region nomini kiriting!";
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
                  regionName == null ? await addRegion(settings, nameController.text) : await editRegion(settings, id!, nameController.text);
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
