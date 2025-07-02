import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScoreFrequencyChart extends StatelessWidget {
  final Map<int, int> scoreFrequency;

  const ScoreFrequencyChart({super.key, required this.scoreFrequency});

  @override
  Widget build(BuildContext context) {
    // Convert map entries to spots (x = score, y = frequency)
    final List<FlSpot> spots =
        scoreFrequency.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
            .toList()
          ..sort((a, b) => a.x.compareTo(b.x)); // sort by score

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical! * 2),
          child: AspectRatio(
            aspectRatio: 1.4, // Responsive layout
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 1,
                    color: Color(blueColor),
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minX: spots.first.x,
                maxX: spots.last.x,
                minY: 0,
                maxY:
                    (scoreFrequency.values.reduce((a, b) => a > b ? a : b) + 2)
                        .toDouble(), // Add padding above max frequency
              ),
            ),
          ),
        );
      },
    );
  }
}
