import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/model/doc/doc_inv.dart';
import 'package:flutter_savdogar/screens/docs/inv/edit_inv_list.dart';
import 'package:flutter_savdogar/screens/docs/inv/doc_inv_provider.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';

class DocInvEdit extends StatefulWidget {
  final DocInv? docInv;
  final int typeId;

  const DocInvEdit({super.key, this.docInv, required this.typeId});

  @override
  State<DocInvEdit> createState() => _DocInvEditState();
}

class _DocInvEditState extends State<DocInvEdit> {
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<MySettings>(context, listen: false);
      final docInvProvider = Provider.of<DocInvProvider>(context, listen: false);

      if (widget.docInv != null) {
        docInvProvider.loadFields(widget.docInv!);
        docInvProvider.getInvList(settings, context, widget.docInv!.id);
      } else {
        docInvProvider.clearField();
      }
      docInvProvider.getAllCat(settings, context);
      docInvProvider.getAllWh(settings, context);
      docInvProvider.getAllContra(settings, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<MySettings>(context);
    final docInvProvider = Provider.of<DocInvProvider>(context);
    return PopScope(
      canPop: docInvProvider.index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          docInvProvider.isSearching = false;
          docInvProvider.searchQuery = "";
          docInvProvider.searchCatData();
          setState(() => docInvProvider.index = 0);
        }
        if (didPop) {
          docInvProvider.isSearching = false;
        }
      },
      child: Scaffold(
        appBar: myAppBar(docInvProvider, settings),
        body: _buildBody(settings, docInvProvider),
        bottomNavigationBar: getNavBar(settings),
      ),
    );
  }

  myAppBar(DocInvProvider docInvProvider, MySettings settings) {
    return AppBar(
      title: docInvProvider.isSearching && tabIndex == 1
          ? TextField(
              autofocus: true,
              onChanged: (value) async {
                docInvProvider.searchQuery = value;
                if (docInvProvider.index == 0) {
                  docInvProvider.searchCatData();
                } else if (docInvProvider.index == 1) {
                  docInvProvider.searchProdData();
                }
              },
              decoration: InputDecoration(hintText: 'Qidiruv...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
            )
          : Text(getAppBarText()),
      actions: [
        Visibility(
          visible: tabIndex == 1,
          child: IconButton(
            onPressed: () {
              setState(() => docInvProvider.isSearching = !docInvProvider.isSearching);
              if (!docInvProvider.isSearching) {
                docInvProvider.searchQuery = "";
                if (docInvProvider.index == 0) {
                  docInvProvider.searchCatData();
                } else {
                  docInvProvider.searchProdData();
                }
              }
            },
            icon: Icon(docInvProvider.isSearching ? Icons.close : Icons.search),
          ),
        ),
        IconButton(
          onPressed: () async {
            if (widget.docInv == null) {
              await docInvProvider.addDocInv(settings, context, widget.typeId);
            } else {
              await docInvProvider.editDocInv(settings, context, widget.docInv!.id);
            }
            setState(() {});
            Navigator.pop(context);
          },
          icon: Icon(Icons.save),
        ),
      ],
    );
  }

  String getAppBarText() {
    String getTitle(String title) => widget.docInv != null ? "Изменить $title" : "Новый $title";
    switch (widget.typeId) {
      case 1:
        return getTitle("приход");
      case 2:
        return getTitle("расход");
      case 3:
        return getTitle("возврат");
      case 4:
        return getTitle("брак");
      default:
        return "";
    }
  }

  Widget _buildBody(MySettings settings, DocInvProvider docInvProvider) {
    switch (tabIndex) {
      case 0:
        return getInfo(docInvProvider);
      case 1:
        return getProducts(settings, docInvProvider);
      case 2:
        return getInvProducts(settings, docInvProvider);
      default:
        return getInfo(docInvProvider);
    }
  }

  Widget getInfo(DocInvProvider docInvProvider) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 65,
                  child: TextFormField(
                    onTap: () async {
                      docInvProvider.date = (await (Utils.myDatePicker(context, docInvProvider.date)))!;
                      docInvProvider.curdate.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, docInvProvider.date.toString());
                    },
                    readOnly: true,
                    controller: docInvProvider.curdate,
                    decoration: InputDecoration(
                      labelText: "Дата",
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 65,
                  child: GestureDetector(
                    onTap: () {
                      SelectDialog.showModal<String>(
                        context,
                        showSearchBox: false,
                        items: List.generate(docInvProvider.dicWh.length, (index) => docInvProvider.dicWh[index].name),
                        constraints: BoxConstraints(maxHeight: 200),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(thickness: 1, height: 1),
                                SizedBox(height: 10),
                                Text(item),
                                SizedBox(height: 10),
                                Divider(thickness: 1, height: 1),
                              ],
                            ),
                            selected: isSelected,
                          );
                        },
                        onChange: (newValue) {
                          setState(() {
                            docInvProvider.whName.text = newValue;
                            docInvProvider.whId = docInvProvider.dicWh.firstWhere((element) => element.name == docInvProvider.whName.text).id;
                          });
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: docInvProvider.whName,
                        decoration: InputDecoration(
                          labelText: 'Склад',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          focusedBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          enabledBorder:
                              const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                          errorStyle: const TextStyle(fontSize: 12, height: 0.8),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Складни танланг';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              SelectDialog.showModal<DicContra>(
                context,
                items: docInvProvider.dicContra,
                showSearchBox: true,
                searchBoxDecoration: InputDecoration(
                  labelText: 'Search',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                ),
                onFind: (String filter) async {
                  return docInvProvider.dicContra.where((item) {
                    return item.name.toLowerCase().contains(filter.toLowerCase()) ||
                        item.address.toLowerCase().contains(filter.toLowerCase()) ||
                        item.phone.toLowerCase().contains(filter.toLowerCase()) ||
                        item.contractNum.toLowerCase().contains(filter.toLowerCase());
                  }).toList();
                },
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name),
                        SizedBox(height: 5),
                        Text(
                          item.phone.trim(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Divider(thickness: 1, height: 1),
                      ],
                    ),
                    selected: isSelected,
                  );
                },
                onChange: (newValue) {
                  setState(() {
                    docInvProvider.contraId = newValue.id;
                    docInvProvider.contraName.text = newValue.name;
                  });
                },
              );
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: docInvProvider.contraName,
                decoration: InputDecoration(
                  labelText: 'Мижоз',
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                  errorStyle: TextStyle(fontSize: 12, height: 0.8),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Мижозни танланг';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: docInvProvider.price,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Сумма",
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
              errorStyle: const TextStyle(fontSize: 12, height: 0.8),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: docInvProvider.notes,
            decoration: InputDecoration(
              labelText: "Примечание",
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
              errorStyle: const TextStyle(fontSize: 12, height: 0.8),
            ),
          )
        ],
      ),
    );
  }

  Widget getProducts(MySettings settings, DocInvProvider docInvProvider) {
    return docInvProvider.index == 0 ? getDicCat(settings, docInvProvider) : getDicProd(settings, docInvProvider);
  }

  getInvProducts(MySettings settings, DocInvProvider docInvProvider) {
    return ListView.builder(
      itemCount: docInvProvider.invList.length,
      itemBuilder: (context, index) {
        final item = docInvProvider.invList[index];
        return Slidable(
          key: ValueKey(item.id),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  docInvProvider.invList.remove(item);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditInvList(docInvList: item)));
            },
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: index.isEven ? Colors.grey.shade200 : Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey, width: .8)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.prodName, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${Utils.myNumFormat2(item.qty)} x ${Utils.myNumFormat2(item.price)}",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14)),
                        Text(Utils.myNumFormat2(item.summ), style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getDicCat(MySettings settings, DocInvProvider docInvProvider) {
    return ListView.builder(
      itemCount: docInvProvider.filteredDicCat.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            docInvProvider.dicCatId = docInvProvider.filteredDicCat[index].id;
            await docInvProvider.getAllProducts(settings, context);
            docInvProvider.isSearching = false;
            docInvProvider.index = 1;
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: index.isEven ? Colors.grey.shade200 : Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey, width: .8)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(docInvProvider.filteredDicCat[index].name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15)),
            ),
          ),
        );
      },
    );
  }

  getDicProd(MySettings settings, DocInvProvider docInvProvider) {
    return ListView.builder(
      itemCount: docInvProvider.filteredDicProd.length,
      itemBuilder: (context, index) {
        String catName = docInvProvider.dicCat.singleWhere((element) => element.id == docInvProvider.filteredDicProd[index].catId).name;
        return InkWell(
          onTap: () {
            docInvProvider.searchQuery = "";
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditInvList(dicProd: docInvProvider.filteredDicProd[index])));
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: docInvProvider.invList.any((element) => element.prodName == docInvProvider.filteredDicProd[index].name)
                  ? Colors.orange.shade200
                  : (index.isEven ? Colors.grey.shade200 : Colors.white),
              border: Border(bottom: BorderSide(color: Colors.grey, width: .8)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(docInvProvider.filteredDicProd[index].name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text("Код: ${docInvProvider.filteredDicProd[index].id}", style: Theme.of(context).textTheme.bodySmall!.copyWith()),
                      SizedBox(width: 20),
                      Text(
                          "Формат: ${Utils.myNumFormat0(docInvProvider.filteredDicProd[index].coeff)} ${docInvProvider.filteredDicProd[index].unit1}",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith()),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text("Группа: $catName", style: Theme.of(context).textTheme.bodySmall!.copyWith()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getNavBar(MySettings settings) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Данные"),
        BottomNavigationBarItem(icon: Icon(Icons.playlist_add, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Товары"),
        BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Список"),
      ],
      onTap: (value) {
        setState(() {
          tabIndex = value;
        });
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
}
