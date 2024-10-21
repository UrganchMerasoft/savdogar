import 'package:flutter/material.dart';
import 'package:flutter_savdogar/screens/home/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
