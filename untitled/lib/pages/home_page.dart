import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bar_chart.dart';
import '../widgets/manual_InputPopup.dart';
import '../widgets/notification_popup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current time
    DateTime now = DateTime.now();

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
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: Image.asset(
                        'lib/assets/waterBottle.png',
                        fit: BoxFit.cover,
                      ),
                    )

                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Today’s Water Input: 20ml",
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.02,
                    child: LinearProgressIndicator(
                      value: 0.55,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A698E)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'You got 55% of today’s goal, keep it going!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF4a8bb1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 300, // Set height for the chart container
                    child: const MyBarChart(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
