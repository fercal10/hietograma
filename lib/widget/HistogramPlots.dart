import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistogramPlots extends StatefulWidget {
  final List<double> data;

  final List<int> durations;
  final int type;
  final void Function(double n)? showRain;

  const HistogramPlots(
      {super.key,
      this.showRain,
      required this.data,
      required this.durations,
      required this.type});

  @override
  State<HistogramPlots> createState() => _HistogramPlotsState();
}

class _HistogramPlotsState extends State<HistogramPlots> {
  @override
  Widget build(BuildContext context) {
    double maxData = widget.data.reduce((a, b) => a > b ? a : b);

    List<double> dataFix = [];
    switch (widget.type) {
      case (1):
        dataFix = widget.data;
        break;
      case (2):
        dataFix = widget.data.reversed.toList();
        break;
      case (3):
        var axiList = [...widget.data];
        for (var i = 0; i < widget.data.length; i++) {
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
        dataFix = widget.data;
    }

    Widget leftTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      String text = value.toInt().toString();

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(text, style: style),
      );
    }

    Widget bottomTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      String text = value.toInt().toString();

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(text, style: style),
      );
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
            maxY: maxData * 1.2,
            barTouchData: BarTouchData(
              touchCallback: (FlTouchEvent touch, BarTouchResponse? valor) {
                if (valor != null &&
                    valor.spot != null &&
                    valor.spot?.touchedRodData != null &&
                    valor.spot?.touchedRodData.toY != null) {
                  widget.showRain!(valor.spot!.touchedRodData.toY);
                }
              },
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
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                // sideTitles: SideTitles(showTitles: false),
                axisNameWidget: Text("Intensidad (Min)"),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: maxData / 4,
                  getTitlesWidget: leftTitles,
                ),
              ),
              topTitles: const AxisTitles(
                axisNameWidget: Text("Tiempo (Min)"),
              ),
              bottomTitles: AxisTitles(
                sideTitles:
                    SideTitles(showTitles: widget.durations.length < 16),
              ),
            ),
            barGroups: [
              ...widget.durations.asMap().entries.map((e) => BarChartGroupData(
                    x: e.value,
                    barRods: [
                      BarChartRodData(
                          toY: dataFix[e.key],
                          borderRadius: BorderRadius.zero,
                          width: 200 / widget.durations.length)
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
