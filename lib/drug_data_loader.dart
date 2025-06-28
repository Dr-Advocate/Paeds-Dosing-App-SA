import 'dart:convert';
import 'package:flutter/services.dart';

class Drug {
  final String name;
  final String indication;
  final double doseMgPerKg;
  final String frequency;
  final double maxSingleDoseMg;

  Drug({
    required this.name,
    required this.indication,
    required this.doseMgPerKg,
    required this.frequency,
    required this.maxSingleDoseMg,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      name: json['name'] ?? 'Unknown',
      indication: json['indication'] ?? '',
      doseMgPerKg: (json['doseMgPerKg'] as num).toDouble(),
      frequency: json['frequency'] ?? '',
      maxSingleDoseMg: (json['maxSingleDoseMg'] as num).toDouble(),
    );
  }
}

Future<List<Drug>> loadDrugsFromJson() async {
  try {
    final String response = await rootBundle.loadString('assets/drugs.json');
    final List<dynamic> data = json.decode(response);
    print('✅ Loaded ${data.length} drugs from JSON');
    return data.map((json) => Drug.fromJson(json)).toList();
  } catch (e) {
    print('❌ Error loading drugs.json: $e');
    return [];
  }
}
