import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'screens/account/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    MySettings settings = Provider.of<MySettings>(context);
    if (settings.token != "") {
      return const HomePage();
    }
    return LoginPage();
  }
}
