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
  // Variable to keep track of the selected index
  int selectedIndex = 0; // By default, the first one is selected

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
                      foregroundColor: selectedIndex == index ? Colors.white : const Color(0xFF2A698E), backgroundColor: selectedIndex == index ? const Color(0xFF2A698E) : Colors.white, // This is for text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: const BorderSide(color: Color(0xFF2A698E)),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedIndex = index; // Update the selected index
                      });
                    },
                    child: Text(
                      // Assign the text based on index
                      ['Week', 'Month', 'Year'][index],
                    ),
                  ),
              ],
            ),
            const Text('2/2/24 - 2/29/24 >'),
            CurvedAreaChart(username: widget.username)
          ],
        ),
      ),
    );
  }
}