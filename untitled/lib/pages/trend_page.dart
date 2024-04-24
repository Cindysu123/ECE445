import 'package:flutter/material.dart';
import '../widgets/curved_area_chart.dart';

class TrendPage extends StatefulWidget {
  final String username;
  const TrendPage({super.key, this.username= 'user2'});

  @override
  State<TrendPage> createState(){
    return _TrendPageState();
  }
}

class _TrendPageState extends State<TrendPage> {
  int selectedIndex = 0; // By default, the first one is selected
  DateTime startDate = DateTime(2024, 02, 04); // Week start date
  DateTime endDate = DateTime(2024, 02, 10); // Week end date
  void updateDateRange(int index) {
    DateTime start;
    DateTime end;
    // Update the range based on the index
    if (index == 0) {
      start = DateTime(2024, 02, 04);
      end = DateTime(2024, 02, 10);
    } else if (index == 1) {
      start = DateTime(2024, 02, 01);
      end = DateTime(2024, 02, 28); // Adjust for correct number of days in February
    } else if (index == 2) {
      start = DateTime(2024, 01, 01);
      end = DateTime(2024, 12, 31);
    } else {
      return; // If the index is out of range, do nothing
    }
    setState(() {
      selectedIndex = index;
      startDate = start;
      endDate = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column( // Use Column for vertical layout
          mainAxisAlignment: MainAxisAlignment.center, // Center the column
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 40),
                child: Text(
                    'Water Intake Trend',
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Wrap each Text in a FlatButton or TextButton
                for (int index = 0; index < 3; index++)
                  TextButton(
                    style: TextButton.styleFrom(
                      // Check if the button is selected
                      foregroundColor: selectedIndex == index ? Colors.white : const Color(0xFF2A698E),
                      backgroundColor: selectedIndex == index ? const Color(0xFF2A698E) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: const BorderSide(color: Color(0xFF2A698E)),
                      ),
                    ),
                    onPressed: () {
                      updateDateRange(index); // Call the function to update the date range
                    },
                    child: Text(
                      // Assign the text based on index
                      ['Week', 'Month', 'Year'][index],
                    ),
                  ),
              ],
            ),
            Text("${startDate.year}/${startDate.month}/${startDate.day} to ${startDate.year}/${endDate.month}/${endDate.day}"),
            CurvedAreaChart(
                key: ValueKey("$startDate to $endDate"), // Use the date range as the ValueKey
                username: widget.username,
                startDate: startDate,
                endDate: endDate
            )
          ],
        ),
      ),
    );
  }
}