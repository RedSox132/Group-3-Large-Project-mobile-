import 'package:flutter/material.dart';

class ViewSavedRoutines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Routines')),
      body: Center(child: Text('Here are your saved routines.')),
    );
  }
}