import 'package:flutter/material.dart';
import 'drug_data_loader.dart';

class ResultScreen extends StatefulWidget {
  final String drug;
  final String age;
  final String weight;
  final String ageUnit;
  final String? gestAge;

  ResultScreen({
    required this.drug,
    required this.age,
    required this.weight,
    required this.ageUnit,
    this.gestAge,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Drug? _match;
  double? _finalDose;

  @override
  void initState() {
    super.initState();
    _loadDose();
  }

  Future<void> _loadDose() async {
    final drugs = await loadDrugsFromJson();
    final match = drugs.firstWhere(
          (d) => d.name.toLowerCase() == widget.drug.toLowerCase(),
      orElse: () => Drug(
        name: widget.drug,
        indication: 'Unknown',
        doseMgPerKg: 0,
        frequency: '',
        maxSingleDoseMg: 0,
        formula: '',
        route: '',
        maxDoseNote: '',
        warnings: [],
      ),
    );

    final weightKg = double.tryParse(widget.weight) ?? 0;
    final dose = weightKg * match.doseMgPerKg;
    final finalDose = dose > match.maxSingleDoseMg ? match.maxSingleDoseMg : dose;

    setState(() {
      _match = match;
      _finalDose = finalDose;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_match == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Dose for ${widget.drug}')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dose for ${_match!.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Drug: ${_match!.name}", style: TextStyle(fontSize: 18)),
              Text("Indication: ${_match!.indication}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("Age: ${widget.age} ${widget.ageUnit}", style: TextStyle(fontSize: 18)),
              Text("Weight: ${widget.weight} kg", style: TextStyle(fontSize: 18)),
              if (widget.gestAge != null)
                Text("Gestational Age: ${widget.gestAge} weeks", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text("Recommended Dose:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                "${_finalDose?.toStringAsFixed(1) ?? '---'} mg per dose, ${_match!.frequency}",
                style: TextStyle(fontSize: 18),
              ),
              Text("Formula: ${_match!.formula}", style: TextStyle(fontSize: 18)),
              Text("Route: ${_match!.route}", style: TextStyle(fontSize: 18)),
              Text("Max: ${_match!.maxSingleDoseMg} mg (${_match!.maxDoseNote})", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              if (_match!.warnings.isNotEmpty)
                ..._match!.warnings.map((w) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    w,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
