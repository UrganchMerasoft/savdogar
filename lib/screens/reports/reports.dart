import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          _buildSectionTitle("Основные отчеты"),
          _buildDocButton(0, "Остаток товаров", Icons.people_alt_outlined),
          _buildDocButton(1, "Оборот товара", Icons.corporate_fare),
          _buildDocButton(2, "Дебитор-кредиторы", Icons.dashboard),
          _buildDocButton(3, "Акт сверка", Icons.map_outlined),
          const SizedBox(height: 20),
          _buildSectionTitle("Прочие отчеты"),
          _buildDocButton(4, "Ежедневный отчет", Icons.people_alt_outlined),
          _buildDocButton(5, "Затраты", Icons.corporate_fare),
          _buildDocButton(6, "Резулътат", Icons.dashboard),
          _buildDocButton(7, "Баланс", Icons.map_outlined),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(alignment: Alignment.centerLeft, child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  Widget _buildDocButton(int index, String text, IconData icon) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey.shade700),
                const SizedBox(width: 15),
                Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black))),
                Icon(Icons.chevron_right, color: Colors.grey.shade600),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
      ],
    );
  }
}
