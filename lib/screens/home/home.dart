import 'package:flutter/material.dart';
import 'package:flutter_savdogar/screens/dashboard/dashboard.dart';
import 'package:flutter_savdogar/screens/dics/dic_contra.dart';
import 'package:flutter_savdogar/screens/dics/dic_prod.dart';
import 'package:flutter_savdogar/screens/dics/dic_region.dart';
import 'package:flutter_savdogar/screens/docs/doc_cash.dart';
import 'package:flutter_savdogar/screens/reports/reports.dart';
import 'package:flutter_savdogar/screens/settings/settings.dart';

import '../docs/doc_inv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Savdogar Mobile"),
        actions: [
          GestureDetector(
            child: const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 10),
                Text("13.10.2024", style: TextStyle(fontSize: 18, color: Colors.white)),
                SizedBox(width: 25),
              ],
            ),
          )
        ],
      ),
      body: getBodyFromPage(),
      bottomNavigationBar: getNavBar(),
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
      return const Settings();
    }
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            getDocType("Кассовые дакументы", (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DocCashPage()))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDocAction1("Приход", Colors.green),
                getDocAction1("Расход", Colors.red),
                getDocAction1("Затрата", Colors.red),
              ],
            ),
            const SizedBox(height: 10),
            getDocType("Документы склада", (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DocInvPage()))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDocAction1("Приход", Colors.green),
                getDocAction1("Расход", Colors.red),
                getDocAction1("Затрата", Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 0.2))),
              child: Column(
                children: [
                  getDocAction2("Акт-сверка с клиентами", Icons.how_to_reg_outlined, (context) => null),
                  const SizedBox(height: 20),
                  getDocAction2("Остаток склада", Icons.shopping_basket_outlined, (context) => null),
                  const SizedBox(height: 20),
                  getDocAction2("Дебитор-кредитор", Icons.local_atm, (context) => null),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Справочники", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 0.2))),
              child: Column(
                children: [
                  getDocAction2("Клиентская база", Icons.people_alt_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicContraPage()))),
                  const SizedBox(height: 20),
                  getDocAction2("Поставщики", Icons.corporate_fare, (context) => null),
                  const SizedBox(height: 20),
                  getDocAction2(
                      "Категория товаров", Icons.dashboard, (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicProdPage()))),
                  const SizedBox(height: 20),
                  getDocAction2("Регионы", Icons.map_outlined, (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const DicRegionPage()))),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
        BottomNavigationBarItem(icon: Icon(Icons.settings, color: tabIndex == 3 ? Colors.white : Colors.white30), label: "Настройки"),
      ],
    );
  }

  getDocType(String text, Function func) {
    return GestureDetector(
      onTap: () {
        func(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyMedium),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  getDocAction1(String text, Color color) {
    return Expanded(
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade600 : Colors.grey.shade300)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyMedium),
            Icon(Icons.add, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  getDocAction2(String text, IconData icon, Function(BuildContext context) func) {
    return InkWell(
      onTap: () {
        func(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
