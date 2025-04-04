import 'package:flutter/material.dart'; // Import Flutter's material design package
import 'package:flutter_app/screens/LoginScreen.dart'; // Import the LoginScreen widget
import 'package:flutter_app/screens/RegisterScreen.dart';  // Import the RegisterScreen widget
import 'package:flutter_app/screens/HomeScreen.dart'; // Import the HomeScreen widget
import 'package:flutter_app/screens/ViewSavedRoutines.dart'; //Import the ViewSavedRoutines widget
import 'package:flutter_app/screens/AddRoutineScreen.dart'; //Import the AddRoutine widget


class Routes {
  // Define route names as constants
  static const String LOGINSCREEN = '/login';
  static const String REGISTER_SCREEN = '/register';  
  static const String HOMESCREEN = '/home';
  static const String FORGOT_PASSWORD_SCREEN = '/cards';
  static const String VIEW_ROUTINES_SCREEN = '/view-routines';
  static const String ADD_ROUTINE_SCREEN = '/add-routine';

  // Define a map of routes
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        // Default route (home screen)
        '/': (context) => LoginScreen(),

        // Login screen route
        LOGINSCREEN: (context) => LoginScreen(),

        // Register screen route
        REGISTER_SCREEN: (context) => RegisterScreen(), 
        
        // Cards screen route
        HOMESCREEN: (context) => HomeScreen(),

        //ViewRoutines screen route
        VIEW_ROUTINES_SCREEN: (context) => ViewSavedRoutines(),

        //AddRoutines screen route
        ADD_ROUTINE_SCREEN: (context) => AddRoutineScreen(),

        //auto reroutes any old cards routes to homescreen (tempfix)
        '/cards': (context) => HomeScreen(),
      };
}