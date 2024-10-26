import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_cat.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';
import 'package:flutter_savdogar/screens/dics/dic_prod_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DicProdPage extends StatefulWidget {
  const DicProdPage({super.key});

  @override
  State<DicProdPage> createState() => _DicProdPageState();
}

class _DicProdPageState extends State<DicProdPage> {
  List<DicCat> dicCat = [];
  List<DicProd> dicProd = [];
  List<DicProd> filteredProd = [];
  bool first = true;
  int tab = 0;
  String catName = '';
  int editType = 1;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      getAllCategory(settings);
      getAllProduct(settings);
      first = false;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: tab == 0 ? const Text("Категория товаров") : const Text("Список товаров"),
          actions: [
            Visibility(
              visible: tab == 1,
              child: IconButton(
                onPressed: () => editInfoType(context, settings),
                icon: const Icon(Icons.published_with_changes_rounded),
              ),
            ),
            Visibility(
              visible: tab == 1,
              child: IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicProdEditPage())),
                icon: const Icon(Icons.add),
              ),
            ),
            Visibility(
              visible: tab == 0,
              child: IconButton(
                onPressed: () async {
                  await showEditDialog(settings);
                  await getAllCategory(settings);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: getBody(settings),
      ),
    );
  }

  getBody(MySettings settings) {
    if (tab == 0) {
      return getBodyCat(settings);
    }
    if (tab == 1) {
      return getBodyProd(settings);
    }
  }

  getBodyCat(MySettings settings) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 15, right: 15),
      itemCount: dicCat.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(dicCat[index].id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  await deleteCat(settings, dicCat[index].id);
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
          child: InkWell(
            onLongPress: () async {
              await showEditDialog(settings, dicCat[index]);
              await getAllCategory(settings);
            },
            onTap: () {
              filteredProd = dicProd.where((element) => element.catId == dicCat[index].id).toList();
              tab = 1;
              catName = dicCat[index].name;
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(dicCat[index].name, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 18)),
                const SizedBox(height: 15),
                const Divider(thickness: 1, height: 1),
              ],
            ),
          ),
        );
      },
    );
  }

  getBodyProd(MySettings settings) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            tab = 0;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.only(left: 15),
            height: 40,
            alignment: Alignment.center,
            color: Colors.grey.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_back, size: 25),
                const SizedBox(width: 25),
                Text(catName, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProd.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  color: index.isEven ? Colors.grey.shade50 : Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(image: AssetImage("assets/images/default.png"), width: 60, fit: BoxFit.contain),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(filteredProd[index].name, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text("${filteredProd[index].coeff.toInt()} ${filteredProd[index].unit1}", style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(width: 80),
                              Text(filteredProd[index].price1.toString(), style: Theme.of(context).textTheme.bodyLarge),
                              const Spacer(),
                              Text(getEditType(filteredProd[index]),
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w900, fontSize: 16)),
                              const SizedBox(width: 10)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  editInfoType(BuildContext context, MySettings settings) {
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
                    },
                  );
                }),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, fixedSize: const Size(100, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          settings.saveAndNotify();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, fixedSize: const Size(100, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
              alignment: Alignment.center,
            );
          },
        );
      },
    );
  }

  String getEditType(DicProd dicProd) {
    if (editType == 1) {
      return dicProd.price1.toString();
    } else if (editType == 2) {
      return dicProd.price2.toString();
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
      return dicProd.coeff.toString();
    } else if (editType == 10) {
      return dicProd.unit1.toString();
    }
    return "";
  }

  Future<void> showEditDialog(MySettings settings, [DicCat? cat]) {
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
                  ? const Text("Редактировать категорию", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87))
                  : const Text("Добавить категорию", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    width: 150,
                    child: TextFormField(
                      controller: ordNum,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Порядковый номер',
                        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 1, color: Colors.grey[400]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.5, color: Colors.blue)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: TextFormField(
                      controller: nameCat,
                      decoration: InputDecoration(
                        labelText: 'Название категории',
                        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 1, color: Colors.grey[400]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 1.5, color: Colors.blue)),
                      ),
                    ),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 25, 24, 5),
              actionsPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        fixedSize: const Size(100, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        shadowColor: Colors.redAccent,
                        elevation: 3,
                      ),
                      child: const Text('Отмена', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (cat != null) {
                          await editCat(settings, ordNum.text, nameCat.text.trim(), cat);
                        } else {
                          await addCat(settings, nameCat.text.trim(), int.parse(ordNum.text));
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        fixedSize: const Size(100, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        shadowColor: Colors.blueAccent,
                        elevation: 3,
                      ),
                      child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Future<void> getAllCategory(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_cat/get", settings);
    // print(res);
    var data = jsonDecode(res);
    dicCat = (data as List).map((e) => DicCat.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  void getAllProduct(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_prod/get", settings);
    // print(res);
    var data = jsonDecode(res);
    dicProd = (data as List).map((e) => DicProd.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  Future<void> editCat(MySettings settings, String ordNum, String name, DicCat cat) async {
    String body = jsonEncode({
      "ord_num": int.parse(ordNum),
      "name": name,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_cat/update/${cat.id}", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> addCat(MySettings settings, String name, int ordNum) async {
    String body = jsonEncode({
      "ord_num": ordNum,
      "name": name,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dic_cat/add", body, settings);
    print(res);
    settings.saveAndNotify();
  }

  Future<void> deleteCat(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_cat/delete/$id", settings);
    print(res);
    settings.saveAndNotify();
  }
}
