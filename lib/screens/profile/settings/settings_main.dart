import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dic/dic_settings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_data.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final mainSum = ValueNotifier<bool>(false);
  final prodCurrency = ValueNotifier<bool>(false);
  final useInvCurrency = ValueNotifier<bool>(false);
  final foydaLastPrice = ValueNotifier<bool>(false);
  final ostByParty = ValueNotifier<bool>(false);
  final useCase = ValueNotifier<bool>(false);
  final usePlastik = ValueNotifier<bool>(false);
  final dontSellBelow = ValueNotifier<bool>(false);
  final prodPriceFixed = ValueNotifier<bool>(false);

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
        title: const Text("Asosiy"),
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
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadowColor: Colors.black.withOpacity(0.8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                settingsSwitcher("So'm asosiy valyuta", mainSum, (par1) => SettingsData.settingsData!.mainSum = par1),
                _buildDivider(),
                settingsSwitcher("Tovarlarni valyuta va so'mda qo'yish", prodCurrency, (par1) => SettingsData.settingsData!.prodCurrency = par1),
                _buildDivider(),
                settingsSwitcher("Kirim qilishda valyuta va qarzdorliklar, ham valyuta va so'm", useInvCurrency,
                    (par1) => SettingsData.settingsData!.useInvCurrency = par1),
                _buildDivider(),
                settingsSwitcher(
                    "Foyda qurishda oxirgi kirim narxini olish", foydaLastPrice, (par1) => SettingsData.settingsData!.foydaLastPrice = par1),
                _buildDivider(),
                settingsSwitcher("Partiya boyicha kirim va savdo", ostByParty, (par1) => SettingsData.settingsData!.ostByParty = par1),
                _buildDivider(),
                settingsSwitcher("Karobka sht bilan ishlash", useCase, (par1) => SettingsData.settingsData!.useCase = par1),
                _buildDivider(),
                settingsSwitcher("Terminal to'lov kiritish", usePlastik, (par1) => SettingsData.settingsData!.usePlastik = par1),
                _buildDivider(),
                settingsSwitcher("Savdo qilishda narx oxirgi kirim narxidan past bo'lmasligini tekshirish", dontSellBelow,
                    (par1) => SettingsData.settingsData!.dontSellBelow = par1),
                _buildDivider(),
                settingsSwitcher(
                    "Tovar 1-narxi minimal narx deb hisoblash", prodPriceFixed, (par1) => SettingsData.settingsData!.prodPriceFixed = par1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingsSwitcher(String text, ValueNotifier<bool> controller, Function(int) fun) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, fontWeight: FontWeight.w400))),
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

  Widget _buildDivider() {
    return const Column(children: [
      SizedBox(height: 15),
      Divider(height: 1, thickness: 1),
      SizedBox(height: 15),
    ]);
  }

  void _loadSettings(MySettings settings) async {
    await SettingsData.getAllSettings(settings, context);
    final DicSettings? dicSettings = SettingsData.settingsData;
    if (dicSettings != null) {
      mainSum.value = dicSettings.mainSum > 0;
      prodCurrency.value = dicSettings.prodCurrency > 0;
      useInvCurrency.value = dicSettings.useInvCurrency > 0;
      foydaLastPrice.value = dicSettings.foydaLastPrice > 0;
      ostByParty.value = dicSettings.ostByParty > 0;
      useCase.value = dicSettings.useCase > 0;
      usePlastik.value = dicSettings.usePlastik > 0;
      dontSellBelow.value = dicSettings.dontSellBelow > 0;
      prodPriceFixed.value = dicSettings.prodPriceFixed > 0;
    }
    settings.saveAndNotify();
  }

  doSync(MySettings settings) async {
    await SettingsData.updateData(context, settings);
  }
}
