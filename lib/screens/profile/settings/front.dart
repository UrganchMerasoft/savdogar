import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/profile/settings/settings_data.dart';
import 'package:provider/provider.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final frontPriceIndex = ValueNotifier<bool>(false);
  final printAfterPay = ValueNotifier<bool>(false);
  final hotProducts = ValueNotifier<bool>(false);
  final autoQty = ValueNotifier<bool>(false);
  final showLastPrice = ValueNotifier<bool>(false);
  final showLastPriceIn = ValueNotifier<bool>(false);
  final frontOst = ValueNotifier<bool>(false);
  final useReturnOnFront = ValueNotifier<bool>(false);
  final frontMultiPay = ValueNotifier<bool>(false);
  final frontAutoPay = ValueNotifier<bool>(false);

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
        title: Text("FRONT"),
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
              DropdownButtonFormField<int>(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                value: selectedId,
                decoration: InputDecoration(
                  labelText: "Название категории",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                ),
                items: [
                  DropdownMenuItem<int>(value: 0, child: Text("Husanboy")),
                  DropdownMenuItem<int>(value: 1, child: Text("Alisher")),
                  DropdownMenuItem<int>(value: 2, child: Text("Javlon")),
                  DropdownMenuItem<int>(value: 3, child: Text("Alibek")),
                  DropdownMenuItem<int>(value: 4, child: Text("Jamshid")),
                  DropdownMenuItem<int>(value: 5, child: Text("Sardor")),
                ],
                menuMaxHeight: 400,
                onChanged: (int? id) {
                  setState(() {
                    selectedId = id;
                  });
                },
              ),
              buildDivider(),
              settingsSwitcher(
                  "Price index tanlash", "Price index tanlash", frontPriceIndex, (value) => SettingsData.settingsData?.frontPriceIndex = value),
              buildDivider(),
              settingsSwitcher("Chek to'lovdan keyin pechat qilish", "Chek to'lovdan keyin pechat qilish", printAfterPay,
                  (value) => SettingsData.settingsData?.printAfterPay = value),
              buildDivider(),
              settingsSwitcher("Savdo formasida eng ko'p sotilgan tovarlar royhatini chiqarish", "Price index tanlash", hotProducts,
                  (value) => SettingsData.settingsData?.hotProducts = value),
              buildDivider(),
              settingsSwitcher("Savdo formasida tovar qo'shish bilan sonini so'rash dialogi", "Price index tanlash", autoQty,
                  (value) => SettingsData.settingsData?.autoQty = value),
              buildDivider(),
              settingsSwitcher("Savdo formasida oxirgi sotilgan narxni ko'rsatish", "Price index tanlash", showLastPrice,
                  (value) => SettingsData.settingsData?.showLastprice = value),
              buildDivider(),
              settingsSwitcher("Savdo formasida oxirgi KIRIM narxini ko'rsatish", "Price index tanlash", showLastPriceIn,
                  (value) => SettingsData.settingsData?.showLastpriceIn = value),
              buildDivider(),
              settingsSwitcher(
                  "Tovar qoldig'ini tekshirish", "Price index tanlash", frontOst, (value) => SettingsData.settingsData?.frontOst = value),
              buildDivider(),
              settingsSwitcher("Front da vazvratdan foydalanish", "Price index tanlash", useReturnOnFront,
                  (value) => SettingsData.settingsData?.useReturnOnFront = value),
              buildDivider(),
              settingsSwitcher("Front da to'lov qilishda ko'p to'lov qo'shilishi", "Price index tanlash", frontMultiPay,
                  (value) => SettingsData.settingsData?.frontMultiPay = value),
              buildDivider(),
              settingsSwitcher("Saqlashda avtomatik to'lov qilish (FRONT)", "Price index tanlash", frontAutoPay,
                  (value) => SettingsData.settingsData?.frontAutoPay = value),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingsSwitcher(String text, String description, ValueNotifier<bool> controller, Function(int) func) {
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
                func(value ? 1 : 0);
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
    frontPriceIndex.value = SettingsData.settingsData!.frontPriceIndex > 0;
    printAfterPay.value = SettingsData.settingsData!.printAfterPay > 0;
    hotProducts.value = SettingsData.settingsData!.hotProducts > 0;
    autoQty.value = SettingsData.settingsData!.autoQty > 0;
    showLastPrice.value = SettingsData.settingsData!.showLastprice > 0;
    showLastPriceIn.value = SettingsData.settingsData!.showLastpriceIn > 0;
    frontOst.value = SettingsData.settingsData!.frontOst > 0;
    useReturnOnFront.value = SettingsData.settingsData!.useReturnOnFront > 0;
    frontMultiPay.value = SettingsData.settingsData!.frontMultiPay > 0;
    frontAutoPay.value = SettingsData.settingsData!.frontAutoPay > 0;
    settings.saveAndNotify();
  }
}
