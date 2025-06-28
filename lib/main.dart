import 'drug_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(PaedsDosingApp());
}

class PaedsDosingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paeds Dosing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  String age = '';
  String weight = '';
  String ageUnit = 'months';
  bool isPreterm = false;
  String gestationalAge = '';

  final _decimalInputFormatter =
  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [_decimalInputFormatter],
                decoration: InputDecoration(labelText: 'Age'),
                onChanged: (val) => age = val,
              ),
              DropdownButtonFormField<String>(
                value: ageUnit,
                items: ['days', 'months', 'years']
                    .map((unit) =>
                    DropdownMenuItem(value: unit, child: Text(unit)))
                    .toList(),
                onChanged: (val) {
                  setState(() => ageUnit = val!);
                },
                decoration: InputDecoration(labelText: 'Age Unit'),
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [_decimalInputFormatter],
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                onChanged: (val) => weight = val,
              ),
              CheckboxListTile(
                title: Text('Pre-term neonate?'),
                value: isPreterm,
                onChanged: (val) {
                  setState(() => isPreterm = val!);
                },
              ),
              if (isPreterm)
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [_decimalInputFormatter],
                  decoration:
                  InputDecoration(labelText: 'Gestational Age (weeks)'),
                  onChanged: (val) => gestationalAge = val,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrugSelectionScreen(
                        age: age,
                        weight: weight,
                        ageUnit: ageUnit,
                        gestAge: isPreterm ? gestationalAge : null,
                      ),
                    ),
                  );
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
