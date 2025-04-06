import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExercisesScreen extends StatefulWidget {
  final String workoutId;
  final String workoutName;

  ExercisesScreen({required this.workoutId, required this.workoutName});

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<dynamic> exercises = [];
  bool isLoading = true;
  String message = '';

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('http://firefitapp.com/api/exercises?workoutId=${widget.workoutId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          exercises = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          message = 'Failed to fetch exercises';
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

  Future<void> showAddExerciseDialog() async {
    final _nameController = TextEditingController();
    final _setsController = TextEditingController();
    final _repsController = TextEditingController();
    final _weightController = TextEditingController();
    String message = '';

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Add Exercise', style: TextStyle(color: Colors.orange)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_nameController, 'Name', TextInputType.text),
                    _buildTextField(_setsController, 'Sets', TextInputType.number),
                    _buildTextField(_repsController, 'Reps', TextInputType.number),
                    _buildTextField(_weightController, 'Weight (lbs)', TextInputType.number),
                    if (message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(message, style: TextStyle(color: Colors.redAccent)),
                      )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.orange)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final sets = int.tryParse(_setsController.text.trim()) ?? 0;
                    final reps = int.tryParse(_repsController.text.trim()) ?? 0;
                    final weight = int.tryParse(_weightController.text.trim()) ?? 0;

                    if (name.isEmpty || sets == 0 || reps == 0) {
                      setState(() => message = 'All fields are required and must be valid.');
                      return;
                    }

                    final response = await http.post(
                      Uri.parse('http://firefitapp.com/api/addExercise'),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({
                        "workoutId": widget.workoutId,
                        "name": name,
                        "sets": sets,
                        "reps": reps,
                        "weight": weight
                      }),
                    );

                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      fetchExercises();
                    } else {
                      setState(() => message = 'Failed to add exercise');
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Add'),
                )
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.orange),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrangeAccent),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workoutName} Exercises'),
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
              : exercises.isEmpty
              ? Center(
            child: Text('No exercises added yet!', style: TextStyle(color: Colors.white, fontSize: 18)),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Card(
                color: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.orange.withOpacity(0.7)),
                ),
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(exercise['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}, Weight: ${exercise['weight']} lbs',
                    style: TextStyle(color: Colors.orange[100]),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: showAddExerciseDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.deepOrange),
                ),
              ),
              child: Text('Add Exercise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }
}
