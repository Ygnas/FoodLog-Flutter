import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListingBarChart extends StatelessWidget {
  const ListingBarChart({
    super.key,
    required this.maxItemCount,
    required this.showingBarGroups,
    required this.bottomTitles,
  });

  final int maxItemCount;
  final List<BarChartGroupData> showingBarGroups;
  final Widget Function(double, TitleMeta) bottomTitles;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BarChart(
        BarChartData(
          maxY: maxItemCount.toDouble(),
          barGroups: showingBarGroups,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 42,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 28,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
