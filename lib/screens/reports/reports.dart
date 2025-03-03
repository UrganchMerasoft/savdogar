import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/screens/reports/view_balance.dart';
import 'package:flutter_savdogar/screens/reports/view_client_move.dart';
import 'package:flutter_savdogar/screens/reports/view_daily.dart';
import 'package:flutter_savdogar/screens/reports/view_deb.dart';
import 'package:flutter_savdogar/screens/reports/view_obor.dart';
import 'package:flutter_savdogar/screens/reports/view_prod_move.dart';
import 'package:flutter_savdogar/screens/reports/view_result.dart';
import 'package:flutter_savdogar/screens/reports/view_sverka.dart';
import 'package:flutter_savdogar/screens/reports/view_zatrat.dart';
import 'package:provider/provider.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of<MySettings>(context);
    return Scaffold(body: getBody(settings));
  }

  Widget getBody(MySettings settings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildSectionTitle("Основные отчеты"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDicButton(
                      "Остаток товаров",
                      Icons.people_alt_outlined,
                      (context) => (),
                      BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Оборот товара",
                      Icons.corporate_fare,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewObor())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Дебитор-кредиторы",
                      Icons.dashboard,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDeb())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Акт сверка",
                      Icons.map_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSverka())),
                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Прочие отчеты"),
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
                      "Ежедневный отчет",
                      Icons.people_alt_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDaily())),
                      BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Затраты",
                      Icons.corporate_fare,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewZatrat())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Резулътат",
                      Icons.dashboard,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewResult())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Баланс",
                      Icons.map_outlined,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBalance())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Движение товаров",
                      Icons.shopping_cart,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ProdMove())),
                      BorderRadius.zero,
                    ),
                    buildDivider(),
                    buildDicButton(
                      "Движение клиентов",
                      Icons.people_rounded,
                      (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ClientMove())),
                      BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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

  Widget buildDivider() {
    return Divider(height: 1, thickness: 1);
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(alignment: Alignment.centerLeft, child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
    );
  }
}
