import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/additional.dart';
import 'package:flutter_savdogar/screens/profile/settings/front.dart';
import 'package:flutter_savdogar/screens/profile/settings/general.dart';
import 'package:flutter_savdogar/screens/profile/settings/message.dart';
import 'package:flutter_savdogar/screens/profile/settings/other.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_main.dart';

import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: getBody(settings),
    );
  }

  Widget getBody(MySettings settings) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              shadowColor: Colors.black.withOpacity(0.5),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: [
                    buildInkWellButton(
                      Icons.settings,
                      "Umumiy",
                      "Umumiy",
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralPage())),
                      Colors.greenAccent,
                      BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    buildDivider(),
                    buildInkWellButton(
                      Icons.home,
                      "Asosiy",
                      "Asosiy",
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage())),
                      Colors.blue,
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildInkWellButton(
                      Icons.add_circle_outlined,
                      "Qo'shimcha",
                      "Qo'shimcha",
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalPage())),
                      Colors.orange,
                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              shadowColor: Colors.black.withOpacity(0.5),
              elevation: 5,
              child: Column(
                children: [
                  buildInkWellButton(
                    Icons.front_hand_outlined,
                    "FRONT",
                    "FRONT",
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => FrontPage())),
                    Colors.purpleAccent,
                    BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  buildDivider(),
                  buildInkWellButton(
                    Icons.tune,
                    "Boshqa",
                    "Boshqa",
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherPage())),
                    Colors.green,
                    BorderRadius.zero,
                  ),
                  buildDivider(),
                  buildInkWellButton(
                    Icons.message,
                    "SMS va Telegram",
                    "SMS va Telegram",
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage())),
                    Colors.orangeAccent,
                    BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInkWellButton(IconData icon, String title, String subtitle, VoidCallback onTap, Color backgroundColor, BorderRadius? borderRadius) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, top: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w400)),
                SizedBox(height: 5),
                Text(subtitle, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w300)),
              ],
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(height: 1, thickness: 1);
  }
}
