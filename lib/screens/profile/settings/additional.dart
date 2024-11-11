import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_data.dart';
import 'package:provider/provider.dart';

class AdditionalPage extends StatefulWidget {
  const AdditionalPage({super.key});

  @override
  State<AdditionalPage> createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPage> {
  final useImei = ValueNotifier<bool>(false);
  final imeiStrict = ValueNotifier<bool>(false);
  final useAnnul = ValueNotifier<bool>(false);
  final useBarcode = ValueNotifier<bool>(false);
  int invDocNumType = 0;
  TextEditingController autoLogin = TextEditingController();
  TextEditingController emptyPsw = TextEditingController();
  TextEditingController maxPriceIndex = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController barcode = TextEditingController();

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);

    if (first) {
      first = false;
      _loadSettings(settings);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Qoshimcha"),
        actions: [
          IconButton(
            onPressed: () async{
              await doSync(settings);
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadowColor: Colors.black.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                settingsSwitcher("Imei kiritish", "Imei kiritish", useImei, (value) => SettingsData.settingsData!.useImei = value),
                buildDivider(),
                settingsSwitcher("Imei majburiy", "Kirim va chiqim", imeiStrict, (value) => SettingsData.settingsData!.imeiStrict = value),
                buildDivider(),
                SizedBox(height: 10),
                myTextField("Avto Login", autoLogin, TextInputType.text),
                buildDivider(),
                SizedBox(height: 10),
                myTextField("Pustoy Parol", emptyPsw, TextInputType.text),
                buildDivider(),
                Align(alignment: Alignment.centerLeft, child: Text("Ҳужжат номерлаш", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                buildRadioOption(0, "Numeratsiyasiz"),
                buildRadioOption(1, "Kirim, chiqim, qaytarildi uchun umumiy bitta nomerlash"),
                buildRadioOption(2, "Kirim, chiqim, qaytarildi uchun alohida"),
                buildRadioOption(3, "Kirim, chiqim, qaytarildi uchun alohida (har oy boshidan)"),
                buildRadioOption(4, "Kirim, chiqim, qaytarildi uchun alohida (har kun boshidan)"),
                buildDivider(),
                settingsSwitcher("Annuliyatsiyadan foydalanish", "Imei kiritish", useAnnul, (value) => SettingsData.settingsData!.useAnnul = value),
                buildDivider(),
                settingsSwitcher("Sennik pechat qilish", "Imei kiritish", useBarcode, (value) => SettingsData.settingsData!.useBarcode = value),
                buildDivider(),
                SizedBox(height: 10),
                myTextField("Valyuta kursi", currency, TextInputType.text),
                SizedBox(height: 10),
                myTextField("Narxlar indexi (maks.)", maxPriceIndex, TextInputType.text),
                SizedBox(height: 10),
                myTextField("Barcode", barcode, TextInputType.number),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioOption(int index, String text) {
    return RadioListTile<int>(
      title: Text(text),
      value: index,
      groupValue: invDocNumType,
      onChanged: (int? selectedIndex) {
        setState(() {
          invDocNumType = selectedIndex!;
        });
      },
    );
  }

  Widget settingsSwitcher(String text, String description, ValueNotifier<bool> controller, Function(int) fun) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w400)),
              const SizedBox(height: 5),
              Text(description, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: controller,
          builder: (context, value, child) {
            return AdvancedSwitch(
              controller: controller,
              onChanged: (value) {
                controller.value = value;
                fun(value ? 1 : 0);
              },
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: const Color(0x80A19E9E),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              width: 48,
              height: 28,
              thumb: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Column(
      children: [
        SizedBox(height: 15),
        Divider(height: 1, thickness: 1),
        SizedBox(height: 15),
      ],
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

  void _loadSettings(MySettings settings) async {
    await SettingsData.getAllSettings(settings, context);
    useImei.value = SettingsData.settingsData!.useImei > 0;
    imeiStrict.value = SettingsData.settingsData!.imeiStrict > 0;
    useAnnul.value = SettingsData.settingsData!.useAnnul > 0;
    useBarcode.value = SettingsData.settingsData!.useBarcode > 0;
    invDocNumType = SettingsData.settingsData!.invDocNumType;
    emptyPsw.text = SettingsData.settingsData!.emptyPsw;
    currency.text = SettingsData.settingsData!.rate.toString();
    maxPriceIndex.text = SettingsData.settingsData!.maxPriceIndex.toString();
    settings.saveAndNotify();
  }

  Future<void> doSync(MySettings settings) async {
    SettingsData.settingsData?.invDocNumType = invDocNumType;
    SettingsData.settingsData?.emptyPsw = emptyPsw.text;
    autoLogin.text = "";
    SettingsData.settingsData?.maxPriceIndex = int.parse(maxPriceIndex.text);
    SettingsData.settingsData?.rate = int.parse(currency.text);
    barcode.text = "";
    await SettingsData.updateData(context, settings);
  }
}
