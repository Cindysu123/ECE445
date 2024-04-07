import 'package:flutter/material.dart';
import '../widgets/edit_user_info_dialog.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const SettingsPage({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default user data, adjust according to your needs or fetch from a local store
    final Map<String, dynamic> defaultUserData = {
      'username': 'Default User',
      'gender': 1, // Assuming 1 for Male, 0 for Female
      'age': 'Not set',
      'weight': 'Not set',
    };

    // Use userData if provided, otherwise fallback to defaultUserData
    final user = userData ?? defaultUserData;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFF69A8CD)], // Adjusted for visibility
          ),
        ),
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column( // Changed from Center to Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20), // Padding inside the container
                  margin: const EdgeInsets.all(10), // Margin outside the container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Optional: to add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Container size fits the content
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 0, bottom: 0.0, left:300), // Ensure no padding is applied
                        margin: EdgeInsets.zero,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const EditUserInfoDialog();
                              },
                            );
                          },
                        )
                      ),
                      Image.asset('lib/assets/Profile.png'),
                      const SizedBox(height: 10), // Spacing between image and text
                      Text(user['username']),
                      const SizedBox(height: 10), // Spacing between items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Gender: '),
                          Text(user['gender'] == 0 ? 'Female' : 'Male'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Age: '),
                          Text('${user['age']}'),
                        ],
                      ),
                      const SizedBox(height: 10), // Spacing between items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Weight: '),
                          Text('${user['weight']}kg'),
                        ],
                      ),
                      const SizedBox(height: 10), // Spacing between items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Activity Level: '),
                          Text('Active'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20), // Padding inside the container
                  margin: const EdgeInsets.all(10), // Margin outside the container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Optional: to add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column( // Added the child property for Column
                    mainAxisSize: MainAxisSize.min, // Container size fits the content
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline_rounded),
                          SizedBox(width: 10), // Added for spacing
                          Text('In Progress'),
                          SizedBox(width: 10), // Added for spacing
                          Text('Change My Goal'),
                        ],
                      ),
                      const SizedBox(height: 10), // Added for spacing between rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('80 Days Streak'),
                          SizedBox(width: 10), // Added for spacing
                          Text('30/80'),
                        ],
                      ),
                      const SizedBox(height: 10), // Added for spacing before the progress bar
                      LinearProgressIndicator(
                        value: 0.375, // Adjusted the value to match 30/80 days
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2A698E)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20), // Padding inside the container
                  margin: const EdgeInsets.all(10), // Margin outside the container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Optional: to add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column( // Added the child property for Column
                    mainAxisSize: MainAxisSize.min, // Container size fits the content
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.auto_awesome_rounded),
                          SizedBox(width: 10), // Added for spacing
                          Text('Achievements'),
                        ],
                      ),
                      const SizedBox(height: 10), // Added for spacing between rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/assets/achieve1.png'),
                          const SizedBox(width: 15),
                          Image.asset('lib/assets/achieve2.png'),
                          const SizedBox(width: 15),
                          Image.asset('lib/assets/achieve3.png')
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}