import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_cat.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'dic_prod.dart';

class DicCatPage extends StatefulWidget {
  const DicCatPage({super.key});

  @override
  State<DicCatPage> createState() => _DicCatPageState();
}

class _DicCatPageState extends State<DicCatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  List<DicCat> dicCat = [];
  List<DicCat> filteredList = [];
  bool first = true;
  bool isSearching = false;
  String searchQuery = "";
  int lastOrdNum = 0;
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      getAllCategory(settings);
      first = false;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? Text("Категория товаров")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    searchCatData(settings);
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
                  searchQuery = "";
                  searchCatData(settings);
                }
              },
            ),
          ],
        ),
        body: getBody(settings),
        floatingActionButton: _isFabVisible
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  searchQuery = "";
                  isSearching = false;
                  await showEditCatDialog(settings);
                  await getAllCategory(settings);
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? dicCat : filteredList;
    return RefreshIndicator(
      onRefresh: () => getAllCategory(settings),
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(filteredList[index].id),
            endActionPane: ActionPane(
              extentRatio: 0.45,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await showEditCatDialog(settings, filteredList[index]);
                    await getAllCategory(settings);
                    setState(() {});
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  spacing: 8,
                  autoClose: true,
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await deleteCat(settings, filteredList[index].id);
                    await getAllCategory(settings);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  autoClose: true,
                ),
              ],
            ),
            child: Container(
              color: index.isEven ? Colors.grey.shade200 : Colors.white,
              child: InkWell(
                hoverColor: Colors.blue,
                focusColor: Colors.red,
                highlightColor: Colors.green,
                splashColor: Colors.blue,
                onLongPress: () async {
                  await showEditCatDialog(settings, filteredList[index]);
                  await getAllCategory(settings);
                  setState(() {});
                },
                onTap: () async {
                  searchQuery = "";
                  isSearching = false;
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (context) => DicProdPage(dicCat: filteredList[index], dicCatData: dicCat)));
                  await getAllCategory(settings);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: filteredList[index].ordNum < 10
                              ? Text("0${filteredList[index].ordNum}    ", style: Theme.of(context).textTheme.bodyLarge)
                              : Text("${filteredList[index].ordNum}    ", style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        Expanded(child: Text(filteredList[index].name, style: Theme.of(context).textTheme.bodyLarge)),
                        Spacer(),
                        Text(
                          filteredList[index].prodCount.toString(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade600, fontSize: 14),
                        ),
                        SizedBox(width: 15),
                        Icon(Icons.arrow_forward_ios_outlined, size: 12, color: Colors.grey.shade700),
                        SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 0.5, height: 1),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> getAllCategory(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_cat/get", settings);
    var data = jsonDecode(res);
    dicCat = (data as List).map((e) => DicCat.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  Future<void> editCat(MySettings settings, String ordNum, String name, DicCat cat) async {
    String body = jsonEncode({
      "ord_num": ordNum,
      "name": name,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_cat/update/${cat.id}", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> addCat(MySettings settings, String name, String ordNum) async {
    String body = jsonEncode({
      "ord_num": ordNum,
      "name": name,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_cat/add", body, settings);
    debugPrint(res);
    settings.saveAndNotify();
  }

  Future<void> deleteCat(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_cat/delete/$id", settings);
    debugPrint(res);
    if (res == "400") {
      MyHttpService.showToast(context, "Ushbu kategoriyani o'chira olmaysiz", "Bu kategoriyada tovarlar mavjud", ToastificationType.warning);
    }
    settings.saveAndNotify();
  }

  Future<void> getLastOrdNumber(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_cat/getlastordnum", settings);
    var data = jsonDecode(res);
    lastOrdNum = data["new_order_num"];
    settings.saveAndNotify();
  }

  Future<void> showEditCatDialog(MySettings settings, [DicCat? cat]) {
    TextEditingController nameCat = TextEditingController();
    TextEditingController ordNum = TextEditingController();
    if (cat != null) {
      nameCat.text = cat.name;
      ordNum.text = cat.ordNum.toString();
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: cat != null
                  ? Text("Редактировать категорию", style: Theme.of(context).textTheme.titleMedium)
                  : Text("Добавить категорию", style: Theme.of(context).textTheme.titleLarge),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: ordNum,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Порядoк номер',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onTertiary,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          enabledBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 1, color: Colors.grey[400]!)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.5, color: Colors.blue)),
                          suffixIcon: ElevatedButton(
                            onPressed: () async {
                              await getLastOrdNumber(settings);
                              ordNum.text = lastOrdNum.toString();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                            child: Icon(Icons.shuffle),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: nameCat,
                        decoration: InputDecoration(
                          labelText: 'Название категории',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.onTertiary,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                          enabledBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                          focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                          errorStyle: TextStyle(fontSize: 12, height: 0.8),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Kategoriya nomini kiriting";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 25, 24, 5),
              actionsPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
              actions: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade200,
                        fixedSize: Size(100, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        shadowColor: Colors.redAccent,
                        elevation: 3,
                      ),
                      child: const Text('Отмена', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (ordNum.text.isEmpty) {
                          await getLastOrdNumber(settings);
                          ordNum.text = lastOrdNum.toString();
                        }
                        if (_formKey.currentState?.validate() ?? false) {
                          cat == null
                              ? await addCat(settings, nameCat.text.trim(), ordNum.text)
                              : await editCat(settings, ordNum.text, nameCat.text.trim(), cat);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.blueAccent,
                        elevation: 3,
                      ),
                      child: const Text('Сохранить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void searchCatData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = dicCat;
    } else {
      filteredList = dicCat.where((value) {
        return value.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            value.ordNum.toString().toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    settings.saveAndNotify();
  }
}
