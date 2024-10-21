import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_contra.dart';
import 'package:flutter_savdogar/service/http_post.dart';
import 'package:provider/provider.dart';

class DicProdPage extends StatefulWidget {
  const DicProdPage({super.key});

  @override
  State<DicProdPage> createState() => _DicProdPageState();
}

class _DicProdPageState extends State<DicProdPage> {
  List<DicContra> dicContra = [];
  bool first=true;

  @override
  Widget build(BuildContext context) {
    MySettings settings=Provider.of<MySettings>(context);

    if(first){
      first=false;
      getAllContra(settings);
    }
    return Scaffold();
  }

  void getAllContra(MySettings settings) async{
  }
}
