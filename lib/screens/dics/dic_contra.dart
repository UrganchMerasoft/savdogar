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

class DicContraPage extends StatefulWidget {
  const DicContraPage({super.key});

  @override
  State<DicContraPage> createState() => _DicContraPageState();
}

class _DicContraPageState extends State<DicContraPage> {
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

  List<DicContra> dicContra = [];
  List<DicContra> filteredList = [];

  bool isSearching = false;
  String searchQuery = '';
  bool isLoading = false;
  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllContra(settings);
    }
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text("Клиентская база")
            : TextField(
                autofocus: true,
                onChanged: (value) async {
                  searchQuery = value;
                  await searchDicContra(settings, value);
                },
                cursorColor: Colors.white,
                decoration: InputDecoration(hintText: 'Qidiruv...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            onPressed: () {
              getFilteredButton(settings);
            },
            icon: const Icon(Icons.filter_alt),
          ),
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              isSearching = !isSearching;
              setState(() {});
              if (isSearching == false) {
                searchQuery = "";
                searchDicContra(settings, searchQuery);
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
                isSearching = false;
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const DicContraEditPage(typeId: 1, appBarText: "Добавить новый клиент")));
                await getAllContra(settings);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  getBody(MySettings settings) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredList.isEmpty
            ? const Center(child: Text("No data available"))
            : RefreshIndicator(
                onRefresh: () async {
                  await getAllContra(settings);
                  await searchDicContra(settings, searchQuery);
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
                              await deleteContra(settings, filteredList[index].id);
                              await getAllContra(settings);
                              await searchDicContra(settings, searchQuery);
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
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DicContraEditPage(dicContra: filteredList[index], typeId: 1, appBarText: "Редактировать клиента")));
                          await getAllContra(settings);
                          await searchDicContra(settings, searchQuery);
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

  Future<void> getAllContra(MySettings settings) async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
      var data = jsonDecode(res);
      dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
      filteredList = dicContra;
      await filteredDicContra(settings);
      debugPrint(res);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteContra(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/dic_contra/delete/$id", settings);
    debugPrint(res);
    if (res == "400") {
      MyHttpService.showToast(context, "Ushbu mijozni o'chira olmaysiz", "Bu mijoz bilan harakat mavjud", ToastificationType.warning);
    }
    settings.saveAndNotify();
  }

  Future<void> searchDicContra(MySettings settings, String search) async {
    if (search.isEmpty) {
      filteredList = dicContra;
    } else {
      filteredList = dicContra.where((value) {
        return value.name.toLowerCase().contains(search.toLowerCase()) ||
            value.notes.toLowerCase().contains(search.toLowerCase()) ||
            value.id.toString().contains(search.toLowerCase()) ||
            value.address.toString().toLowerCase().contains(search.toLowerCase()) ||
            value.phone.contains(search.toLowerCase());
      }).toList();
    }
    settings.saveAndNotify();
  }

  Future<void> filteredDicContra(MySettings settings) async {
    switch (settings.contraFilter) {
      case 'alphabet':
        filteredList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'reverseAlphabet':
        filteredList.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case 'new':
        filteredList.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'old':
        filteredList.sort((a, b) => a.id.compareTo(b.id));
        break;
      default:
        settings.contraFilter = "old";
        break;
    }
    settings.saveAndNotify();
  }

  getFilteredButton(MySettings settings) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text('Сортировать', style: Theme.of(context).textTheme.titleLarge),
              content: Column(children: [
                getRadioButton('Алфавиту (A-B)', settings.contraFilter, 'alphabet', (value) => setState(() => settings.contraFilter = value!)),
                getRadioButton('Алфавиту (B-A)', settings.contraFilter, 'reverseAlphabet', (value) => setState(() => settings.contraFilter = value!)),
                getRadioButton('Новый', settings.contraFilter, 'new', (value) => setState(() => settings.contraFilter = value!)),
                getRadioButton('По умолчание', settings.contraFilter, 'old', (value) => setState(() => settings.contraFilter = value!)),
              ]),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            await filteredDicContra(settings);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text('Применить', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
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

  Widget getRadioButton(String text, String? groupValue, String value, ValueChanged<String?> onChanged) {
    return RadioListTile<String>(
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
