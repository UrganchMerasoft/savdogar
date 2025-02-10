import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/client_move.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

class ClientMove extends StatefulWidget {
  const ClientMove({super.key});

  @override
  State<ClientMove> createState() => _ClientMoveState();
}

class _ClientMoveState extends State<ClientMove> {
  List<WarehouseModel> clientMoveList = [];
  List<WarehouseModel> filteredList = [];
  bool isLoading = true;

  bool isSearching = false;
  String searchQuery = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getClientData(settings);
    }

    return Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? const Text("Затраты")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    filteredData(settings);
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
                  filteredData(settings);
                }
              },
            ),
          ],
        ),
        body: getBody(settings));
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? clientMoveList : filteredList;
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
                          Text(filteredList[index].regionName.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15)),
                          Spacer(),
                          Expanded(
                            child: Text(
                              "${filteredList[index].pay} x ${Utils.myNumFormat(Utils.numFormat0_00, filteredList[index].dolg)}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.blue),
                            ),
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

  Future<void> getClientData(MySettings settings) async {
    // try {
    setState(() {
      isLoading = true;
    });

    String body = jsonEncode({
      "date1": "2024-01-01",
      "date2": "2024-12-31",
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_clientmove", body, settings);

    var data = jsonDecode(res);
    setState(() {
      clientMoveList = (data as List).map((e) => WarehouseModel.fromMapObject(e)).toList();
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

  filteredData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = clientMoveList;
    } else {
      filteredList = clientMoveList
          .where((element) =>
              element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              element.regionName.toString().toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    settings.saveAndNotify();
  }
}
