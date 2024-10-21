import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text("Основные отчеты", style: Theme.of(context).textTheme.titleLarge)),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  getDocAction2("Клиентская база", Icons.people_alt_outlined),
                  const SizedBox(height: 20),
                  getDocAction2("Поставщики", Icons.corporate_fare),
                  const SizedBox(height: 20),
                  getDocAction2("Категория товаров", Icons.dashboard),
                  const SizedBox(height: 20),
                  getDocAction2("Регионы", Icons.map_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(alignment: Alignment.centerLeft, child: Text("Прочие отчеты", style: Theme.of(context).textTheme.titleLarge)),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  getDocAction2("Клиентская база", Icons.people_alt_outlined),
                  const SizedBox(height: 20),
                  getDocAction2("Поставщики", Icons.corporate_fare),
                  const SizedBox(height: 20),
                  getDocAction2("Категория товаров", Icons.dashboard),
                  const SizedBox(height: 20),
                  getDocAction2("Регионы", Icons.map_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDocAction2(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Icon(Icons.chevron_right, color: Colors.grey.shade600),
      ],
    );
  }
}
