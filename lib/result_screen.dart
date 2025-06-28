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
  String _doseInfo = 'Loading...';

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
      ),
    );

    if (match.doseMgPerKg == 0) {
      setState(() {
        _doseInfo = 'No dose data available for ${widget.drug}.';
      });
      return;
    }

    final weightKg = double.tryParse(widget.weight) ?? 0;
    final dose = weightKg * match.doseMgPerKg;
    final finalDose = dose > match.maxSingleDoseMg ? match.maxSingleDoseMg : dose;

    setState(() {
      _doseInfo = '''
Drug: ${match.name}
Indication: ${match.indication}

Age: ${widget.age} ${widget.ageUnit}
Weight: ${widget.weight} kg
${widget.gestAge != null ? "Gestational Age: ${widget.gestAge} weeks\n" : ""}

Recommended Dose:
$finalDose mg per dose, ${match.frequency}
(Max: ${match.maxSingleDoseMg} mg)
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dose for ${widget.drug}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _doseInfo,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
