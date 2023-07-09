import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;

class Stasiun {
  final String code;
  final String name;
  final String city;
  final String cityname;

  Stasiun({
    required this.code,
    required this.name,
    required this.city,
    required this.cityname,
  });

  factory Stasiun.fromJson(Map<String, dynamic> json) {
    return Stasiun(
      code: json['code'],
      name: json['name'],
      city: json['city'],
      cityname: json['cityname'],
    );
  }
}

class StasiunList extends StatefulWidget {
  @override
  _StasiunListState createState() => _StasiunListState();
}

class _StasiunListState extends State<StasiunList> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<Stasiun> stasiunList = [];

  Future<List<Stasiun>> fetchStasiun() async {
    final response = await http.get(
      Uri.parse('https://booking.kai.id/api/stations2'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Stasiun.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load stasiun');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStasiun().then((value) {
      setState(() {
        stasiunList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Stasiun Kereta Api'),
          backgroundColor: Colors.blueGrey,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FormBuilder(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'search',
                                decoration: InputDecoration(
                                  labelText: 'Search',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  String searchTerm = _formKey
                                      .currentState!.fields['search']!.value;
                                  List<Stasiun> filteredList = stasiunList
                                      .where((stasiun) => stasiun.name
                                          .toLowerCase()
                                          .contains(searchTerm.toLowerCase()))
                                      .toList();
                                  setState(() {
                                    stasiunList = filteredList;
                                  });
                                }
                              },
                              child: Text('Search'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Table(
                  border: TableBorder.all(color: Colors.grey),
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Code',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'City',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'City Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...stasiunList.map((stasiun) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(stasiun.code),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(stasiun.name),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(stasiun.city),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(stasiun.cityname),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(StasiunList());
}
