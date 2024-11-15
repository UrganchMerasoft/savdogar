import 'package:flutter/material.dart';
import 'package:flutter_savdogar/model/doc/doc_cash.dart';

class DocCashEditPage extends StatefulWidget {
  final DocCash docCash;

  const DocCashEditPage({super.key, required this.docCash});

  @override
  State<DocCashEditPage> createState() => _DocCashEditPageState();
}

class _DocCashEditPageState extends State<DocCashEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: Column(
        children: [
          Text(widget.docCash.contraName),
          Text(widget.docCash.curdate),
          Text(widget.docCash.notes),
        ],
      ),
    );
  }
}
