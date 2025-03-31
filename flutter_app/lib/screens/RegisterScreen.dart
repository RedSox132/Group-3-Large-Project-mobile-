import 'package:flutter/material.dart';
import 'package:flutter_app/utils/getAPI.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '', password = '', confirmPassword = '', name = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  bool _hasSpecialCharacter(String password) {
    final specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialChars.hasMatch(password);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Text(
            'Account Created! test', //debug
            style: TextStyle(color: Colors.orange),
          ),
          content: Text(
            'Your Fire Fitness account has been successfully created. test', //debug
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to login
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailDialog(BuildContext context, [var code = 0, String response = '']) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Text(
            'Account Creation Failed error code: ${code}',
            style: TextStyle(color: Colors.orange),
          ),
          content: Text(
            'Your Fire Fitness account failed to create!\n${response}',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background and overlay 
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fire.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          
          // Form content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.red, Colors.orange, Colors.yellow],
                        stops: [0.1, 0.5, 0.9],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Fire Fitness',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  
                  // Form Container
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.8),
                        width: 1.5,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 30),
                          
                          // Email Field
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.orange),
                              prefixIcon: Icon(Icons.email, color: Colors.orange),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: (text) => email = text,
                          ),
                          SizedBox(height: 20),

                          //Name Field
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.orange),
                              prefixIcon: Icon(Icons.account_box_rounded, color: Colors.orange),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onChanged: (text) => name = text,
                          ),
                          SizedBox(height: 20),
                          
                          // Password Field
                          TextFormField(
                            obscureText: _obscurePassword,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.orange),
                              prefixIcon: Icon(Icons.lock, color: Colors.orange),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!_hasSpecialCharacter(value)) {
                                return 'Password must contain a special character';
                              }
                              return null;
                            },
                            onChanged: (text) => password = text,
                          ),
                          SizedBox(height: 20),
                          
                          // Confirm Password Field
                          TextFormField(
                            obscureText: _obscureConfirmPassword,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.orange),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.orange),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            onChanged: (text) => confirmPassword = text,
                          ),
                          SizedBox(height: 30),
                          
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var res = await API.APICall('/register', '{"email": "${email}",\n"password": "${password}",\n "name": "${name}"}');
                                  // Just gives success Dialogue currently, need to add fail
                                  if (res == null) {
                                    _showFailDialog(context);
                                  } else if (res['code'] != 200) {
                                    _showFailDialog(context, res['code'], res['response']);
                                  } else {
                                    _showSuccessDialog(context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.orange),
                                ),
                                elevation: 5,
                                shadowColor: Colors.red,
                              ),
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Divider and Login Link 
                          // ...
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}