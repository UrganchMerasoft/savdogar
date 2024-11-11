import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_data.dart';
import 'package:provider/provider.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  final sum_0 = ValueNotifier<bool>(false);
  final round_05 = ValueNotifier<bool>(false);
  final qty_00 = ValueNotifier<bool>(false);
  final lastPriceMain = ValueNotifier<bool>(false);
  final touchScreen = ValueNotifier<bool>(false);
  final useSMS = ValueNotifier<bool>(false);
  final useScanner = ValueNotifier<bool>(false);
  final useKassa = ValueNotifier<bool>(false);
  final prixodSellPrice = ValueNotifier<bool>(false);
  final useSquareMeters = ValueNotifier<bool>(false);
  final lookUpCache = ValueNotifier<bool>(false);
  final redDolg = ValueNotifier<bool>(false);
  final useAktInv = ValueNotifier<bool>(false);
  final useLog = ValueNotifier<bool>(false);
  final useCashback = ValueNotifier<bool>(false);
  final useRassrochka = ValueNotifier<bool>(false);
  final useCRM = ValueNotifier<bool>(false);
  final useHR = ValueNotifier<bool>(false);
  int? selectedId;

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
        title: Text("Boshqalar"),
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
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade100)),
        shadowColor: Colors.black.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              settingsSwitcher("Summa '0' formatda", "Price index tanlash", sum_0, (value) => SettingsData.settingsData?.summ0 = value),
              buildDivider(),
              settingsSwitcher(
                  "0.5 gacha yaxlitlash", "Chek to'lovdan keyin pechat qilish", round_05, (value) => SettingsData.settingsData?.round05 = value),
              buildDivider(),
              settingsSwitcher("Miqdor 0.00 formatda", "Price index tanlash", qty_00, (value) => SettingsData.settingsData?.qty00 = value),
              buildDivider(),
              settingsSwitcher("Oxirgi narxni sotish narxiga qo'yish", "Price index tanlash", lastPriceMain,
                  (value) => SettingsData.settingsData?.lastPriceMain = value),
              buildDivider(),
              settingsSwitcher("Sensorniy ekran", "Price index tanlash", touchScreen, (value) => SettingsData.settingsData?.touchScreen = value),
              buildDivider(),
              settingsSwitcher("SMS da foydalanish", "Price index tanlash", useSMS, (value) => SettingsData.settingsData?.useSms = value),
              buildDivider(),
              settingsSwitcher(
                  "Shtrix skannerdan foydalanish", "Price index tanlash", useScanner, (value) => SettingsData.settingsData?.useScanner = value),
              buildDivider(),
              settingsSwitcher("Kassada statusdan foydalanish", "Price index tanlash", useKassa, (value) => ()),
              buildDivider(),
              settingsSwitcher(
                  "Kirim narxi=Sotish narxi", "Price index tanlash", prixodSellPrice, (value) => SettingsData.settingsData?.prixodSellPrice = value),
              buildDivider(),
              settingsSwitcher("Metr kvadratdan foydalanish", "Price index tanlash", useSquareMeters,
                  (value) => SettingsData.settingsData?.useSquareMeters = value),
              buildDivider(),
              settingsSwitcher("LookUp Cache", "Price index tanlash", lookUpCache, (value) => SettingsData.settingsData?.lookupCache = value),
              buildDivider(),
              settingsSwitcher(
                  "Akt inventarizatsiyadan fooydalanish", "Price index tanlash", useAktInv, (value) => SettingsData.settingsData?.useAktInv = value),
              buildDivider(),
              settingsSwitcher("'Korzinka' dan foydalanish", "Price index tanlash", useLog, (value) => SettingsData.settingsData?.useLog = value),
              buildDivider(),
              settingsSwitcher("Cashback foydalanish", "Price index tanlash", useCashback, (value) => SettingsData.settingsData?.useCashback = value),
              buildDivider(),
              settingsSwitcher(
                  "Rasrochkadan foydalanish", "Price index tanlash", useRassrochka, (value) => SettingsData.settingsData?.useRassrochka = value),
              buildDivider(),
              DropdownButtonFormField<int>(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                value: selectedId,
                decoration: InputDecoration(
                  labelText: "Tannarx (qayta hisoblash)",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                ),
                items: [
                  // DropdownMenuItem<int>(value: 0, child: Text("Husanboy")),
                  // DropdownMenuItem<int>(value: 1, child: Text("Alisher")),
                  // DropdownMenuItem<int>(value: 2, child: Text("Javlon")),
                  // DropdownMenuItem<int>(value: 3, child: Text("Alibek")),
                  // DropdownMenuItem<int>(value: 4, child: Text("Jamshid")),
                  // DropdownMenuItem<int>(value: 5, child: Text("Sardor")),
                ],
                menuMaxHeight: 400,
                onChanged: (int? id) {
                  setState(() {
                    selectedId = id;
                  });
                },
              ),
              buildDivider(),
              DropdownButtonFormField<int>(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                value: selectedId,
                decoration: InputDecoration(
                  labelText: "Xarajat kontragent",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                ),
                items: [
                  // DropdownMenuItem<int>(value: 0, child: Text("Xarajat")),
                  // DropdownMenuItem<int>(value: 1, child: Text("Alisher")),
                  // DropdownMenuItem<int>(value: 2, child: Text("Javlon")),
                  // DropdownMenuItem<int>(value: 3, child: Text("Alibek")),
                  // DropdownMenuItem<int>(value: 4, child: Text("Jamshid")),
                  // DropdownMenuItem<int>(value: 5, child: Text("Sardor")),
                ],
                menuMaxHeight: 400,
                onChanged: (int? id) {
                  setState(() {
                    selectedId = id;
                  });
                },
              ),
              buildDivider(),
              settingsSwitcher("CRM dan foydalanish", "Price index tanlash", useCRM, (value) => SettingsData.settingsData?.useCrm = value),
              buildDivider(),
              settingsSwitcher("HR dan foydalanish", "Price index tanlash", useHR, (value) => SettingsData.settingsData?.useHr = value),
            ],
          ),
        ),
      ),
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
                print(value);
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

  void doSync(MySettings settings) async {
    await SettingsData.updateData(context, settings);
  }

  void _loadSettings(MySettings settings) async {
    await SettingsData.getAllSettings(settings, context);
    sum_0.value = SettingsData.settingsData!.summ0 > 0;
    round_05.value = SettingsData.settingsData!.round05 > 0;
    qty_00.value = SettingsData.settingsData!.qty00 > 0;
    lastPriceMain.value = SettingsData.settingsData!.lastPriceMain > 0;
    touchScreen.value = SettingsData.settingsData!.touchScreen > 0;
    useSMS.value = SettingsData.settingsData!.useSms > 0;
    useScanner.value = SettingsData.settingsData!.useScanner > 0;
    useKassa.value = false;
    prixodSellPrice.value = SettingsData.settingsData!.prixodSellPrice > 0;
    useSquareMeters.value = SettingsData.settingsData!.useSquareMeters > 0;
    lookUpCache.value = SettingsData.settingsData!.lookupCache > 0;
    redDolg.value = SettingsData.settingsData!.redDolg > 0;
    useAktInv.value = SettingsData.settingsData!.useAktInv > 0;
    useLog.value = SettingsData.settingsData!.useLog > 0;
    useCashback.value = SettingsData.settingsData!.useCashback > 0;
    useRassrochka.value = SettingsData.settingsData!.useRassrochka > 0;
    useCRM.value = SettingsData.settingsData!.useCrm > 0;
    useHR.value = SettingsData.settingsData!.useHr > 0;
    settings.saveAndNotify();
  }
}
