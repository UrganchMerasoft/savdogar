import 'package:flutter/material.dart';
import 'package:flutter_savdogar/screens/dashboard/dashboard.dart';
import 'package:flutter_savdogar/screens/dics/dic_cat.dart';
import 'package:flutter_savdogar/screens/dics/dic_contra.dart';
import 'package:flutter_savdogar/screens/dics/dic_region.dart';
import 'package:flutter_savdogar/screens/dics/dic_zatrat.dart';
import 'package:flutter_savdogar/screens/dics/supplier.dart';
import 'package:flutter_savdogar/screens/docs/cash/doc_cash.dart';
import 'package:flutter_savdogar/screens/docs/cash/doc_cash_edit.dart';
import 'package:flutter_savdogar/screens/profile/profile.dart';
import 'package:flutter_savdogar/screens/reports/reports.dart';
import 'package:flutter_savdogar/screens/reports/view_ost.dart';
import 'package:line_icons/line_icons.dart';

import '../docs/inv/doc_inv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabIndex = 0;
  int backPressCounter = 0;
  int backPressTotal = 2;
  final ValueNotifier<bool> _backPressAllowed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return PopScope(
          canPop: value,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showExitSnackBar(context);
              _allowBackPress();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Savdogar Mobile"),
              actions: [
                Visibility(visible: tabIndex == 3, child: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
              ],
            ),
            body: getBodyFromPage(),
            bottomNavigationBar: getNavBar(),
          ),
        );
      },
      valueListenable: _backPressAllowed,
    );
  }

  Future<void> _allowBackPress() async {
    _backPressAllowed.value = true;
    await Future.delayed(const Duration(milliseconds: 2000));
    _backPressAllowed.value = false;
  }

  void _showExitSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Chiqish uchun ikki marta bosing!", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            getDocType("Кассовые дoкументы", (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DocCashPage()))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDocAction1(
                  "Приход",
                  Colors.green,
                  (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(tabIndex: 0))),
                ),
                SizedBox(width: 5),
                getDocAction1(
                  "Расход",
                  Colors.red,
                  (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(tabIndex: 1))),
                ),
                SizedBox(width: 5),
                getDocAction1(
                  "Затрата",
                  Colors.red,
                  (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => DocCashEditPage(tabIndex: 2))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            getDocType("Документы склада", (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DocInvPage()))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDocAction1(
                  "Приход",
                  Colors.green,
                  (context) => (),
                ),
                SizedBox(width: 5),
                getDocAction1(
                  "Расход",
                  Colors.red,
                  (context) => (),
                ),
                SizedBox(width: 5),
                getDocAction1(
                  "Возвраты",
                  Colors.red,
                  (context) => (),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
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
                    buildDicButton(
                      "Акт-сверка с клиентами",
                      Icons.how_to_reg_outlined,
                      (context) => (),
                      BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Остаток склада",
                      Icons.shopping_basket_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewOst())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Дебитор-кредитор",
                      Icons.local_atm,
                      (context) => (),
                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Справочники", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ],
            ),
            Container(
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
                    buildDicButton(
                      "Клиентская база",
                      Icons.people_alt_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicContraPage())),
                      BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Поставщики",
                      Icons.corporate_fare,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => Supplier())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Категория товаров",
                      Icons.dashboard,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicCatPage())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Регионы",
                      LineIcons.map,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicRegionPage())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Затрата",
                      LineIcons.coins,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicZatratPage())),
                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getBodyFromPage() {
    if (tabIndex == 0) {
      return const Dashboard();
    }
    if (tabIndex == 1) {
      return getBody();
    }
    if (tabIndex == 2) {
      return const Reports();
    }
    if (tabIndex == 3) {
      return const ProfilePage();
    }
  }

  getNavBar() {
    return BottomNavigationBar(
      onTap: (value) {
        tabIndex = value;
        setState(() {});
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      currentIndex: tabIndex,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard, color: tabIndex == 0 ? Colors.white : Colors.white30), label: "Доска"),
        BottomNavigationBarItem(icon: Icon(Icons.home, color: tabIndex == 1 ? Colors.white : Colors.white30), label: "Главный"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment, color: tabIndex == 2 ? Colors.white : Colors.white30), label: "Отчеты"),
        BottomNavigationBarItem(icon: Icon(Icons.person, color: tabIndex == 3 ? Colors.white : Colors.white30), label: "Профиль"),
      ],
    );
  }

  getDocType(String text, Function func) {
    return ElevatedButton(
      onPressed: () {
        func(context);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(55),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
          Icon(Icons.chevron_right, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Divider(height: 1, thickness: 1);
  }

  getDocAction1(String text, Color color, Function(BuildContext context) func) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(50),
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      ),
      onPressed: () => func(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(width: 10),
          Icon(Icons.add, color: color, size: 20),
        ],
      ),
    );
  }

  Widget buildDicButton(String text, IconData icon, Function(BuildContext context) func, BorderRadius? borderRadius) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: () {
        Future.delayed(Duration(milliseconds: 200), () => func(context));
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(width: 10),
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
