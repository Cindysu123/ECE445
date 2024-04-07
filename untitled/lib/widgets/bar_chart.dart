import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarChart extends StatelessWidget {
  const MyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate chart size
    final chartWidth = screenWidth * 0.9;

    return SizedBox(
      width: chartWidth,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 40,
          minY: 0,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
              drawHorizontalLine: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
              verticalInterval: 1
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold),
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return '10am';
                  case 1:
                    return '12pm';
                  case 2:
                    return '2pm';
                  case 3:
                    return '4pm';
                  case 4:
                    return '6pm';
                  case 5:
                    return '8pm';
                  case 6:
                    return '10pm';
                  default:
                    return '';
                }
              },
              margin: 1,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 0:
                    return '0ml';
                  case 10:
                    return '10ml';
                  case 20:
                    return '20ml';
                  case 30:
                    return '30ml';
                  case 40:
                    return '40ml';
                  default:
                    return '';
                }
              },
              margin: 16,
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 35, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 35, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 35, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 35, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(y: 15, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 5, barRods: [BarChartRodData(y: 35, colors: [const Color(0xFF2a698e)], width: 20)]),
            BarChartGroupData(x: 6, barRods: [BarChartRodData(y: 30, colors: [const Color(0xFF2a698e)], width: 20)]),
          ],
        ),
      ),
    );
  }
}