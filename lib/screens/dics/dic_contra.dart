import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

class DicContraPage extends StatefulWidget {
  const DicContraPage({super.key});

  @override
  State<DicContraPage> createState() => _DicContraPageState();
}

class _DicContraPageState extends State<DicContraPage> {
  List<DicContra> dicContra = [];
  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      getAllContra(settings);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Клиентская база")),
      body: const Center(child: Text("Klientlar royhati")),
    );
  }

  void getAllContra(MySettings settings) async {
    var data = await MyHttpService.GET(context, " ${settings.serverUrl}/dic_contra/get", "", settings);
    print(data);
  }
}
