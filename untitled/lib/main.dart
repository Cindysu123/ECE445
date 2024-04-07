import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/trend_page.dart';
import 'pages/location_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // Track login state

  // Adjust your pages based on whether the user is logged in
  List<Widget> get _pages => _isLoggedIn
      ? [
    const HomePage(),
    const TrendPage(),
    const LocationPage(),
    const SettingsPage(),
  ]
      : [const LoginPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _login() {
    setState(() {
      _isLoggedIn = true; // Update based on actual login logic
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MaterialApp as a top-level wrapper for MaterialApp to control the navigation from anywhere
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex), // Display the current page
        ),
        bottomNavigationBar: _isLoggedIn // Show navigation bar only if logged in
            ? BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trend'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        )
            : null,
      ),
    );
  }
}