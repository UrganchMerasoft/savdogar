import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/model/reports/sverka.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:flutter_savdogar/share/utils.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';

class ViewSverka extends StatefulWidget {
  const ViewSverka({super.key});

  @override
  State<ViewSverka> createState() => _ViewSverkaState();
}

class _ViewSverkaState extends State<ViewSverka> {
  List<Info> info = [];
  List<ListElement> list = [];
  List<Product> product = [];
  List<DicContra> dicContra = [];

  int contraId = 1;
  TextEditingController contraName = TextEditingController();

  bool isLoading = true;

  DateTime sentDate = DateTime.now();
  TextEditingController date1 = TextEditingController();
  TextEditingController date2 = TextEditingController();

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
      getAllContra(settings);
      getOstData(settings);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Акт сверка"),
        actions: [
          IconButton(onPressed: () => showFilterDialog(context, settings), icon: Icon(Icons.filter_alt_sharp)),
        ],
      ),
      body: getBody(settings),
    );
  }

  Widget getBody(MySettings settings) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: info.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info[index].typName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    info[index].summ.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              Widget chatBubble({required bool isLeft}) {
                return Padding(
                  padding: isLeft ? const EdgeInsets.only(right: 25, bottom: 15) : const EdgeInsets.only(left: 80, bottom: 15),
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: isLeft ? MyChatBubbleLeft() : MyChatBubbleRight(),
                        size: const Size(280, 125),
                      ),
                      Padding(
                        padding: isLeft ? const EdgeInsets.only(left: 35, top: 10, right: 75) : const EdgeInsets.only(left: 10, right: 35, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isLeft
                                    ? Text(
                                        "Оплата",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "Заказ: №${item.id}",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                Text(
                                  item.summ.toString(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text("Примечание: ${item.notesCash}", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
                            const SizedBox(height: 5),
                            Text("Пользователь: ${item.userName}", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
                            const SizedBox(height: 5),
                            Text(item.curtime, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (item.docCashId != 0) {
                return chatBubble(isLeft: true);
              } else if (item.docInvId != 0) {
                return chatBubble(isLeft: false);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Future<void> getAllContra(MySettings settings) async {
    var res = await MyHttpService.GET(context, "${settings.serverUrl}/dic_contra/get/99", settings);
    var data = jsonDecode(res);
    dicContra = (data as List).map((e) => DicContra.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }

  void showFilterDialog(BuildContext context, MySettings settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Фильтр'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
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
                    SizedBox(height: 10),
                    SizedBox(
                      height: 50,
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
                    GestureDetector(
                      onTap: () {
                        SelectDialog.showModal<DicContra>(
                          context,
                          items: dicContra,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            labelText: 'Search',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            focusedBorder:
                                const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                            enabledBorder:
                                const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                          ),
                          onFind: (String filter) async {
                            return dicContra.where((item) {
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
                              contraId = newValue.id;
                              contraName.text = newValue.name;
                            });
                          },
                        );
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: contraName,
                          decoration: InputDecoration(
                            labelText: 'Мижоз',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            focusedBorder:
                                const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
                            enabledBorder:
                                const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(width: 0.2)),
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
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрыть')),
            ElevatedButton(
              onPressed: () async {
                await getOstData(settings);
                Navigator.pop(context);
              },
              child: Text('Применить'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getOstData(MySettings settings) async {
    setState(() {
      isLoading = true;
    });
    String body = jsonEncode({
      "contra_id": contraId,
      "date1": Utils.convertDateToIso(date1.text),
      "date2": Utils.convertDateToIso(date2.text),
    });
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_sverka", body, settings);
    var data = jsonDecode(res);
    info = (data["info"] as List).map((e) => Info.fromMapObject(e)).toList();
    list = (data["list"] as List).map((e) => ListElement.fromMapObject(e)).toList();
    product = (data["products"] as List).map((e) => Product.fromMapObject(e)).toList();
    isLoading = false;
    settings.saveAndNotify();
    debugPrint(res);
  }
}

class MyChatBubbleLeft extends CustomPainter {
  MyChatBubbleLeft();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1173225, 0);
    path_0.cubicTo(size.width * 0.1173225, 0, size.width * 0.03812250, 0, size.width * 0.01794193, 0);
    path_0.cubicTo(
        size.width * -0.002232279, 0, size.width * -0.006896821, size.height * 0.05335381, size.width * 0.01173543, size.height * 0.1067079);
    path_0.cubicTo(size.width * 0.03036768, size.height * 0.1600619, size.width * 0.1104257, size.height * 0.3379083, size.width * 0.1173225,
        size.height * 0.3912619);
    path_0.cubicTo(size.width * 0.1242129, size.height * 0.4446155, size.width * 0.1173225, 0, size.width * 0.1173225, 0);
    path_0.close();

    Paint paint0 = Paint()..style = PaintingStyle.fill;
    paint0.color = Colors.green.shade100;
    canvas.drawPath(path_0, paint0);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1721225, size.height * 1.000002);
    path_1.cubicTo(size.width * 0.1397871, size.height * 1.000002, size.width * 0.09451607, size.height * 0.9238131, size.width * 0.09451607,
        size.height * 0.7333345);
    path_1.lineTo(size.width * 0.1721225, size.height * 0.7333345);
    path_1.lineTo(size.width * 0.1721225, size.height * 1.000002);
    path_1.close();

    Paint paint1 = Paint()..style = PaintingStyle.fill;
    paint1.color = Colors.green.shade100;
    canvas.drawPath(path_1, paint1);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1721225, 0);
    path_2.lineTo(size.width * 0.09451607, 0);
    path_2.lineTo(size.width * 0.09451607, size.height * 0.7333345);
    path_2.lineTo(size.width * 0.1721225, size.height * 0.7333345);
    path_2.lineTo(size.width * 0.1721225, 0);
    path_2.close();

    Paint paint2 = Paint()..style = PaintingStyle.fill;
    paint2.color = Colors.green.shade100;
    canvas.drawPath(path_2, paint2);

    Path path_3 = Path();
    path_3.moveTo(size.width, size.height * 0.1200000);
    path_3.cubicTo(size.width, size.height * 0.05372583, size.width * 0.9826679, 0, size.width * 0.9612893, 0);
    path_3.lineTo(size.width * 0.1677418, 0);
    path_3.lineTo(size.width * 0.1677418, size.height);
    path_3.lineTo(size.width * 0.9612893, size.height);
    path_3.cubicTo(size.width * 0.9826679, size.height, size.width, size.height * 0.9462738, size.width, size.height * 0.8800000);
    path_3.lineTo(size.width, size.height * 0.1200000);
    path_3.close();

    Paint paint3 = Paint()..style = PaintingStyle.fill;
    paint3.color = Colors.green.shade100;
    canvas.drawPath(path_3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyChatBubbleRight extends CustomPainter {
  MyChatBubbleRight();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.8826786, 0);
    path_0.cubicTo(size.width * 0.8826786, 0, size.width * 0.9618786, 0, size.width * 0.9820571, 0);
    path_0.cubicTo(size.width * 1.002232, 0, size.width * 1.006896, size.height * 0.05335378, size.width * 0.9882643, size.height * 0.1067078);
    path_0.cubicTo(size.width * 0.9696321, size.height * 0.1600611, size.width * 0.8895750, size.height * 0.3379078, size.width * 0.8826786,
        size.height * 0.3912622);
    path_0.cubicTo(size.width * 0.8757857, size.height * 0.4446156, size.width * 0.8826786, 0, size.width * 0.8826786, 0);
    path_0.close();

    Paint paint0 = Paint()..style = PaintingStyle.fill;
    paint0.color = Color(0xffFFC5C5).withOpacity(1.0);
    paint0.color = Colors.red.shade100.withOpacity(1.0);
    canvas.drawPath(path_0, paint0);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8278786, size.height * 1.000001);
    path_1.cubicTo(size.width * 0.8602143, size.height * 1.000001, size.width * 0.9054821, size.height * 0.9238111, size.width * 0.9054821,
        size.height * 0.7333333);
    path_1.lineTo(size.width * 0.8278786, size.height * 0.7333333);
    path_1.lineTo(size.width * 0.8278786, size.height * 1.000001);
    path_1.close();

    Paint paint1 = Paint()..style = PaintingStyle.fill;
    paint1.color = Color(0xffFFC5C5).withOpacity(1.0);
    paint1.color = Colors.red.shade100.withOpacity(1.0);
    canvas.drawPath(path_1, paint1);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.8278786, 0);
    path_2.lineTo(size.width * 0.9054821, 0);
    path_2.lineTo(size.width * 0.9054821, size.height * 0.7333344);
    path_2.lineTo(size.width * 0.8278786, size.height * 0.7333344);
    path_2.lineTo(size.width * 0.8278786, 0);
    path_2.close();

    Paint paint2 = Paint()..style = PaintingStyle.fill;
    paint2.color = Color(0xffFFC5C5).withOpacity(1.0);
    paint2.color = Colors.red.shade100.withOpacity(1.0);
    canvas.drawPath(path_2, paint2);

    Path path_3 = Path();
    path_3.moveTo(0, size.height * 0.1200000);
    path_3.cubicTo(0, size.height * 0.05372578, size.width * 0.01733089, 0, size.width * 0.03870964, 0);
    path_3.lineTo(size.width * 0.8322571, 0);
    path_3.lineTo(size.width * 0.8322571, size.height);
    path_3.lineTo(size.width * 0.03870964, size.height);
    path_3.cubicTo(size.width * 0.01733089, size.height, 0, size.height * 0.9462744, 0, size.height * 0.8800000);
    path_3.lineTo(0, size.height * 0.1200000);
    path_3.close();

    Paint paint3 = Paint()..style = PaintingStyle.fill;
    paint3.color = Color(0xffFFC5C5).withOpacity(1.0);
    paint3.color = Colors.red.shade100.withOpacity(1.0);
    canvas.drawPath(path_3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
