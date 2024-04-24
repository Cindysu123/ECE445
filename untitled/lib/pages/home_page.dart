import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bar_chart.dart';
import '../widgets/manual_InputPopup.dart';
// import '../widgets/notification_popup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

// Adjust the layout
// Implement Add Manual Input Function
// Implement Notification

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, this.username = 'user2'});

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showDrinkWaterNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'water_intake_id', 'Water Intake Reminder',
      channelDescription: 'Reminder to drink water',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Time to Drink Water',
      'Take a moment to hydrate yourself!',
      platformChannelSpecifics,
    );
  }

  Future<int> getTotalWaterIntakeForDate(String username, String date) async {
    final response = await http.get(
      Uri.parse('http://3.95.55.44:3001/api/water_intake/$username/$date'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return int.parse(data['total_water_intake'].toString());
    } else {
      throw Exception('Failed to load water intake');
    }
  }

  Future<List<int>> getWaterIntakeForChart(String username, String date) async {
    final response = await http.get(
      Uri.parse('http://3.95.55.44:3001/api/water_intake_time_blocks/$username/$date'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => int.parse(e.toString())).toList(); // Converts all entries to integers
    } else {
      throw Exception('Failed to load water intake data for chart');
    }
  }

  Future<List<dynamic>> fetchData(String username, String date) async {
    final Uri waterIntakeUri = Uri.parse('http://3.95.55.44:3001/api/water_intake/$username/$date');
    final Uri dailyGoalUri = Uri.parse('http://3.95.55.44:3001/api/latest_user_water_intake/$username');

    final Future<dynamic> waterIntakeFuture = http.get(waterIntakeUri).then((response) {
      if (response.statusCode == 200) {
        return double.parse(jsonDecode(response.body)['total_water_intake'].toString()); // Explicitly parse as double
      } else {
        throw Exception('Failed to load water intake');
      }
    });

    final Future<dynamic> dailyGoalFuture = http.get(dailyGoalUri).then((response) {
      if (response.statusCode == 200) {
        return double.parse(jsonDecode(response.body)['daily_water_intake'].toString()); // Ensure this is a double
      } else {
        throw Exception('Failed to load user water intake goal');
      }
    });

    return Future.wait([dailyGoalFuture, waterIntakeFuture]);
  }

  Future<double> getUserWaterIntakeGoal(String username) async {
    final response = await http.get(
      Uri.parse('http://3.95.55.44:3001/api/latest_user_water_intake/$username'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['daily_water_intake'].toString()); // Ensure conversion to double
    } else {
      throw Exception('Failed to load user water intake goal');
    }
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DateTime cstTime = now.toUtc().subtract(const Duration(hours: 5));

    String formattedTime = DateFormat('HH:mm').format(cstTime);

    void showDrinkWaterNotification(BuildContext context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Time to drink water!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
          ),
          FutureBuilder<List<dynamic>>(
            future: fetchData(username, today),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final double waterGoal = snapshot.data?[0] ?? 2000.0; // Default goal
                final double waterIntake = snapshot.data?[1]?.toDouble() ?? 0.0; // Ensure this is a double
                double rectangleHeight = (waterGoal - waterIntake) / waterGoal * MediaQuery.of(context).size.height * (1.5 / 3);

                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * (0.7 / 3),
                      child: Container(
                        width: 180,
                        height: rectangleHeight,
                        color: const Color(0xFF4a8bb1).withOpacity(0.5),
                        alignment: Alignment.center,
                        child: Text(
                          "${waterIntake}ml Drink",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * (0.4 / 3),
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
                    SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 700),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20),
                              height: 300,
                              // Set height for the chart container
                              child: FutureBuilder<List<int>>(
                                future: getWaterIntakeForChart(username, today),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Text('No data available');
                                  } else {
                                    // Data is available and non-empty
                                    List<int> waterIntakeData = snapshot.data!;
                                    return MyBarChart(waterIntakeData: waterIntakeData);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * (2.4 / 3),
                        child: Container(
                            padding: const EdgeInsets.only(
                                top: 55, bottom: 0.0, left: 330),
                            margin: EdgeInsets.zero,
                            child: IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () =>
                                  showDrinkWaterNotification(context),
                              tooltip: 'Drink Water Notification',
                            )
                        )
                    ),
                    Positioned(
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * (2.2 / 3),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 20.0),
                          child: Text(
                            formattedTime,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF2A698E),
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    ),
                    Positioned(
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * (0.4 / 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Today’s Water Input: $waterIntake",
                            // "Today’s Water Input: ${20}",
                            style: const TextStyle(
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
                                  // Pass the username to ManualInputPopup
                                  return ManualInputPopup(
                                      username: username);
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
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * (0.3 / 3),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                        child: LinearProgressIndicator(
                          value: waterIntake / waterGoal, // Both should be doubles
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A698E)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * (0.2 / 3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'You got ${(waterIntake / waterGoal * 100).toStringAsFixed(2)}% of today’s goal, keep it going!',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFF4a8bb1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
