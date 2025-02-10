import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/screens/docs/inv/doc_inv_provider.dart';
import 'package:flutter_savdogar/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/mysettings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MySettings>(create: (_) => MySettings(prefs)),
      ChangeNotifierProvider<DocInvProvider>(create: (_) => DocInvProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final settings = Provider.of<MySettings>(context);

    // setInitialData(settings);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.blueM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.blueM3),
      // themeMode: settings.theme == 0 ? ThemeMode.system : (settings.theme == 2 ? ThemeMode.light : ThemeMode.dark),
      themeMode: ThemeMode.system,
      home: const Wrapper(),
    );
  }

// void setInitialData(MySettings settings) async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   MySettings.syncVersion = Utils.checkDouble("0${packageInfo.buildNumber}").toInt();
//   MySettings.version = "${packageInfo.version}.${packageInfo.buildNumber}";
//   settings.saveAndNotify();
// }
}
