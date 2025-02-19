import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/deb.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

import '../../share/utils.dart';

class ViewDeb extends StatefulWidget {
  const ViewDeb({super.key});

  @override
  State<ViewDeb> createState() => _ViewDebState();
}

class _ViewDebState extends State<ViewDeb> {
  List<DebModel> debList = [];
  List<DebModel> filteredList = [];
  bool isLoading = true;

  bool isSearching = false;
  String searchQuery = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getDebData(settings);
    }

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text("Дебитор-кредиторы")
            : TextField(
                autofocus: true,
                onChanged: (value) async {
                  searchQuery = value;
                  filteredDebData(settings);
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
                filteredDebData(settings);
              }
            },
          ),
        ],
      ),
      body: getBody(settings),
    );
  }

  getBody(MySettings settings) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredList.isEmpty
            ? const Center(child: Text("No data available"))
            : RefreshIndicator(
                onRefresh: () async {
                  await getDebData(settings);
                },
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                filteredList[index].name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                            filteredList[index].summ > 0
                                ? Text(
                                    filteredList[index].summ.toString(),
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                                  )
                                : Text(filteredList[index].summ.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child:
                                  Text("Телефон: ${filteredList[index].phone}", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14)),
                            ),
                            Text(
                              Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, filteredList[index].invDate),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        const Divider(thickness: 1, height: 1),
                      ],
                    );
                  },
                ),
              );
  }

  Future<void> getDebData(MySettings settings) async {
    setState(() {
      isLoading = true;
    });
    String body = jsonEncode({
      "date2": "2024-11-13",
      "minmax": "5",
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_deb", body, settings);
    var data = jsonDecode(res);
    debList = (data as List).map((e) => DebModel.fromMap(e)).toList();
    filteredList = debList;
    filteredDebData(settings);
    isLoading = false;
    settings.saveAndNotify();
    debugPrint(res);
  }

  filteredDebData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = debList;
    } else {
      filteredList = debList
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.address.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.phone.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.notes.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.contractNum.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.routeName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.payDate.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.telegramChatId.toString().toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    settings.saveAndNotify();
  }
}
