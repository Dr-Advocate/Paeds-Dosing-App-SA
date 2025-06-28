import 'package:flutter/material.dart';
import 'drug_data_loader.dart';
import 'result_screen.dart';

class DrugSelectionScreen extends StatefulWidget {
  final String age;
  final String weight;
  final String ageUnit;
  final String? gestAge;

  DrugSelectionScreen({
    required this.age,
    required this.weight,
    required this.ageUnit,
    this.gestAge,
  });

  @override
  _DrugSelectionScreenState createState() => _DrugSelectionScreenState();
}

class _DrugSelectionScreenState extends State<DrugSelectionScreen> {
  List<Drug> _drugs = [];
  List<Drug> _filteredDrugs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDrugsFromJson().then((data) {
      print('Loaded ${data.length} drugs');
      setState(() {
        _drugs = data;
        _filteredDrugs = data;
      });
    }).catchError((e) {
      print('Error loading drugs: $e');
    });

    _searchController.addListener(_filterDrugs);
  }

  void _filterDrugs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDrugs = _drugs.where((drug) {
        return drug.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Drug')),
      body: _drugs.isEmpty
          ? Center(child: Text('No drugs found in JSON.'))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a drug...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDrugs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredDrugs[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          drug: _filteredDrugs[index].name,
                          age: widget.age,
                          weight: widget.weight,
                          ageUnit: widget.ageUnit,
                          gestAge: widget.gestAge,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

