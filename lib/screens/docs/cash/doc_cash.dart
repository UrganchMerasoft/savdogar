import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/doc/doc_cash.dart';
import 'package:flutter_savdogar/model/doc/doc_cash_info.dart';
import 'package:flutter_savdogar/screens/docs/cash/doc_cash_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DocCashPage extends StatefulWidget {
  const DocCashPage({super.key});

  @override
  State<DocCashPage> createState() => _DocCashPageState();
}

class _DocCashPageState extends State<DocCashPage> {
  List<DocCash> docCash = [];
  List<DocCash> filteredDocCash = [];
  List<DocCashInfo> info = [];
  bool first = true;
  int tabIndex = 0;
  String searchQuery = '';
  bool isSearching = false;
  DateTime startDate = DateTime(2023, 01, 01);
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getDocCashData(settings);
    }
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text("Кассовые документы")
            : TextField(
                autofocus: true,
                onChanged: (value) async {
                  searchQuery = value;
                  filterDocCashList(settings);
                  await getDocCashData(settings);
                },
                decoration: InputDecoration(hintText: 'Qidiruv...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white54)),
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          IconButton(
            onPressed: () async {
              await myDatePicker(context, settings);
              await getDocCashData(settings);
            },
            icon: Icon(Icons.filter_alt_sharp),
          ),
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchQuery = '';
                  filteredDocCash = docCash;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: getBody(settings),
      bottomNavigationBar: getNavBar(settings),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(tabIndex: tabIndex)));
          await getDocCashData(settings);
        },
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBody(MySettings settings) {
    List<DocCash> displayList = searchQuery.isEmpty ? docCash : filteredDocCash;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: displayList.length,
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (displayList[index].typeId == 1 && tabIndex == 0) buildDocCashItem(context, displayList[index], Colors.green.shade600, settings),
            if (displayList[index].typeId == 2 && tabIndex == 1) buildDocCashItem(context, displayList[index], Colors.indigo, settings),
            if (displayList[index].typeId == 3 && tabIndex == 2) buildDocCashItem(context, displayList[index], Colors.red.shade800, settings),
          ],
        );
      },
    );
  }

  Widget buildDocCashItem(BuildContext context, DocCash docCash, Color textColor, MySettings settings) {
    return Slidable(
      key: ValueKey(docCash.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await deleteDocCash(settings, docCash.id);
              await getDocCashData(settings);
              setState(() {});
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(docCash: docCash, tabIndex: tabIndex)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text(docCash.contraName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500))),
                Text(
                  Utils.myNumFormat0(docCash.summ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(docCash.notes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14)),
            SizedBox(height: 10),
            Divider(height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }

  getNavBar(MySettings settings) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.arrow_downward, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Приходы"),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_upward, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Расходы"),
        BottomNavigationBarItem(icon: Icon(Icons.subdirectory_arrow_left, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Затрата"),
      ],
      onTap: (value) {
        tabIndex = value;
        setState(() {});
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

  Future<void> getDocCashData(MySettings settings) async {
    String body = jsonEncode({
      "date1": Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd, startDate.toString()),
      "date2": Utils.myDateFormatFromStr1(Utils.formatYYYYMMdd, endDate.toString()),
      "wh_id": 0,
      "type_id": 0,
    });
    print(body);
    var res = await MyHttpService.GET1(context, "${settings.serverUrl}/doc_cash/get", body, settings);
    var data = jsonDecode(res);
    docCash = (data["list"] as List).map((e) => DocCash.fromMapObject(e)).toList();
    info = (data["info"] as List).map((e) => DocCashInfo.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  Future<void> myDatePicker(BuildContext context, MySettings settings) async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Theme.of(context).primaryColor,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      controlsTextStyle: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      dayBuilder: ({required date, textStyle, decoration, isSelected, isDisabled, isToday}) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(MaterialLocalizations.of(context).formatDecimal(date.day), style: textStyle),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: isSelected == true ? Colors.red : Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({required year, decoration, isCurrentYear, isDisabled, isSelected, textStyle}) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(year.toString(), style: textStyle),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      firstDate: null,
      lastDate: DateTime.now(),
    );

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 370),
      borderRadius: BorderRadius.circular(15),
      value: [startDate, endDate],
      dialogBackgroundColor: Colors.white,
    );
    print(result);
    print(startDate);
    print(endDate);
  }

  void filterDocCashList(MySettings settings) {
    if (searchQuery.isEmpty) {
      filteredDocCash = docCash;
    } else {
      filteredDocCash = docCash.where((doc) {
        return doc.contraName.toLowerCase().contains(searchQuery.toLowerCase()) || doc.notes.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    settings.saveAndNotify();
  }

  Future<void> deleteDocCash(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/doc_cash/delete/$id", settings);
    print(res);
    settings.saveAndNotify();
  }
}
