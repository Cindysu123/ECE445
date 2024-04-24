import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarChart extends StatelessWidget {
  final List<int> waterIntakeData;

  const MyBarChart({Key? key, required this.waterIntakeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = screenWidth * 0.9;
    final int maxY = waterIntakeData.isNotEmpty ? waterIntakeData.reduce((a, b) => a > b ? a : b) : 0;
    final int interval = maxY > 0 ? (maxY ~/ 5) + 1 : 1;

    return Container(
      width: chartWidth,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Set white color with 90% opacity
        borderRadius: BorderRadius.circular(8), // Optional: Adds rounded corners to the chart background
      ),
      padding: const EdgeInsets.all(8), // Optional: Adds padding inside the container
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY.toDouble(),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold, fontSize: 10),
              margin: 10,
              getTitles: (double value) {
                final labels = ['10am','12pm', '2pm', '4pm', '6pm', '8pm', '10pm'];
                return labels[value.toInt()];
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold, fontSize: 10),
              margin: 8,
              reservedSize: 28,
              interval: interval.toDouble(),
              getTitles: (value) => value % interval == 0 ? '${value.toInt()}ml' : '',
            ),
          ),
          barGroups: List.generate(
            waterIntakeData.length,
                (index) => BarChartGroupData(
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


