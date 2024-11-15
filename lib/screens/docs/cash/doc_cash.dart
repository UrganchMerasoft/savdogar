import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/doc/doc_cash.dart';
import 'package:flutter_savdogar/screens/docs/cash/doc_cash_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

class DocCashPage extends StatefulWidget {
  const DocCashPage({super.key});

  @override
  State<DocCashPage> createState() => _DocCashPageState();
}

class _DocCashPageState extends State<DocCashPage> {
  List<DocCash> docCash = [];
  bool first = true;
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getDocCashData(settings);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Кассовые дoкументы"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: getBody(settings),
      bottomNavigationBar: getNavBar(settings),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
        child: const Icon(Icons.add),
      ),
    );
  }

  getBody(MySettings settings) {
    return ListView.builder(
        itemCount: docCash.length,
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(docCash: docCash[index])));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Text(docCash[index].contraName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold))),
                    Text(Utils.myNumFormat0(docCash[index].summ))
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, docCash[index].curdate), style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                SizedBox(height: 10),
                Divider(height: 1, thickness: 1),
              ],
            ),
          );
        });
  }

  getNavBar(MySettings settings) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.arrow_downward, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Приходы"),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_upward, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Расходы"),
        BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_left, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Затрата"),
      ],
      onTap: (value) {
        tabIndex = value;
        setState(() {});
      },
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: tabIndex,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
    );
  }

  void getDocCashData(MySettings settings) async {
    String body = jsonEncode({
      "date1": "2024-01-11",
      "date2": "2024-11-11",
      "wh_id": 0,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/get", body, settings);
    var data = jsonDecode(res);
    docCash = (data["list"] as List).map((e) => DocCash.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }
}
