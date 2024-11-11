import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_data.dart';
import 'package:provider/provider.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  TextEditingController firmName = TextEditingController();
  TextEditingController firmAddress = TextEditingController();
  TextEditingController firmPhone = TextEditingController();
  TextEditingController fio = TextEditingController();

  @override
  void initState() {
    super.initState();
    firmName.text = SettingsData.settingsData!.firmName;
    firmAddress.text = SettingsData.settingsData!.firmAddress;
    firmPhone.text = SettingsData.settingsData!.firmPhone;
    fio.text = SettingsData.settingsData!.fio;
  }

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Umumiy"),
        actions: [
          IconButton(
            onPressed: () {
              doSync(settings);
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            myTextField("Firma nomi", firmName, TextInputType.text),
            myTextField("Address", firmAddress, TextInputType.text),
            myTextField("Telefon nomeri", firmPhone, TextInputType.phone),
            myTextField("Direktor FIO", fio, TextInputType.text),
          ],
        ),
      ),
    );
  }

  Widget myTextField(String text, TextEditingController controller, TextInputType keyboard) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }

  doSync(MySettings settings) async {
    SettingsData.settingsData?.firmName = firmName.text;
    SettingsData.settingsData?.firmAddress = firmAddress.text;
    SettingsData.settingsData?.firmPhone = firmPhone.text;
    SettingsData.settingsData?.fio = fio.text;
    await SettingsData.updateData(context, settings);
  }
}
