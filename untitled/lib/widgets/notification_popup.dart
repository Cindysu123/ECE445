import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the size of the current screen
    final Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onClose,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color(0x002A698E),
        child: Stack(
          children: [
            Positioned(
              top: 60,
              right: 40,
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: screenSize.width * 0.6,
                          height: screenSize.height * 0.1,
                          child: Column(
                              children: const [
                                Text(
                                    "1:30pm",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFFA6A6A6)
                                    )
                                ),
                                Text(
                                    "You have 5min left from reaching your next drinking goal today",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xFF214458)
                                    )
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
