import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screens/Exercises.dart';


class WorkoutsScreen extends StatefulWidget {
  final String routineId;
  final String routineName;

  WorkoutsScreen({required this.routineId, required this.routineName});

  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  List<dynamic> workouts = [];
  bool isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('http://firefitapp.com/api/workouts?routineId=${widget.routineId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          workouts = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          message = 'Failed to fetch workouts';
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

  Future<void> deleteWorkout(String workoutId) async {
    try {
      final response = await http.delete(Uri.parse('http://firefitapp.com/api/deleteWorkout?workoutId=$workoutId'));
      if (response.statusCode == 200) {
        setState(() {
          workouts.removeWhere((workout) => workout['workoutId'] == workoutId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete workout')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void onAddWorkout() {
    showAddWorkoutDialog(context, widget.routineId, fetchWorkouts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.routineName} Workouts'),
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
          isLoading
              ? Center(child: CircularProgressIndicator())
              : workouts.isEmpty
              ? Center(
            child: Text(
              'No workouts added yet!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return Card(
                  color: Colors.black.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.orange.withOpacity(0.7)),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExercisesScreen(
                            workoutId: workout['workoutId'],
                            workoutName: workout['name'],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      workout['name'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      workout['description'] ?? '',
                      style: TextStyle(color: Colors.orange[100]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (workout['date'] != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              formatDate(workout['date']),
                              style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                            ),
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => deleteWorkout(workout['workoutId']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: onAddWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.deepOrange),
                ),
              ),
              child: Text(
                'Add Workout',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> showAddWorkoutDialog(BuildContext context, String routineId, Function onSuccess) async {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String message = '';
  bool isSubmitting = false;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Add Workout', style: TextStyle(color: Colors.orange)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.orange)),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.orange)),
                ),
                SizedBox(height: 10),
                if (message.isNotEmpty)
                  Text(message, style: TextStyle(color: Colors.redAccent), textAlign: TextAlign.center),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.orange)),
              ),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                  final name = _nameController.text.trim();
                  final description = _descriptionController.text.trim();
                  if (name.isEmpty || description.isEmpty) {
                    setState(() => message = 'Both fields are required');
                    return;
                  }

                  setState(() => isSubmitting = true);

                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getString('userId');

                  final response = await http.post(
                    Uri.parse('http://firefitapp.com/api/addWorkout'),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      "userId": userId,
                      "routineId": routineId,
                      "name": name,
                      "description": description,
                      "date": DateTime.now().toIso8601String().split('T').first,
                    }),
                  );

                  setState(() => isSubmitting = false);

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    onSuccess();
                  } else {
                    setState(() => message = 'Failed to add workout');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(isSubmitting ? 'Submitting...' : 'Add'),
              ),
            ],
          );
        },
      );
    },
  );
}

String formatDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  } catch (e) {
    return isoDate;
  }
}
