import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/obor.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class ViewObor extends StatefulWidget {
  const ViewObor({super.key});

  @override
  State<ViewObor> createState() => _ViewOborState();
}

class _ViewOborState extends State<ViewObor> {
  List<OborModel> oborList = [];
  List<OborModel> filteredList = [];
  bool isLoading = true;

  bool isSearching = false;
  String searchQuery = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getOborData(settings);
    }

    return Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? const Text("Оборот товара")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    filteredOstData(settings);
                  },
                  decoration: InputDecoration(hintText: 'Qidiruv...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () async {
                setState(() {
                  isSearching = !isSearching;
                });
                if (isSearching == false) {
                  filteredOstData(settings);
                }
              },
            ),
          ],
        ),
        body: getBody(settings));
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? oborList : filteredList;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredList.isEmpty
            ? const Center(child: Text("No data available"))
            : ListView.builder(
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredList[index].catName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: Text(filteredList[index].prodName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15))),
                          Text(
                            "${filteredList[index].qty} x ${filteredList[index].price} = ${filteredList[index].summ}",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.blue),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(),
                    ],
                  );
                },
              );
  }

  Future<void> getOborData(MySettings settings) async {
    try {
      setState(() {
        isLoading = true;
      });
      String body = jsonEncode({
        "date1": "2024-10-01",
        "date2": "2024-11-19",
        "product_id": "60",
      });
      var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_obor", body, settings);

      var data = jsonDecode(res);
      setState(() {
        oborList = (data as List).map((e) => OborModel.fromMap(e)).toList();
        isLoading = false;
      });
      settings.saveAndNotify();
      debugPrint(res);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching data: $e");
    }
  }

  filteredOstData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = oborList;
    } else {
      filteredList = oborList
          .where((element) =>
              element.prodName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.catName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.contraName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    settings.saveAndNotify();
  }
}
