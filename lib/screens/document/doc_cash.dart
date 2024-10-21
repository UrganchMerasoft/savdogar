import 'package:flutter/material.dart';

class DocCashPage extends StatefulWidget {
  const DocCashPage({super.key});

  @override
  State<DocCashPage> createState() => _DocCashPageState();
}

class _DocCashPageState extends State<DocCashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {}
}
