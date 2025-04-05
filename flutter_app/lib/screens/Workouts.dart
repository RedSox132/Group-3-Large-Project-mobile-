import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  void onAddWorkout() {
    // Placeholder for future add workout logic
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add workout tapped')));
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
                    title: Text(
                      workout['name'],
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      workout['description'] ?? '',
                      style: TextStyle(color: Colors.orange[100]),
                    ),
                    trailing: workout['date'] != null
                        ? Text(
                      workout['date'],
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                    )
                        : null,
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
