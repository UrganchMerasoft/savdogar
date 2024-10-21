import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {},
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                height: 70,
                disabledDayStyle: DayStyle(),
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Материальный результат", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            actionType("Продажа", "Сравнить со вчерашним днем", "13.450.000", "-14", Theme.of(context).primaryColor),
            actionType("Возврат", "Сравнить со вчерашним днем", "355.000", "10", Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Финансовый результат", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            actionType("Приход", "Сравнить со вчерашним днем", "13.450.000", "-10", Colors.orange),
            actionType("Расход", "Сравнить со вчерашним днем", "3.650.000", "5", Colors.orange),
            actionType("Затрата", "Сравнить со вчерашним днем", "478.000", "8", Colors.orange),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Статистика по датам", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey)),
                      const SizedBox(height: 10),
                      Text("Продажа и оплаты", style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  Row(
                    children: [
                      Container(height: 10, width: 10, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5))),
                      const SizedBox(width: 5),
                      const Text("Оплата")
                    ],
                  ),
                  Row(
                    children: [
                      Container(height: 10, width: 10, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5))),
                      const SizedBox(width: 5),
                      const Text("Продажа")
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, height: 1),
            const SizedBox(height: 15),
            getLineChart(),
            const SizedBox(height: 30),
            Text("Статистика по датам", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey)),
            const SizedBox(height: 10),
            Text("Продажа и оплаты", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            const Divider(thickness: 1, height: 1),
            getPieChart(),
            const SizedBox(height: 15),
            getCategoryType("Категория 1", "36,638,465.14", Colors.green.shade700),
            getCategoryType("Категория 2", "36,638,465.14", Colors.orange.shade700),
            getCategoryType("Категория 3", "36,638,465.14", Colors.purple.shade700),
            getCategoryType("Категория 4", "36,638,465.14", Colors.yellow.shade700),
            getCategoryType("Категория 5", "36,638,465.14", Colors.green.shade700),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  getCategoryType(String cat, String sum, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 30, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 20, width: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
          const SizedBox(width: 10),
          Text(cat, style: Theme.of(context).textTheme.labelLarge),
          const Spacer(),
          Text(sum, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  getLineChart() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: MediaQuery.of(context).size.width / 1.5,
      child: LineChart(
        LineChartData(
          // minX: 1,
          // maxX: 6,
          // minY: 1,
          // maxY: 6,
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 1),
                const FlSpot(1, 3),
                const FlSpot(2, 2),
                const FlSpot(3, 4),
                const FlSpot(4, 3),
                const FlSpot(5, 5),
              ],
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            ),
            LineChartBarData(
              spots: [
                const FlSpot(0, 2),
                const FlSpot(2, 3),
                const FlSpot(3, 2),
                const FlSpot(3.5, 3.4),
                const FlSpot(4, 2),
                const FlSpot(5, 1),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.2)),
            ),
          ],
        ),
      ),
    );
  }

  getPieChart() {
    return Container(
      height: MediaQuery.of(context).size.width / 1.1,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: MediaQuery.of(context).size.width / 6,
          borderData: FlBorderData(show: false),
          sectionsSpace: 5,
          sections: [
            PieChartSectionData(value: 5, color: Colors.purple, radius: 70),
            PieChartSectionData(value: 2, color: Colors.amber, radius: 70),
            PieChartSectionData(value: 3, color: Colors.green, radius: 70),
            PieChartSectionData(value: 5, color: Colors.orange, radius: 70),
          ],
        ),
      ),
    );
  }

  actionType(String type, String decText, String sum, String protcent, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 45, width: 3, color: color),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(decText),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(sum, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("$protcent%"),
            ],
          )
        ],
      ),
    );
  }
}
