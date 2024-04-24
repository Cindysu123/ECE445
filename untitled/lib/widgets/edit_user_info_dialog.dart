import 'package:flutter/material.dart';

class EditUserInfoDialog extends StatefulWidget {
  const EditUserInfoDialog({super.key});

  @override
  State<EditUserInfoDialog> createState() {
    return _EditUserInfoDialogState();
  }
}

class _EditUserInfoDialogState extends State<EditUserInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _gender = 'Male';
  String _weight = '';
  String _activityLevel = 'Non-active';
  String _age = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User Info'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _userName,
                decoration: const InputDecoration(labelText: 'User Name'),
                onSaved: (value) => _userName = value!,
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _gender = value!),
              ),
              TextFormField(
                initialValue: _weight,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = value!,
              ),
              TextFormField(
                initialValue: _age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) => _age = value!,
              ),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                decoration: const InputDecoration(labelText: 'Activity Level'),
                items: ['Non-active', 'Active', 'Athletic'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _activityLevel = value!),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
              'Cancel',
            style: TextStyle(
              color: Color(0xFF2A698E)
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text(
              'Save',
            style: TextStyle(
              color: Color(0xFF2A698E)
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}