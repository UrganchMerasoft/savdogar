import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/reports/ost.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class ViewOst extends StatefulWidget {
  const ViewOst({super.key});

  @override
  State<ViewOst> createState() => _ViewOstState();
}

class _ViewOstState extends State<ViewOst> {
  List<OstModel> ostData = [];
  bool isLoading = true;

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getOstData(settings);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Остаток товаров"),
        ),
        body: getBody(settings));
  }

  getBody(MySettings settings) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: ostData.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ostData[index].prodName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Text(ostData[index].catName, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 13,fontWeight: FontWeight.w300))),
                Text("${ostData[index].qty}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 5),
            Divider(),
          ],
        );
      },
    );
  }

  Future<void> getOstData(MySettings settings) async {
    try {
      setState(() {
        isLoading = true;
      });

      String body = jsonEncode({"date2": "2025-01-23", "wh_id": "0"});
      var res = await MyHttpService.POST(context, "${settings.serverUrl}/reports/view_ost", body, settings);

      var data = jsonDecode(res);
      setState(() {
        ostData = (data as List).map((e) => OstModel.fromMapObject(e)).toList();
        isLoading = false;
      });
      settings.saveAndNotify();
      print(res);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
