import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/screens/dics/dic_contra_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DicContraPage extends StatefulWidget {
  const DicContraPage({super.key});

  @override
  State<DicContraPage> createState() => _DicContraPageState();
}

class _DicContraPageState extends State<DicContraPage> {
  List<DicContra> dicContra = [];
  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllContra(settings).then((value) => print("OK"));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Клиентская база"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        itemCount: dicContra.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(dicContra[index].id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await deleteContra(settings, dicContra[index].id);
                    await getAllContra(settings);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => DicContraEditPage(dicContra: dicContra[index])));
                await getAllContra(settings);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(dicContra[index].name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(dicContra[index].address.trim(), style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15)),
                  const SizedBox(height: 5),
                  Text("Телефон: ${dicContra[index].phone}", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1, height: 1),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DicContraEditPage()));
          await getAllContra(settings);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getAllContra(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
    var data = jsonDecode(res);
    dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
    setState(() {});
  }

  Future<void> deleteContra(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_contra/delete/$id", settings);
    print(res);
    settings.saveAndNotify();
  }
}
