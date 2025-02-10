import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/prod_move.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class ProdMove extends StatefulWidget {
  const ProdMove({super.key});

  @override
  State<ProdMove> createState() => _ProdMoveState();
}

class _ProdMoveState extends State<ProdMove> {
  List<ProdMoveModel> prodMoveList = [];
  List<ProdMoveModel> filteredList = [];
  bool isLoading = true;

  bool isSearching = false;
  String searchQuery = "";

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getProdMoveData(settings);
    }

    return Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? const Text("Затраты")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    filteredProdList(settings);
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
                  filteredProdList(settings);
                }
              },
            ),
          ],
        ),
        body: getBody(settings));
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? prodMoveList : filteredList;
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

  Future<void> getProdMoveData(MySettings settings) async {
    try {
      setState(() {
        isLoading = true;
      });

      String body = jsonEncode({});
      var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_prodmove", body, settings);

      var data = jsonDecode(res);
      setState(() {
        prodMoveList = (data as List).map((e) => ProdMoveModel.fromMapObject(e)).toList();
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

  filteredProdList(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = prodMoveList;
    } else {
      filteredList = prodMoveList
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
