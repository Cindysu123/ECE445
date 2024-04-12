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
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;

  List<Widget> get _pages => [
    _isLoggedIn ? HomePage(username: _userData?['username'] ?? 'user2') : const HomePage(),
    TrendPage(username: _userData?['username'] ?? 'user2'),
    const LocationPage(),
    SettingsPage(userData: _userData),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _login(Map<String, dynamic> userData) {
    setState(() {
      _isLoggedIn = true;
      _userData = userData; // Save the user data
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _isLoggedIn ? _pages.elementAt(_selectedIndex) : LoginPage(onLoginSuccess: _login),
        ),
        bottomNavigationBar: _isLoggedIn ? BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trend'),
              BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ) : null,
      ),
    );
  }
}