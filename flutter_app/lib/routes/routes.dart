import 'package:flutter/material.dart'; // Import Flutter's material design package
import 'package:flutter_app/screens/LoginScreen.dart'; // Import the LoginScreen widget
import 'package:flutter_app/screens/RegisterScreen.dart';  // Import the RegisterScreen widget
import 'package:flutter_app/screens/CardsScreen.dart'; // Import the CardsScreen widget


class Routes {
  // Define route names as constants
  static const String LOGINSCREEN = '/login';
  static const String REGISTER_SCREEN = '/register';  
  static const String CARDSSCREEN = '/cards';
  static const String FORGOT_PASSWORD_SCREEN = '/cards';

  // Define a map of routes
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        // Default route (home screen)
        '/': (context) => LoginScreen(),

        // Login screen route
        LOGINSCREEN: (context) => LoginScreen(),

        // Register screen route
        REGISTER_SCREEN: (context) => RegisterScreen(), 
        
        // Cards screen route
        CARDSSCREEN: (context) => CardsScreen(),
      };
}