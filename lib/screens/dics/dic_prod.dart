import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';
import 'package:flutter_savdogar/screens/dics/dic_prod_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../model/dic/dic_cat.dart';

class DicProdPage extends StatefulWidget {
  final DicCat dicCat;
  final List<DicCat> dicCatData;

  const DicProdPage({super.key, required this.dicCat, required this.dicCatData});

  @override
  State<DicProdPage> createState() => _DicProdPageState();
}

class _DicProdPageState extends State<DicProdPage> {
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

  List<DicProd> dicProd = [];
  List<DicProd> filteredList = [];
  bool first = true;
  int editType = 1;

  bool isSearching = false;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      getAllProduct(settings, widget.dicCat.id);
      first = false;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? Text("Список товаров")
              : TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    searchQuery = value;
                    searchFilterData(settings);
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
                  if (isSearching == false) {
                    searchQuery = "";
                    searchFilterData(settings);
                  }
                });
              },
            ),
            IconButton(
              onPressed: () => changeInfoType(context, settings),
              icon: const Icon(Icons.published_with_changes_rounded),
            ),
          ],
        ),
        body: getBody(settings),
        floatingActionButton: _isFabVisible
            ? FloatingActionButton(
                onPressed: () async {
                  isSearching = false;
                  await Navigator.push(
                      context, MaterialPageRoute(builder: (context) => DicProdEditPage(dicCat: widget.dicCatData, catId: widget.dicCat.id)));
                  await getAllProduct(settings, widget.dicCat.id);
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  getBody(MySettings settings) {
    filteredList = searchQuery.isEmpty ? dicProd : filteredList;
    return RefreshIndicator(
      onRefresh: () async {
        await getAllProduct(settings, widget.dicCat.id);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: 40,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(widget.dicCat.name, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(filteredList[index].id),
                  endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const ScrollMotion(),
                    dragDismissible: true,
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await deleteProd(settings, filteredList[index].id);
                          await getAllProduct(settings, filteredList[index].catId);
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
                    onTap: () async {
                      searchQuery = "";
                      isSearching = false;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DicProdEditPage(dicProd: filteredList[index], dicCat: widget.dicCatData)),
                      );
                      await getAllProduct(settings, filteredList[index].catId);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                      decoration: BoxDecoration(color: index.isEven ? Colors.grey.shade200 : Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Image(image: AssetImage("assets/images/default.png"), width: 50, fit: BoxFit.contain),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(filteredList[index].name, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("${filteredList[index].coeff.toInt()}", style: Theme.of(context).textTheme.bodyLarge),
                                    Visibility(
                                      visible: filteredList[index].unit1.isNotEmpty,
                                      child: Text(" x ${filteredList[index].unit1}", style: Theme.of(context).textTheme.bodyLarge),
                                    ),
                                    const Spacer(),
                                    Text(Utils.myNumFormat0(filteredList[index].price1), style: Theme.of(context).textTheme.bodyLarge),
                                    SizedBox(width: 50),
                                    Text(getEditType(filteredList[index]),
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w900, fontSize: 16)),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAllProduct(MySettings settings, int catId) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_prod/get/$catId", settings);
    var data = jsonDecode(res);
    dicProd = (data as List).map((e) => DicProd.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  Future<void> deleteProd(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_prod/delete/$id", settings);
    debugPrint(res);
    if (res == "400") {
      MyHttpService.showToast(context, "Ushbu tavarni o'chirib bo'lmaydi", "Bu tavar bilan harakat bolgan", ToastificationType.warning);
    }
    settings.saveAndNotify();
  }

  String getEditType(DicProd dicProd) {
    if (editType == 1) {
      return Utils.myNumFormat0(dicProd.price1);
    } else if (editType == 2) {
      return Utils.myNumFormat0(dicProd.price2);
    } else if (editType == 3) {
      return dicProd.price3.toString();
    } else if (editType == 4) {
      return dicProd.price4.toString();
    } else if (editType == 5) {
      return dicProd.price5.toString();
    } else if (editType == 6) {
      return dicProd.price6.toString();
    } else if (editType == 7) {
      return dicProd.price7.toString();
    } else if (editType == 8) {
      return dicProd.price8.toString();
    } else if (editType == 9) {
      return Utils.myNumFormat0(dicProd.coeff);
    } else if (editType == 10) {
      return dicProd.unit1.toString();
    }
    return "";
  }

  changeInfoType(BuildContext context, MySettings settings) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text("Ma'lumot turini o'zgartirish", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(10, (index) {
                  final label = index < 8
                      ? "Цена-${index + 1}"
                      : index == 8
                          ? "Коефф"
                          : "Формат";
                  return RadioListTile<int>(
                    title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
                    value: index + 1,
                    groupValue: editType,
                    onChanged: (value) {
                      setState(() {
                        editType = value!;
                      });
                      Future.delayed(Duration(milliseconds: 400), () {
                        settings.saveAndNotify();
                        Navigator.pop(context);
                      });
                      // Navigator.pop(context);
                    },
                  );
                }),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          settings.saveAndNotify();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            fixedSize: Size.fromHeight(45),
                            backgroundColor: Color(0xFFfe9500)),
                        child: const Text('Bekor qilish', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
              alignment: Alignment.center,
            );
          },
        );
      },
    );
  }

  void searchFilterData(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredList = dicProd;
    } else {
      filteredList = dicProd.where((value) {
        return value.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            value.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
            value.ordNum.toString().toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    settings.saveAndNotify();
  }
}
