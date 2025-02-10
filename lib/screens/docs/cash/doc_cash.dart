import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/doc/doc_cash.dart';
import 'package:flutter_savdogar/model/doc/doc_cash_info.dart';
import 'package:flutter_savdogar/screens/docs/cash/doc_cash_edit.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class DocCashPage extends StatefulWidget {
  const DocCashPage({super.key});

  @override
  State<DocCashPage> createState() => _DocCashPageState();
}

class _DocCashPageState extends State<DocCashPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
    date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
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

  List<DocCash> docCash = [];
  List<DocCash> filteredList = [];

  bool isLoading = false;
  List<DocCashInfo> info = [];
  bool first = true;
  int tabIndex = 0;
  String searchQuery = '';
  bool isSearching = false;
  DateTime sentDate = DateTime.now();
  int rate = 0;
  TextEditingController date1 = TextEditingController();
  TextEditingController date2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllData(settings);
      getInfoData(settings);
    }
    return Scaffold(
      appBar: myAppBar(settings),
      body: tabIndex == 3 ? getFilterPage(settings) : getBody(settings),
      bottomNavigationBar: getNavBar(settings),
      floatingActionButton: _isFabVisible && tabIndex != 3
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(tabIndex: tabIndex)));
                await getAllData(settings);
                await getInfoData(settings);
              },
              backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(180),
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
                getAllData(settings);
                setState(() {});
              },
              child: Text(date2.text, style: TextStyle(color: Colors.white, fontSize: 20)),
            )
          : TextField(
              autofocus: true,
              onChanged: (value) async {
                searchQuery = value;
                searchDocCash(settings);
              },
              decoration: InputDecoration(hintText: 'Qidiruv...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white54)),
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
            ),
      actions: [
        Visibility(
          visible: tabIndex != 3,
          child: IconButton(
            onPressed: () async {
              await getAllData(settings);
              await getInfoData(settings);
            },
            icon: Icon(Icons.refresh),
          ),
        ),
        Visibility(
          visible: tabIndex != 3,
          child: IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
              if (!isSearching) {
                searchQuery = "";
                searchDocCash(settings);
              }
            },
          ),
        ),
        Visibility(
          visible: tabIndex == 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                settings.selectedDocCash = "default";
                settings.statusDocCash = "all";
                sentDate = DateTime.now();
                date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, sentDate.toString());
                settings.saveAndNotify();
              },
              icon: Icon(Icons.cleaning_services_rounded),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBody(MySettings settings) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 1)),
                ),
                child: info.length > 1
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIconText("assets/icons/money.png", Utils.myNumFormat2(info[1].ost)),
                              const SizedBox(width: 15),
                              _buildIconText("assets/icons/dollar.png", Utils.myNumFormat2(info[1].ostCur), width: 30, height: 20),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIconText("assets/icons/card.png", Utils.myNumFormat2(info[1].ostPla), width: 30, height: 25),
                              const SizedBox(width: 15),
                              Text("Курс: $rate", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      )
                    : const Center(child: Text("No data available")), // Handle empty info list
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getAllData(settings);
                    await getInfoData(settings);
                  },
                  child: filteredList.isEmpty
                      ? const Center(child: Text("No data available"))
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            if (item.typeId == tabIndex + 1) {
                              return buildDocCashItem(context, item, _getItemColor(item.typeId), settings);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                ),
              ),
            ],
          );
  }

  getNavBar(MySettings settings) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.arrow_downward, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Приход"),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_upward, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Расход"),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Затрата"),
        BottomNavigationBarItem(icon: Icon(Icons.filter_alt_sharp, color: tabIndex == 3 ? Colors.white : Colors.white30), label: "Фильтр"),
      ],
      onTap: (value) async {
        tabIndex = value;
        if (!_isFabVisible) {
          _isFabVisible = true;
        }
        await filteredDocCash(settings);
        await getAllData(settings);
        searchDocCash(settings);
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

  Widget _buildIconText(String asset, String text, {double width = 25, double height = 25}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(asset, width: width, height: height),
        const SizedBox(width: 5),
        Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getItemColor(int typeId) {
    switch (typeId) {
      case 1:
        return Colors.green.shade600;
      case 2:
        return Colors.indigo;
      case 3:
        return Colors.red.shade800;
      default:
        return Colors.grey;
    }
  }

  Widget buildDocCashItem(BuildContext context, DocCash docCash, Color textColor, MySettings settings) {
    return Slidable(
      key: ValueKey(docCash.id),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await deleteDocCash(settings, docCash.id);
              await getAllData(settings);
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
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(docCash: docCash, tabIndex: tabIndex)));
          await getAllData(settings);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 15),
                Expanded(child: Text(docCash.contraName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18))),
                Text(
                  docCash.isCur == 0 ? Utils.myNumFormat0(docCash.summ) : "${Utils.myNumFormat0(docCash.summReal)}\$",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                ),
                SizedBox(width: 15),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                        "${Utils.myNumFormat0(docCash.summ)} + P = ${Utils.myNumFormat0(docCash.summPla)} + \$${Utils.myNumFormat0(docCash.summCur)}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      Utils.myDateFormatFromStr1(Utils.formatDDMMYYYYHHMM, docCash.curdate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(docCash.notes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Курс: ${Utils.myNumFormat0(docCash.curRate)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }

  Future<void> getAllData(MySettings settings) async {
    setState(() {
      isLoading = true;
    });
    String body = jsonEncode({
      "date1": Utils.convertDateToIso(date1.text),
      "date2": Utils.convertDateToIso(date2.text),
      "wh_id": 0,
      "type_id": tabIndex+1,
    });
    // debugPrint(body);
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/get", body, settings);
    var data = jsonDecode(res);
    docCash = (data["list"] as List).map((e) => DocCash.fromMapObject(e)).toList();
    filteredList = docCash;
    filteredDocCash(settings);
    isLoading = false;
    settings.saveAndNotify();
  }

  Future<void> getInfoData(MySettings settings) async {
    String body = jsonEncode({
      "date1": Utils.convertDateToIso(date1.text),
      "date2": Utils.convertDateToIso(date2.text),
      "wh_id": 0,
      "type_id": 0,
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/doc_cash/sidebar", body, settings);
    var data = jsonDecode(res);
    rate = data['rate'];
    info = (data["info"] as List).map((e) => DocCashInfo.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  // getFilteredButton(MySettings settings) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             scrollable: true,
  //             title: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 SizedBox(
  //                   height: 50,
  //                   child: TextField(
  //                     controller: date1,
  //                     decoration: InputDecoration(
  //                       labelText: 'Период с',
  //                       hintText: 'MM.DD.YYYY',
  //                       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
  //                       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
  //                       suffixIcon: IconButton(
  //                         onPressed: () async {
  //                           startDate = (await Utils.myDatePicker(context, startDate))!;
  //                           date1.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, startDate.toString());
  //                         },
  //                         icon: Icon(Icons.calendar_month),
  //                       ),
  //                     ),
  //                     keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
  //                     inputFormatters: [DateTextFormatter()],
  //                   ),
  //                 ),
  //                 SizedBox(height: 20),
  //                 SizedBox(
  //                   height: 50,
  //                   child: TextField(
  //                     controller: date2,
  //                     decoration: InputDecoration(
  //                       labelText: 'по',
  //                       hintText: 'MM.DD.YYYY',
  //                       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
  //                       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
  //                       suffixIcon: IconButton(
  //                         onPressed: () async {
  //                           startDate = (await Utils.myDatePicker(context, startDate))!;
  //                           date2.text = Utils.myDateFormatFromStr1(Utils.formatDDMMYYYY, startDate.toString());
  //                         },
  //                         icon: Icon(Icons.calendar_month),
  //                       ),
  //                     ),
  //                     keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
  //                     inputFormatters: [DateTextFormatter()],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: Column(
  //               children: [
  //                 Text('Сортировать', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
  //                 getRadioButton('По умолчание', settings.selectedSort, 'default', (value) => setState(() => settings.selectedSort = value!)),
  //                 getRadioButton('Алфавиту', settings.selectedSort, 'alphabet', (value) => setState(() => settings.selectedSort = value!)),
  //                 getRadioButton('Сумма', settings.selectedSort, 'sum', (value) => setState(() => settings.selectedSort = value!)),
  //                 const Divider(),
  //                 const SizedBox(height: 10),
  //                 Text('Статус', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
  //                 getRadioButton('Все документы', settings.selectedStatus, 'all', (value) => setState(() => settings.selectedStatus = value!)),
  //                 getRadioButton('Принятые', settings.selectedStatus, 'accepted', (value) => setState(() => settings.selectedStatus = value!)),
  //                 getRadioButton('Новый', settings.selectedStatus, 'new', (value) => setState(() => settings.selectedStatus = value!)),
  //                 const SizedBox(height: 16),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     Navigator.pop(context);
  //                     await filteredDocCash(settings);
  //                     await getAllData(settings);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     minimumSize: const Size(double.infinity, 48),
  //                     backgroundColor: Colors.green,
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                     child: Text('Применить', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  getFilterPage(MySettings settings) {
    return SingleChildScrollView(
      child: Column(
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
          getRadioButton('По умолчание', settings.selectedDocCash, 'default', (value) => setState(() => settings.selectedDocCash = value!)),
          getRadioButton('Алфавиту', settings.selectedDocCash, 'alphabet', (value) => setState(() => settings.selectedDocCash = value!)),
          getRadioButton('Сумма', settings.selectedDocCash, 'sum', (value) => setState(() => settings.selectedDocCash = value!)),
          const Divider(),
          const SizedBox(height: 10),
          Text('Статус', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey, fontSize: 16)),
          getRadioButton('Все документы', settings.statusDocCash, 'all', (value) => setState(() => settings.statusDocCash = value!)),
          getRadioButton('Принятые', settings.statusDocCash, 'accepted', (value) => setState(() => settings.statusDocCash = value!)),
          getRadioButton('Новый', settings.statusDocCash, 'new', (value) => setState(() => settings.statusDocCash = value!)),
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
      ),
    );
  }

  Future<void> filteredDocCash(MySettings settings) async {
    switch (settings.selectedDocCash) {
      case 'default':
        filteredList.sort((a, b) => a.id.compareTo(b.id));
        break;
      case 'alphabet':
        filteredList.sort((a, b) => a.contraName.toLowerCase().compareTo(b.contraName.toLowerCase()));
        break;
      case 'sum':
        filteredList.sort((a, b) => b.summ.compareTo(a.summ));
        break;
      default:
        settings.selectedDocCash = "default";
        settings.statusDocCash = "all";
        break;
    }

    if (settings.statusDocCash == "accepted") {
      filteredList = filteredList.where((element) => element.isAccepted == 1).toList();
    } else if (settings.statusDocCash == "new") {
      filteredList = filteredList.where((element) => element.isAccepted == 0).toList();
    }
    settings.saveAndNotify();
  }

  void searchDocCash(MySettings settings) {
    List<String> ss = searchQuery.split(" ");

    if (searchQuery.isEmpty) {
      filteredList = docCash;
    } else {
      filteredList = docCash.where((doc) {
        if (ss.length <= 1) {
          return doc.contraName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.notes.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doc.contraId.toString().contains(searchQuery.toLowerCase()) ||
              doc.id.toString().contains(searchQuery.toLowerCase());
        } else {
          return doc.contraName.toString().toLowerCase().contains(ss[0].trim()) && doc.contraName.toString().toLowerCase().contains(ss[1].trim());
        }
      }).toList();
    }
    settings.saveAndNotify();
  }

  Future<void> deleteDocCash(MySettings settings, int id) async {
    var res = await MyHttpService.DELETE(context, "${settings.serverUrl}/doc_cash/delete/$id", settings);
    debugPrint(res);
    settings.saveAndNotify();
    if (res == "400") {
      MyHttpService.showToast(context, "Ushbu mijozni o'chira olmaysiz", "Bu mijoz bilan harakat mavjud", ToastificationType.warning);
    }
  }

  Widget getRadioButton(String text, String? groupValue, String value, ValueChanged<String?> onChanged) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      visualDensity: VisualDensity.compact,
    );
  }
}
