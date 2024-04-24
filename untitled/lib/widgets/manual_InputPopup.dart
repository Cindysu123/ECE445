import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ManualInputPopup extends StatefulWidget {
  final String username;
  const ManualInputPopup({super.key, required this.username});

  @override
  State<ManualInputPopup> createState() => _ManualInputPopupState();
}

class _ManualInputPopupState extends State<ManualInputPopup> {
  double _currentSliderValue = 250;
  Future<void> addWaterIntake() async {
    DateTime now = DateTime.now();
    DateTime cstTime = now.toUtc().subtract(const Duration(hours: 5));
    String intakeTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(cstTime);

    var url = Uri.parse('http://3.95.55.44:3001/api/water_intake');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': widget.username,
        'intake_timestamp': intakeTimestamp,
        'water_amount_ml': _currentSliderValue.round(),
      }),
    );

    if (response.statusCode == 200) {
      print('Server responded with success');
      Navigator.pop(context);
    } else {
      print('Failed to add water intake');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Add Manual Input for ${widget.username}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF4A8BB1),
                  fontWeight: FontWeight.bold
              ),
            ),
            const Text(
              'Add Manual Input',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF4A8BB1),
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_currentSliderValue.round()} ml',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF4A8BB1)),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF4A8BB1),
                inactiveTrackColor: const Color(0xFF4A8BB1).withOpacity(0.5),
                thumbColor: Colors.white,
                overlayColor: const Color(0xFF4A8BB1).withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
              ),
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 500,
                divisions: 500,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4a8bb1),
              ),
              onPressed: addWaterIntake,
              child: const Text('Add Input'),
            ),
          ],
        ),
      ),
    );
  }
}