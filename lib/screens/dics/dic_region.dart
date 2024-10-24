import 'dart:convert';
import 'package:flutter/material.dart';
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
  List<DicRegion> dicRegion = [];
  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getRegion(settings).then((value) => print("Ok"));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Регионы"),
        actions: [
          IconButton(
              onPressed: () async {
                await showRegionDialog(context, settings);
                await getRegion(settings);
              },
              icon: const Icon(Icons.add),
              padding: const EdgeInsets.only(right: 20)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 15, right: 15),
        itemCount: dicRegion.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(dicRegion[index].id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await deleteRegion(settings, dicRegion[index].id);
                    await getRegion(settings);
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
                await getRegion(settings);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(dicRegion[index].name, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400)),
                  const SizedBox(height: 15),
                  const Divider(thickness: 1, height: 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getRegion(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_region/get", settings);
    print(res);
    var data = jsonDecode(res);
    dicRegion = (data as List).map((e) => DicRegion.fromMapObject(e)).toList();
    setState(() {});
  }

  Future<void> editRegion(MySettings settings, int id, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_region/update/$id", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> addRegion(MySettings settings, String name) async {
    String body = jsonEncode({"name": name});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_region/add", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> deleteRegion(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_region/delete/$id", settings);
    print(res);
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Регионы',
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ],
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
                if (regionName == null) {
                  await addRegion(settings, nameController.text);
                } else {
                  await editRegion(settings, id!, nameController.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
