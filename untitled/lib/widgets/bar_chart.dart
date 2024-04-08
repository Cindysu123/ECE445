import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarChart extends StatelessWidget {
  final List<int> waterIntakeData;

  const MyBarChart({Key? key, this.waterIntakeData = const [0, 0, 0, 0, 0, 0, 0]})
      : super(key: key);

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
          backgroundColor: Colors.white,
          alignment: BarChartAlignment.spaceAround,
          maxY: 40,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: false,
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            ),
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold, fontSize: 10),
              margin: 10,
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
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold, fontSize: 10),
              margin: 8,
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
            ),
          ),
          barGroups: List.generate(waterIntakeData.length, (index) =>
              BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    y: waterIntakeData[index].toDouble(),
                    colors: [const Color(0xFF2a698e)],
                    width: 20,
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}