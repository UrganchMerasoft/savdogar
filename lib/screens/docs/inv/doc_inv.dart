import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/doc/doc_inv.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';

import 'doc_inv_edit.dart';

class DocInvPage extends StatefulWidget {
  const DocInvPage({super.key});

  @override
  State<DocInvPage> createState() => _DocInvPageState();
}

class _DocInvPageState extends State<DocInvPage> {
  List<DocInv> invList = [];
  List<DocInv> filteredList = [];

  String searchQuery = '';
  bool isSearching = false;
  int tabIndex = 0;
  DateTime sentDate = DateTime.now();

  TextEditingController date1 = TextEditingController();
  TextEditingController date2 = TextEditingController();
  bool isLoading = false;

  bool first = true;

  @override
  void initState() {
    date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
    date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);
    if (first) {
      first = false;
      getDocInv(settings);
    }
    return Scaffold(
      appBar: myAppBar(settings),
      body: tabIndex == 4 ? getFilterPage(settings) : getBody(settings),
      bottomNavigationBar: getNavBar(settings),
      floatingActionButton: tabIndex != 4
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => DocInvEdit(typeId: tabIndex + 1)));
                await getDocInv(settings);
                settings.saveAndNotify();
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  myAppBar(MySettings settings) {
    return AppBar(
      title: !isSearching
          ? TextButton(
              onPressed: () async {
                sentDate = (await Utils.myDatePicker(context, sentDate))!;
                date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                getDocInv(settings);
                setState(() {});
              },
              child: Text(date1.text, style: TextStyle(color: Colors.white, fontSize: 20)),
            )
          : TextField(
              autofocus: true,
              onChanged: (value) async {
                searchQuery = value;
                await searchDocInv(settings);
              },
              decoration: InputDecoration(hintText: 'Qidiruv...', hintStyle: TextStyle(color: Colors.white54), border: InputBorder.none),
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
            ),
      actions: [
        Visibility(
          visible: tabIndex != 4,
          child: IconButton(
            onPressed: () async {
              await getDocInv(settings);
            },
            icon: const Icon(Icons.refresh),
          ),
        ),
        Visibility(
          visible: tabIndex != 4,
          child: IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
              if (!isSearching) {
                searchQuery = "";
                searchDocInv(settings);
              }
            },
          ),
        ),
        Visibility(
          visible: tabIndex == 4,
          child: IconButton(
            icon: Icon(Icons.cleaning_services),
            onPressed: () {
              settings.selectedDocInv = "default";
              settings.statusDocInv = "all";
              sentDate = DateTime.now();
              date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
              date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
              filteredDocInv(settings);
              settings.saveAndNotify();
            },
          ),
        ),
      ],
    );
  }

  getBody(MySettings settings) {
    return RefreshIndicator(
      onRefresh: () async {
        await getDocInv(settings);
      },
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredList.isEmpty
              ? const Center(child: Text("Ma'lumot topilmadi"))
              : ListView.builder(
                  itemCount: filteredList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    if (item.typeId == tabIndex + 1) {
                      return buildDocInvItem(item, settings);
                    }
                    return SizedBox.shrink();
                  },
                ),
    );
  }

  Widget buildDocInvItem(DocInv docInv, MySettings settings) {
    return InkWell(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => DocInvEdit(docInv: docInv, typeId: tabIndex + 1)));
        await getDocInv(settings);
        searchQuery = "";
        isSearching = false;
      },
      onLongPress: () async {
        bool? confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Tasdiqlash"),
            content: const Text("Ushbu hujjatni o‘chirishni xohlaysizmi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Yo‘q"),
              ),
              TextButton(
                onPressed: () async {
                  await deleteDocInv(docInv.id, settings);
                  await getDocInv(settings);
                  Navigator.pop(context);
                },
                child: const Text("Ha"),
              ),
            ],
          ),
        );

        if (confirmDelete == true) {
          print("o'chirildi");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: getBorderColor(tabIndex), width: 5)),
          color: getTabColor(tabIndex),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(docInv.contraName, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17))),
                Text(Utils.myNumFormat0(docInv.itogSumm), style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, docInv.curdate), style: Theme.of(context).textTheme.bodyMedium?.copyWith()),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5),
            Text("#${docInv.docNum}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13)),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Примечание: ${docInv.notes}".toLowerCase(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ),
                Icon(docInv.isPrinted != 1 ? Icons.done : Icons.done_all, color: docInv.isPrinted != 1 ? Colors.grey : Colors.green, size: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }

  getNavBar(MySettings settings) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.arrow_downward, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Приход"),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_upward, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Расход"),
        BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_left, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Возврат"),
        BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_right, color: tabIndex == 3 ? Colors.white : Colors.white30), label: "Брак"),
        BottomNavigationBarItem(icon: Icon(Icons.filter_alt_sharp, color: tabIndex == 4 ? Colors.white : Colors.white30), label: "Фильтр"),
      ],
      onTap: (value) async {
        tabIndex = value;
        await getDocInv(settings);
        searchDocInv(settings);
        settings.saveAndNotify();
        debugPrint("tabIndex: $tabIndex");
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

  Future<void> searchDocInv(MySettings settings) async {
    List<String> ss = searchQuery.split(" ");
    if (searchQuery.isEmpty) {
      filteredList = invList;
    } else {
      filteredList = invList.where((value) {
        if (ss.length <= 1) {
          return value.contraName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              value.notes.toLowerCase().contains(searchQuery.toLowerCase()) ||
              value.itogSumm.toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
              Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, value.curdate).contains(searchQuery.toLowerCase());
        } else {
          return value.contraName.toString().toLowerCase().contains(ss[0].trim()) && value.contraName.toString().toLowerCase().contains(ss[1].trim());
        }
      }).toList();
    }
    settings.saveAndNotify();
  }

  getFilterPage(MySettings settings) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          height: 50,
          child: TextField(
            controller: date1,
            decoration: InputDecoration(
              labelText: 'Период с',
              hintText: 'MM.DD.YYYY',
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
              suffixIcon: IconButton(
                onPressed: () async {
                  sentDate = (await Utils.myDatePicker(context, sentDate))!;
                  date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                },
                icon: Icon(Icons.calendar_month),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
            inputFormatters: [DateTextFormatter()],
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: TextField(
            controller: date2,
            decoration: InputDecoration(
              labelText: 'по',
              hintText: 'MM.DD.YYYY',
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
              suffixIcon: IconButton(
                onPressed: () async {
                  sentDate = (await Utils.myDatePicker(context, sentDate))!;
                  date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                },
                icon: Icon(Icons.calendar_month),
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
            inputFormatters: [DateTextFormatter()],
          ),
        ),
        SizedBox(height: 20),
        Text('Сортировать', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
        getRadioButton('По умолчание', settings.selectedDocInv, 'default', (value) => setState(() => settings.selectedDocInv = value!)),
        getRadioButton('Алфавиту', settings.selectedDocInv, 'alphabet', (value) => setState(() => settings.selectedDocInv = value!)),
        getRadioButton('Сумма', settings.selectedDocInv, 'sum', (value) => setState(() => settings.selectedDocInv = value!)),
        const Divider(),
        const SizedBox(height: 10),
        Text('Статус', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
        getRadioButton('Все документы', settings.statusDocInv, 'all', (value) => setState(() => settings.statusDocInv = value!)),
        getRadioButton('Принятые', settings.statusDocInv, 'accepted', (value) => setState(() => settings.statusDocInv = value!)),
        getRadioButton('Новый', settings.statusDocInv, 'new', (value) => setState(() => settings.statusDocInv = value!)),
        const SizedBox(height: 16),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     onPressed: () async {
        //
        //     },
        //     style: ElevatedButton.styleFrom(
        //       minimumSize: const Size(double.infinity, 48),
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //       child: Text('Cбросить', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<void> filteredDocInv(MySettings settings) async {
    switch (settings.selectedDocInv) {
      case 'default':
        filteredList.sort((a, b) => a.id.compareTo(b.id));
        break;
      case 'alphabet':
        filteredList.sort((a, b) => a.contraName.toLowerCase().compareTo(b.contraName.toLowerCase()));
        break;
      case 'sum':
        filteredList.sort((a, b) => b.itogSumm.compareTo(a.itogSumm));
        break;
      default:
        settings.selectedDocInv = "default";
        break;
    }

    if (settings.statusDocInv == "accepted") {
      filteredList = filteredList.where((element) => element.isAccepted == 1).toList();
    } else if (settings.statusDocInv == "new") {
      filteredList = filteredList.where((element) => element.isAccepted == 0).toList();
    }
    settings.saveAndNotify();
  }

  Widget getRadioButton(String text, String? groupValue, String value, ValueChanged<String?> onChanged) {
    return RadioListTile<String>(
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      visualDensity: VisualDensity.compact,
    );
  }

  Color getTabColor(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return Colors.green.withAlpha(50);
      case 1:
        return Colors.blue.withAlpha(50);
      case 2:
        return Colors.red.withAlpha(50);
      case 3:
        return Colors.orange.withAlpha(50);
      default:
        return Colors.transparent;
    }
  }

  Color getBorderColor(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return Colors.green.shade300;
      case 1:
        return Colors.blue.shade300;
      case 2:
        return Colors.red.shade300;
      case 3:
        return Colors.orange.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Future<void> deleteDocInv(int id, MySettings settings) async {
    String body = jsonEncode({});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_inv/delete/$id", body, settings);
    settings.saveAndNotify();
    debugPrint(res);
  }

  Future<void> getDocInv(MySettings settings) async {
    setState(() {
      isLoading = true;
    });
    String body = jsonEncode({
      "date1": Utils.convertDateToIso(date1.text),
      "date2": Utils.convertDateToIso(date2.text),
      "wh_id": 0,
      "type_id": tabIndex + 1,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_inv/get", body, settings);
    var data = jsonDecode(res);
    invList = (data as List).map((e) => DocInv.fromMapObject(e)).toList();
    filteredList = invList;
    await filteredDocInv(settings);
    isLoading = false;
    settings.saveAndNotify();
  }
}
