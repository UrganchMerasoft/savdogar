import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController telegramToken = TextEditingController();
  TextEditingController chatId1 = TextEditingController();
  TextEditingController chatId2 = TextEditingController();
  TextEditingController smsKassa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS va Telegram"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              myTextField("Telegram Token", telegramToken, TextInputType.text, 60),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: myTextField("Chat1 ID", chatId1, TextInputType.text, 50)),
                  SizedBox(width: 10),
                  Expanded(child: myTextField("Chat2 ID", chatId2, TextInputType.text, 50)),
                ],
              ),
              SizedBox(height: 15),
              myTextField("SMS Kassa", smsKassa, TextInputType.text, 60),
              SizedBox(height: 15),
              myTextField("SMS Chek", smsKassa, TextInputType.text, 60),
              SizedBox(height: 15),
              myTextField("SMS Qarizdorlik", smsKassa, TextInputType.text, 60),
              SizedBox(height: 15),
              Text(
                "@@cur_summ - Summa, \n@@dolg1_cur - boshlang'ich qarizdorlik,"
                " \n@@dolg2_cur - hozirgi qarizdorlik, \n@@name - mijoz FIO, \n@@days - qarzdorlik o'tgan kuni",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(fixedSize: Size(150, 50)),
                    child: Text("Sozlamalar", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16, color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(fixedSize: Size(150, 50)),
                    child: Text("Rasmlar", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16, color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextField(String text, TextEditingController controller, TextInputType keyboard, [double? size]) {
    return SizedBox(
      height: size,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }
}
