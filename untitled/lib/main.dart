import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pages/home_page.dart';
import 'pages/trend_page.dart';
import 'pages/location_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;
  Timer? _timer;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _checkFlagStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkFlagStatus() async {
    // Check if the user is logged in before checking the flag status
    if (_isLoggedIn) {
      try {
        var response = await http.get(Uri.parse('http://3.95.55.44:3001/api/notification/user1'));
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['flag'] == 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _showFlagAlert();
              }
            });
          }
        }
      } catch (e) {
        print("Failed to fetch flag status: $e");
      }
    }
  }

  void _showFlagAlert() {
    if (navigatorKey.currentState != null) {
      showDialog(
        context: navigatorKey.currentState!.context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Notification'),
            content: const Text('Time to drink water'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

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
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,  // Use the global key for your navigator
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
          selectedItemColor: const Color(0xFF2a698e),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ) : null,
      ),
    );
  }
}