import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Align(alignment: Alignment.center, child: CircleAvatar(backgroundColor: Colors.brown, radius: 45, child: Icon(Icons.person, size: 50))),
            SizedBox(height: 15),
            Text("Husanboy Allayorov", style: Theme.of(context).textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: -1, blurRadius: 2, offset: Offset(0, 0)),
                  ],
                ),
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
                    elevation: 0,
                    child: Column(
                      children: [
                        buildInkWellButton(
                          Icons.password_outlined,
                          "Change Password",
                          "Change Password",
                          () => (),
                          Colors.orange,
                          BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        ),
                        buildDivider(),
                        buildInkWellButton(
                          Icons.settings,
                          "Settings",
                          "Settings",
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
                          Colors.indigo,
                          BorderRadius.zero,
                        ),
                        buildDivider(),
                        buildInkWellButton(
                          Icons.laptop,
                          "Sessions",
                          "Sessions",
                          () => (),
                          Colors.blue,
                          BorderRadius.zero,
                        ),
                        buildDivider(),
                        buildInkWellButton(
                          Icons.subscriptions_outlined,
                          "Subscriptions (balance)",
                          "Subscriptions",
                          () => (),
                          Colors.pink,
                          BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: -1, blurRadius: 2, offset: Offset(0, 0)),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
                  elevation: 0,
                  child: Column(
                    children: [
                      buildInkWellButton(
                        Icons.attach_money_outlined,
                        "DicZatrat",
                        "DicZatrat",
                        () => (),
                        Colors.red,
                        BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      buildDivider(),
                      buildInkWellButton(
                        Icons.location_city,
                        "DicRegion",
                        "DicRegion",
                        () => (),
                        Colors.green,
                        BorderRadius.zero,
                      ),
                      buildDivider(),
                      buildInkWellButton(
                        Icons.people,
                        "DicUsers",
                        "DicUsers",
                        () => (),
                        Colors.teal,
                        BorderRadius.zero,
                      ),
                      buildDivider(),
                      buildInkWellButton(
                        Icons.info_outline,
                        "About Us",
                        "About Us",
                        () => (),
                        Colors.orangeAccent,
                        BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      buildDivider(),
                      buildInkWellButton(
                        Icons.logout,
                        "Log Out",
                        "Log Out",
                        () => logOut(settings),
                        Colors.pink,
                        BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInkWellButton(IconData icon, String title, String subtitle, VoidCallback onTap, Color backgroundColor, BorderRadius? borderRadius) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Column(
        children: [
          SizedBox(height: 3),
          Container(
            padding: EdgeInsets.all(8),
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
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400)),
                    SizedBox(height: 5),
                    Text(subtitle, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w300)),
                  ],
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey)
              ],
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(height: 1, thickness: 1);
  }

  logOut(MySettings settings) {
    settings.token = "";
    settings.saveAndNotify();
  }
}
