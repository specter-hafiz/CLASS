import 'package:class_app/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccuracyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> analytics;

  const AccuracyBarChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final barWidth = 20.0;
    final barSpacing = 20.0;
    final chartWidth = (barWidth + barSpacing) * analytics.length;

    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: BarChart(
            BarChartData(
              maxY: 100,
              barGroups: _buildBarGroups(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: _getBottomTitles,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final percentage = rod.toY.toStringAsFixed(1);
                    return BarTooltipItem(
                      "Q${group.x + 1}\n$percentage%",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(analytics.length, (index) {
      final item = analytics[index];
      final int correct = item['correctAnswers'] ?? 0;
      final int total = item['totalSubmissions'] ?? 1;
      final double percentage = (correct / total) * 100;

      final Color color =
          percentage >= 70
              ? const Color(blueColor)
              : (percentage >= 50 ? Colors.orange : Colors.red);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: percentage,
            color: color,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        barsSpace: 10, // This is spacing between rods in group (if any)
      );
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < analytics.length) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          "Q${index + 1}",
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
