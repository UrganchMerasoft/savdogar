import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/zatrat.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class ViewZatrat extends StatefulWidget {
  const ViewZatrat({super.key});

  @override
  State<ViewZatrat> createState() => _ViewZatratState();
}

class _ViewZatratState extends State<ViewZatrat> {
  List<ZatratModel> zatratList = [];
  List<ZatratModel> filteredList = [];
  bool isLoading = true;

  bool isSearching = false;
  String searchQuery = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getZatratData(settings);
    }

    return Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? const Text("Затраты")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    filteredZatratData(settings);
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
                  filteredZatratData(settings);
                }
              },
            ),
          ],
        ),
        body: getBody(settings));
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? zatratList : filteredList;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredList.isEmpty
            ? const Center(child: Text("No data available"))
            : ListView.builder(
                padding: EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(filteredList[index].name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child:
                                  Text(filteredList[index].price1.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15))),
                          Text(
                            "${filteredList[index].coeff} ${filteredList[index].unit1}",
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

  Future<void> getZatratData(MySettings settings) async {
    // try {
    setState(() {
      isLoading = true;
    });

    String body = jsonEncode({});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_zatrat", body, settings);

    var data = jsonDecode(res);
    setState(() {
      zatratList = (data as List).map((e) => ZatratModel.fromMap(e)).toList();
      isLoading = false;
    });
    settings.saveAndNotify();
    debugPrint(res);
    // } catch (e) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   debugPrint("Error fetching data: $e");
    // }
  }

  filteredZatratData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = zatratList;
    } else {
      filteredList = zatratList
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.ordNum.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.insertedAt.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    settings.saveAndNotify();
  }
}
