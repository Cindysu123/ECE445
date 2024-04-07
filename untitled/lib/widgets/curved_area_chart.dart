import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CurvedAreaChart extends StatelessWidget {
  const CurvedAreaChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Increased height of the chart
      padding: const EdgeInsets.all(16), // Add some padding around
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(2, 100),
                FlSpot(8, 120),
                FlSpot(13, 80),
                FlSpot(18, 160),
                FlSpot(23, 90),
                FlSpot(29, 100),
              ],
              isCurved: true,
              colors: [const Color(0xFFFFFFFF)],
              dotData: FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  const Color(0xFF7db4d5).withOpacity(0.8),
                  const Color(0xFFcae5f5).withOpacity(0.8)
                ],
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 2:
                    return '2/2';
                  case 8:
                    return '2/8';
                  case 13:
                    return '2/13';
                  case 18:
                    return '2/18';
                  case 23:
                    return '2/23';
                  case 29:
                    return '2/29';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(color: Color(0xFF4A8BB1), fontWeight: FontWeight.bold),
              getTitles: (value) {
                if (value % 10 == 0) {
                  return '${value.toInt()}';
                }
                return '';
              },
              margin: 8,
              reservedSize: 40,
            ),
          ),
          gridData: FlGridData(
              drawHorizontalLine: true,
              drawVerticalLine: true,
              horizontalInterval: 10,
              verticalInterval: 3
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: 29,
          minY: 0,
          maxY: 200,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: const Color(0xFF4A8BB1),
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  const textStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  );
                  return LineTooltipItem('2/${touchedSpot.x}, ${touchedSpot.y} ml', textStyle);
                }).toList();
              },
            ),
            touchCallback: (LineTouchResponse touchResponse) {},
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}