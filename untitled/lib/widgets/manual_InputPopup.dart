
import 'package:flutter/material.dart';

class ManualInputPopup extends StatefulWidget {
  const ManualInputPopup({super.key});

  @override
  State<ManualInputPopup> createState(){
    return _ManualInputPopupState();
  }
}

class _ManualInputPopupState extends State<ManualInputPopup> {
  double _currentSliderValue = 250;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
              child: const Text('Add Input'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}