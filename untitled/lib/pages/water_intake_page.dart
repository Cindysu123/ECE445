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

  WaterIntakePage({
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
    var url = Uri.parse('http://10.0.2.2:3001/api/signup');
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
      // Navigate to the login page and remove all previous routes
      // This is as close to a "restart" as we can get without actually restarting the app
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onLoginSuccess: (userData) {
          // Once the user logs in, this will execute. You can navigate to another route or perform other actions as needed.
          // Example: Navigate to the home screen
          // Navigator.pushReplacementNamed(context, '/home', arguments: userData);
        })),
            (Route<dynamic> route) => false, // This condition ensures all other routes are removed
      );
    } else {
      // Handle the case where the signup failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Signup Failed'),
            content: Text('Failed to create user. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
        decoration: BoxDecoration(
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
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => finishSignUp(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Button color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Text('Finish Sign Up'),
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
    double baseWaterIntake = 35.0 * weight; // 35 ml per kg as a base assumption
    if (activityLevel == 2) {
      baseWaterIntake *= 1.2; // 20% more for moderate activity
    } else if (activityLevel == 3) {
      baseWaterIntake *= 1.5; // 50% more for high activity
    }
    return baseWaterIntake;
  }
}