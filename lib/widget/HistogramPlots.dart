import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class HistogramPlots extends StatelessWidget {
  final List<double> data;

  final List<int> durations;
  final int type;

  const HistogramPlots(
      {super.key,
      required this.data,
      required this.durations,
      required this.type});

  @override
  Widget build(BuildContext context) {
    double maxData = data.reduce((a, b) => a > b ? a : b) * 1.2;

    List<double> dataFix = [];
    switch (type) {
      case (1):
        dataFix = data;
        break;
      case (2):
        dataFix = data.reversed.toList();
        break;
      case (3):
        var axiList = [...data];
        for (var i = 0; i < data.length; i++) {
          double maximo = axiList.first;
          for (int j = 1; j < axiList.length; j++) {
            if (axiList[j] > maximo) maximo = axiList[j];
          }

          if (i.isOdd) {
            dataFix.add(maximo);
          } else {
            dataFix.insert(0, maximo);
          }
          axiList.remove(maximo);
        }

        break;
      default:
        dataFix = data;
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          swapAnimationCurve: Curves.easeIn,
          swapAnimationDuration: const Duration(seconds: 5),
          BarChartData(
            minY: 0,
            maxY: maxData,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                fitInsideVertically: true,
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 2,
                  getTooltipItem: (BarChartGroupData group, int groupIndex,
                      BarChartRodData rod, int rodIndex) {
                    return BarTooltipItem(
                        rod.toY.toString(),
                        const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.black));
                  }),
            ),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: maxData / 6,
            ),
            borderData: FlBorderData(
                border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                    right: BorderSide.none,
                    top: BorderSide.none)),
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(
                axisNameWidget: Text("Tiempo (Min)"),
              ),
            ),
            barGroups: [
              ...durations.asMap().entries.map((e) => BarChartGroupData(
                    x: e.value,
                    barRods: [
                      BarChartRodData(
                          toY: dataFix[e.key],
                          borderRadius: BorderRadius.zero,
                          width: 200 / durations.length
                      )
                    ],

                  )),
            ],
          ),
        ),
      ),
    );
  }
}
