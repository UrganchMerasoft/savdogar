import 'dart:convert';
import 'dart:math';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_savdogar/core/mysettings.dart';
import 'package:flutter_savdogar/model/dashboard/chart_line.dart';
import 'package:flutter_savdogar/model/dashboard/chart_pie.dart';
import 'package:flutter_savdogar/model/dashboard/mainly.dart';
import 'package:flutter_savdogar/service/http_service.dart';
import 'package:provider/provider.dart';

import '../../share/utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<ChartLine> chartLine = [];
  List<ChartPie> chartPie = [];
  List<Main> mainData = [];

  bool first = true;

  @override
  Widget build(BuildContext context) {
    MySettings settings = Provider.of(context);

    if (first) {
      first = false;
      getDashboardData(settings);
    }
    return Scaffold(body: getBody());
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {},
              headerProps: const EasyHeaderProps(monthPickerType: MonthPickerType.dropDown, dateFormatter: DateFormatter.fullDateMDY()),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                height: 55,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff3371FF), Color(0xff8426D6)],
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
            actionType(),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Финансовый результат", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Статистика по датам", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(height: 10, width: 10, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5))),
                  const SizedBox(width: 8),
                  const Text("Оплата"),
                  Expanded(
                    child: Row(
                      children: [
                        Container(height: 10, width: 10, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5))),
                        const SizedBox(width: 5),
                        Expanded(child: const Text("Продажа"))
                      ],
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // const Divider(thickness: 1, height: 1),
            // const SizedBox(height: 15),
            // getLineChart(),
            const SizedBox(height: 30),
            Text("Статистика по датам", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey)),
            const SizedBox(height: 20),
            const Divider(thickness: 1, height: 1),
            getPieChart(),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 100);
  }

  getPieChart() {
    List<Color> chartColors = List.generate(chartPie.length, (index) => getRandomColor());
    double totalSum = chartPie.fold(0, (sum, item) => sum + item.summ);
    ValueNotifier<String> selectedCatName = ValueNotifier<String>("");

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width / 1.1,
          child: ValueListenableBuilder<String>(
            valueListenable: selectedCatName,
            builder: (context, catName, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      centerSpaceRadius: MediaQuery.of(context).size.width / 6,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0.5,
                      startDegreeOffset: 120,
                      sections: List.generate(
                        chartPie.length,
                        (index) {
                          double percentage = (chartPie[index].summ / totalSum) * 100;
                          return PieChartSectionData(
                            value: percentage,
                            color: chartColors[index],
                            radius: 70,
                            title: percentage > 4 ? '${percentage.toStringAsFixed(1)}%' : "",
                            titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      pieTouchData: PieTouchData(
                        enabled: false,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                            selectedCatName.value = "";
                            return;
                          }
                          final touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          selectedCatName.value = chartPie[touchedIndex].catName;
                        },
                      ),
                    ),
                  ),
                  Positioned(bottom: -5, child: Text(catName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black))),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  getCategoryType() {
    List<Color> chartColors = List.generate(chartPie.length, (index) => getRandomColor());
    double totalSum = chartPie.fold(0, (sum, item) => sum + item.summ);

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: chartPie.length,
      padding: EdgeInsets.only(),
      itemBuilder: (context, index) {
        double percentage = (chartPie[index].summ / totalSum) * 100;
        return Padding(
          padding: const EdgeInsets.only(left: 25, right: 30, top: 15),
          child: Row(
            children: [
              Container(height: 20, width: 20, decoration: BoxDecoration(color: chartColors[index], borderRadius: BorderRadius.circular(5))),
              const SizedBox(width: 10),
              Expanded(child: Text(chartPie[index].catName, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black))),
              Spacer(),
              Text(
                '${Utils.myNumFormat(Utils.numFormat0_00, chartPie[index].summ)} (${percentage.toStringAsFixed(1)}%)',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }

  getLineChart() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: MediaQuery.of(context).size.width / 1.5,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1)),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(chartLine.length, (index) {
                return FlSpot(index.toDouble(), chartLine[index].summPayment);
              }),
              color: Colors.red,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
            ),
            LineChartBarData(
              isCurved: true,
              spots: List.generate(chartLine.length, (index) {
                return FlSpot(index.roundToDouble(), 1);
              }),
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

  actionType() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade300, width: 1)),
      elevation: 5,
      shadowColor: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mainData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mainData[index].typeName.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    Text(
                      Utils.myNumFormat(Utils.numFormat0_00, mainData[index].summ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15, color: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Сравнить со вчерашним днем",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    Text(
                      "14%",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                if (index != mainData.length - 1) ...[
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> getDashboardData(MySettings settings) async {
    String body = jsonEncode({});
    var res = await MyHttpService.POST(context, "${settings.serverUrl}/dashboard/mobile", body, settings);
    var data = jsonDecode(res);
    mainData = (data["main"] as List).map((e) => Main.fromMapObject(e)).toList();
    chartLine = (data["chart_line"] as List).map((e) => ChartLine.fromMapObject(e)).toList();
    chartPie = (data["chart_pie"] as List).map((e) => ChartPie.fromMapObject(e)).toList();
    settings.saveAndNotify();
  }
}
