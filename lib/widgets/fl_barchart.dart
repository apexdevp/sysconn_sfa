import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FlBarChartWidget extends StatelessWidget {
  final List<String> xAxisData;
  final List<double> yAxisData;
  final TextStyle textStyle;
  // final Color barColor;
  final double barWidth;

  const FlBarChartWidget({
    super.key,
    required this.xAxisData,
    required this.yAxisData,
    required this.textStyle,
    // this.barColor = Colors.cyan,
    this.barWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (xAxisData.isEmpty || yAxisData.isEmpty) {
      return const Center(child: Text('No Data'));
    }

    double maxY = yAxisData.reduce((a, b) => a > b ? a : b);
    double interval = maxY > 10 ? (maxY / 4).ceilToDouble() : 1;
    int adjustedMaxY = ((maxY / interval).ceil() * interval).toInt();

    return BarChart(
      BarChartData(
        maxY: adjustedMaxY.toDouble(),
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1),
            left: BorderSide(color: Colors.black, width: 1),
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) {
              return Colors.white;
            },
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${xAxisData[group.x]}: ${rod.toY.toInt()}',
                textStyle.copyWith(fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(xAxisData[index], style: textStyle),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  space: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 10.0),
                    child: Text(meta.formattedValue,
                        style: textStyle, textAlign: TextAlign.right),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: List.generate(
          yAxisData.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: yAxisData[i],
                color: Colors.grey,
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   colors: [Colors.blue.shade200, Colors.blue.shade700],
                // ),
                width: barWidth,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
