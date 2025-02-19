import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/mysettings.dart';
import '../home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisibility = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<MySettings>(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            height: 80,
            child: Image.asset("assets/images/inwens.png"),
          ),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Введите номер телефона",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: codeController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      isVisibility = !isVisibility;
                      setState(() {});
                    },
                    icon: isVisibility == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                labelText: "Введите пароль",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Войти", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
