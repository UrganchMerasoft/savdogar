import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/screens/dics/dic_contra_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key});

  @override
  State<Supplier> createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  List<DicContra> supplierDate = [];
  List<DicContra> filteredList = [];

  bool first = true;
  bool isSearching = false;
  String searchQuery = '';

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getSupplierDate(settings);
    }
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text("Поставщики")
            : TextField(
                autofocus: true,
                onChanged: (value) async {
                  searchQuery = value;
                  searchSupplierData(settings);
                },
                decoration: InputDecoration(hintText: 'Qidiruv...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (isSearching == false) {
                  searchQuery = "";
                  searchSupplierData(settings);
                }
              });
            },
          ),
        ],
      ),
      body: getBody(settings),
      floatingActionButton: _isFabVisible
          ? FloatingActionButton(
              onPressed: () async {
                isSearching = false;
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DicContraEditPage(typeId: 0, appBarText: "Добавить новый поставщики")));
                await getSupplierDate(settings);
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? supplierDate : filteredList;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredList.isEmpty
            ? const Center(child: Text("No data available"))
            : RefreshIndicator(
                onRefresh: () async {
                  await getSupplierDate(settings);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(filteredList[index].id),
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await deleteSupplier(settings, filteredList[index].id);
                              searchSupplierData(settings);
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
                          isSearching = false;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DicContraEditPage(dicContra: filteredList[index], typeId: 0, appBarText: "Редактировать поставщики"),
                            ),
                          );
                          await getSupplierDate(settings);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text("${filteredList[index].id} - ${filteredList[index].name}",
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16)),
                            ),
                            const SizedBox(height: 5),
                            if (filteredList[index].address.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(filteredList[index].address.trim(), style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15)),
                              ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text("Телефон: ${filteredList[index].phone}", style: Theme.of(context).textTheme.bodySmall),
                            ),
                            const SizedBox(height: 10),
                            const Divider(thickness: 1, height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  void searchSupplierData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = supplierDate;
    } else {
      filteredList = supplierDate.where((doc) {
        return doc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            doc.notes.toLowerCase().contains(searchQuery.toLowerCase()) ||
            doc.address.toLowerCase().contains(searchQuery.toLowerCase()) ||
            doc.regionName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            doc.phone.toLowerCase().contains(searchQuery.toLowerCase()) ||
            doc.contractNum.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    settings.saveAndNotify();
  }

  Future<void> getSupplierDate(MySettings settings) async {
    setState(() {
      isLoading = true;
    });

    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/0", settings);
    var data = jsonDecode(res);
    supplierDate = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
    debugPrint(res);
    isLoading = false;
    settings.saveAndNotify();
  }

  Future<void> deleteSupplier(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_contra/delete/$id", settings);
    settings.saveAndNotify();
    debugPrint(res);
    if (res == "400") {
      MyHttpService.showToast(context, "Ushbu mijozni o'chira olmaysiz", "Bu mijoz bilan harakat mavjud", ToastificationType.warning);
    }
  }
}
