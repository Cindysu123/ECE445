import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bar_chart.dart';
import '../widgets/manual_InputPopup.dart';
import '../widgets/notification_popup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  final String username;
  const HomePage({super.key, this.username = 'user2'});

  Future<int> getTotalWaterIntakeForDate(String username, String date) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/api/water_intake/$username/$date'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Make sure this is an int by parsing it if necessary.
      return int.parse(data['total_water_intake'].toString());
    } else {
      // Handle the case where the server responds with an error.
      throw Exception('Failed to load water intake');
    }
  }

  Future<List<dynamic>> getWaterIntakeForChart(String username, String date) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3001/api/water_intake_chart/$username/$date'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load water intake data for chart');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current time
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Specify the CST time zone, UTC-6
    DateTime cstTime = now.toUtc().subtract(const Duration(hours: 6));

    // Format the time as a string to show only hours and minutes
    String formattedTime = DateFormat('HH:mm').format(cstTime);

    OverlayEntry? notificationOverlayEntry;

    void showNotificationPopup() {
      notificationOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 0, // Adjust the positioning as needed
          right: 0,
          child: NotificationPopup(
            onClose: () {
              notificationOverlayEntry?.remove();
            },
          ),
        ),
      );

      Overlay.of(context)?.insert(notificationOverlayEntry!);
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
          ),
          FutureBuilder<int>(
            future: getTotalWaterIntakeForDate(username, today),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                double waterGoal = 500.0;
                int waterIntake = snapshot.data ?? 0;
                // Calculate the height of the rectangle based on waterIntake
                double rectangleHeight = (waterIntake / waterGoal) * MediaQuery.of(context).size.height * (2 / 3); // Adjusted calculation

                return Stack(
                  alignment: Alignment.bottomCenter, // Align the rectangle to the bottom center
                  children: [
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * (0.7 / 3), // Positioning at 2/3 of the screen height
                      child: Container(
                        width: 180, // Fixed width for the rectangle
                        height: rectangleHeight, // Dynamic height based on water intake
                        color: Color(0xFF4a8bb1).withOpacity(0.5),
                        alignment: Alignment.center, // Align text to the center of the container
                        child: Text(
                          "${waterIntake}ml", // Display the water intake value
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).size.height * (0.4 / 3),
                        child: Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Image.asset(
                            'lib/assets/waterBottle.png',
                            fit: BoxFit.cover,
                            width: 200,
                          ),
                        )

                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * (0.4 / 3),
                      child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Today’s Water Input: ${waterIntake}",
                          // "Today’s Water Input: ${20}",
                          style: TextStyle(
                              color: Color(0xFF4a8bb1),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add_circle),
                          label: const Text("Add Manual Input"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ManualInputPopup();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4a8bb1),
                          ),
                        )
                      ],
                    ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * (0.3 / 3),
                      child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.02,
                      child: LinearProgressIndicator(
                        // value: waterIntake/500,
                        value: waterIntake/500,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A698E)),
                      ),
                    ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * (0.2 / 3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'You got ${waterIntake/500} of today’s goal, keep it going!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF4a8bb1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 55, bottom: 0.0, left:330),
                    margin: EdgeInsets.zero,
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: showNotificationPopup,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 20.0),
                    child: Text(
                      formattedTime,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2A698E),
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 500),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 300, // Set height for the chart container
                    child: FutureBuilder<List<dynamic>>(
                      future: getWaterIntakeForChart(username, today),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          // Assuming the data is fetched successfully and MyBarChart can handle List<dynamic>
                          List<dynamic> waterIntakeData = snapshot.data ?? [0,0,0,0,0,0,0];
                          return MyBarChart(
                            waterIntakeData: waterIntakeData.map((e) => int.parse(e['total_amount'].toString())).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
