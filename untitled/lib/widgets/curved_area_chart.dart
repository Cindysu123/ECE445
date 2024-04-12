import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurvedAreaChart extends StatefulWidget {
  final String username;
  final DateTime startDate;
  final DateTime endDate;
  const CurvedAreaChart({
    Key? key,
    required this.username,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<CurvedAreaChart> createState() => _CurvedAreaChartState();
}

class _CurvedAreaChartState extends State<CurvedAreaChart> {
  Future<List<FlSpot>> fetchWaterIntakeSpots() async {
    final String startDateStr = widget.startDate.toIso8601String();
    final String endDateStr = widget.endDate.toIso8601String();

    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3001/api/water_intake_range/${widget.username}?start_date=$startDateStr&end_date=$endDateStr')
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<FlSpot> spots = [];
        for (var entry in jsonResponse) {
          final totalDailyIntake = int.tryParse(entry['total_daily_intake'].toString()) ?? 0;
          final date = DateTime.parse(entry['date']);
          final difference = date.difference(widget.startDate).inDays;
          spots.add(FlSpot(difference.toDouble(), totalDailyIntake.toDouble()));
        }
        return spots;
      } else {
        // print('Server responded with error status: ${response.statusCode}');
        throw Exception('Failed to load water intake data');
      }
    } catch (e) {
      // print('Error fetching water intake data: $e');
      return List.generate(widget.endDate.difference(widget.startDate).inDays + 1, (index) => FlSpot(index.toDouble(), 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: fetchWaterIntakeSpots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error fetching data');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        } else {
          final List<FlSpot> spots = snapshot.data!;
          return Expanded(
            child: Container(
              height: 600,
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
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
                      getTextStyles: (context, value) => const TextStyle(
                        color: Color(0xFF4A8BB1),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      getTitles: (value) {
                        final date = DateTime(2024, 02, 04).add(Duration(days: value.toInt()));
                        // Return the label for each day
                        return '${date.month}/${date.day}';
                      },
                      margin: 8,
                      interval: 1, // Set interval to 1 to show every label
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
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 200,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: const Color(0xFF4A8BB1),
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final date = DateTime(2024, 02, 04).add(Duration(days: touchedSpot.x.toInt()));
                          const textStyle = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          );
                          return LineTooltipItem('${date.month}/${date.day}, ${touchedSpot.y} ml', textStyle);
                        }).toList();
                      },
                    ),
                    touchCallback: (LineTouchResponse touchResponse) {},
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}