import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './login_page.dart';

class WaterIntakePage extends StatelessWidget {
  final String username;
  final String password;
  final String gender;
  final int age;
  final double weight;
  final int activityLevel;

  const WaterIntakePage({
    Key? key,
    required this.username,
    required this.password,
    required this.gender,
    required this.age,
    required this.weight,
    required this.activityLevel,
  }) : super(key: key);

  Future<void> finishSignUp(BuildContext context) async {
    double waterIntake = calculateWaterIntake();
    var url = Uri.parse('http://3.95.55.44:3001/api/signup');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'username': username,
        'gender': gender == 'Male' ? 0 : 1,
        'age': age,
        'weight': weight,
        'physical_activity': activityLevel,
        'password': password,
        'daily_water_intake': waterIntake,
      }),
    );

    if (response.statusCode == 200) {
      // Navigate to the login page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(onLoginSuccess: (userData) {
            // You might want to handle user data here or navigate to another page.
            // For example, you might set user data in state and update the UI.
            print("User logged in successfully.");
          }),
        ),
            (Route<dynamic> route) => false,
      );
    } else {
      // Display error message from server if available, otherwise a generic message
      var message = 'Failed to create user. Please try again.';
      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body);
        message = data['message'] ?? message; // Use server-provided message if available
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Failed'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double waterIntake = calculateWaterIntake();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFafcfe4)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hello, $username! Based on your profile, you should drink approximately ${waterIntake.toStringAsFixed(2)} ml of water daily.',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => finishSignUp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text('Finish Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double calculateWaterIntake() {
    double baseWaterIntake = 35.0 * weight;

    if (activityLevel == 2) {
      baseWaterIntake *= 1.2;
    } else if (activityLevel == 3) {
      baseWaterIntake *= 1.5;
    }

    if (gender == 'Male') {
      baseWaterIntake *= 1.1;
    }

    if (age < 18) {
      baseWaterIntake *= 0.9;
    } else if (age > 50) {
      baseWaterIntake *= 0.95;
    }
    return baseWaterIntake;
  }
}