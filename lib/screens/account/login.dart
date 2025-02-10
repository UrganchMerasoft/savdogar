import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/mysettings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode codeFocus = FocusNode();
  String phone = "";
  String server = "";
  String serverName = "";
  final bool _isLoading = false;

  int counterSeconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    phoneController.text = "+998";
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<MySettings>(context);
    return Container(
      color: Colors.blue,
      // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/splashscreen.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: SingleChildScrollView(child: getPhoneBody(settings))),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPhoneBody(MySettings settings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            // Padding(padding: const EdgeInsets.fromLTRB(0, 72, 0, 0), child: Image.asset("assets/images/djolis_logo.png", height: 124, width: 200)),
            const SizedBox(height: 30),
            TextFormField(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              onTap: () {
                phoneController.selection = TextSelection(baseOffset: 4, extentOffset: phoneController.text.length);
              },
              controller: phoneController,
              // validator: (v) => v!.isEmpty ? AppLocalizations.of(context).translate("gl_cannot_empty") : null,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                fillColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.white.withOpacity(0.1),
                isDense: true,
                prefixStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                // labelText: AppLocalizations.of(context).translate("new_account_phone"),
                labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white),
                contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                focusColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              child: TextFormField(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                onTap: () {
                  codeController.selection = TextSelection(baseOffset: 0, extentOffset: codeController.text.length);
                },
                controller: codeController,
                focusNode: codeFocus,
                // validator: null,
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).brightness == Brightness.dark ? null : Colors.white.withOpacity(0.1),
                  //const Color.fromRGBO(94, 36, 66, 0.1),
                  isDense: true,
                  prefixStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                  labelText: "parol",
                  labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white),
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
                  focusColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {},
                child: _isLoading
                    ? const SpinKitCircle(color: Colors.white, size: 25.0)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(visible: _isLoading, child: const SpinKitCircle(color: Colors.white, size: 25.0)),
                          const SizedBox(width: 10),
                          Text(
                            "Kirish",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
