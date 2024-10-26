import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/dic/dic_prod.dart';

class DicProdEditPage extends StatefulWidget {
  final DicProd? dicProd;

  const DicProdEditPage({super.key, this.dicProd});

  @override
  State<DicProdEditPage> createState() => _DicProdEditPageState();
}

class _DicProdEditPageState extends State<DicProdEditPage> {
  @override
  void initState() {
    if (widget.dicProd != null) {

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
