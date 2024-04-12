import 'package:flutter/material.dart';
import './water_intake_page.dart';

class PersonalInfoPage extends StatefulWidget {
  final String username;
  final String password;

  PersonalInfoPage({Key? key, required this.username, required this.password}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String gender = 'Male';
  int activityLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFafd0e5)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '👤 About You:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2A698E)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please provide the following information to calculate your daily water intake.',
                      style: TextStyle(fontSize: 18, color: Color(0xFF2A698E)),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: gender,
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'Age (years)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Physical Activity Level:",
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(width: 10),  // Add some spacing
                        Expanded(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: activityLevel,
                            onChanged: (int? newValue) {
                              setState(() {
                                activityLevel = newValue!;
                              });
                            },
                            items: <int>[1, 2, 3]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            underline: Container(
                              height: 1,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Collect all data and navigate to WaterIntakePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterIntakePage(
                              username: widget.username,
                              password: widget.password,
                              gender: gender,
                              age: int.parse(ageController.text),
                              weight: double.parse(weightController.text),
                              activityLevel: activityLevel,
                            ),
                          ),
                        );
                      },
                      child: Text('Calculate My Daily Water Intake'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}