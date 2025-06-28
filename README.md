# paedsdosingsa

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
import 'package:flutter/material.dart';

void main() {
runApp(PaedsDosingApp());
}

class PaedsDosingApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Paeds Dosing App',
theme: ThemeData(
primarySwatch: Colors.teal,
),
home: InputScreen(),
);
}
}

class InputScreen extends StatefulWidget {
@override
_InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
final _formKey = GlobalKey<FormState>();

String _age = '';
String _ageUnit = 'months';
String _weight = '';
String _gestAge = '';

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Enter Patient Info'),
),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Form(
key: _formKey,
child: ListView(
children: [

              // Age input
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _age = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter age' : null,
              ),

              // Age unit dropdown
              DropdownButtonFormField<String>(
                value: _ageUnit,
                decoration: InputDecoration(labelText: 'Age Unit'),
                items: ['days', 'months', 'years']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _ageUnit = value!),
              ),

              // Weight input
              TextFormField(
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _weight = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter weight' : null,
              ),

              // Gestational Age input (optional)
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Gestational Age (weeks, optional)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _gestAge = value,
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Show a summary popup
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Input Received'),
                        content: Text(
                          'Age: $_age $_ageUnit\n'
                          'Weight: $_weight kg\n'
                          'Gestational Age: $_gestAge weeks',
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );.
