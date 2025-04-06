import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screens/Workouts.dart';



class Routine {
  final String routineId;
  final String name;
  final String description;

  Routine({required this.routineId, required this.name, required this.description});

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    routineId: json['routineId'],
    name: json['name'],
    description: json['description'],
  );
}

class ViewSavedRoutines extends StatefulWidget {
  @override
  _ViewSavedRoutinesState createState() => _ViewSavedRoutinesState();
}

class _ViewSavedRoutinesState extends State<ViewSavedRoutines> {
  List<Routine> routines = [];
  bool isLoading = true;
  String message = '';

  Future<void> fetchRoutines() async {
    print('Fetching routines...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        setState(() {
          message = 'User not logged in.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://firefitapp.com/api/routines?userId=$userId'),
      );
      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          routines = data.map((json) => Routine.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          message = 'Failed to fetch routines';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    try {
      final response = await http.delete(Uri.parse('http://firefitapp.com/api/deleteRoutine?routineId=$routineId'));
      if (response.statusCode == 200) {
        setState(() {
          routines.removeWhere((routine) => routine.routineId == routineId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete routine')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Routines'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fire.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : routines.isEmpty
                ? Center(child: Text('No routines added yet', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: routines.length,
              itemBuilder: (context, index) {
                final routine = routines[index];
                return Card(
                  color: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.orange.withOpacity(0.7)),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(routine.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(routine.description, style: TextStyle(color: Colors.orange[100])),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this routine?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteRoutine(routine.routineId);
                                  },
                                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutsScreen(
                            routineId: routine.routineId,
                            routineName: routine.name,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
