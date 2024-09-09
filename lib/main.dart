import 'dart:developer';

import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/auth/sign_up.dart';
import 'package:aippmsa/auth/forgot_password.dart';
import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:aippmsa/dashboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'authToken');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const Dashboard() : const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  void _login() async {

    setState(() {
      _isLoading = true; // Show loader and disable button
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    const storage = FlutterSecureStorage();

    try {
      final apiService = ApiServices();
      final authResponse = await apiService.login(email, password);
print(authResponse);
      if (authResponse.token != null) {
        await storage.write(key: 'authToken', value: authResponse.token);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        }
      } else {
        _showErrorDialog('Invalid credentials. Please try again.');
      }
    } on ValidationException catch (e) {
      _showValidationErrors(e.errors);
    } catch (e) {
      _showErrorDialog('Something went wrong. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loader and enable button
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.04),
                    Center(
                      child: Image.asset(
                        'assets/pad_lock.png', // Path to your image file
                        height: 100, // Adjust the height as needed
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.05),
                    FloatingLabelInput(
                      label: 'User name',
                      controller: _emailController,
                      errorText: _emailError,
                      onChanged: _handleEmailChanged,
                    ),
                    const SizedBox(height: 16),
                    FloatingLabelInput(
                      label: 'Password',
                      obscureText: true,
                      controller: _passwordController,
                      errorText: _passwordError,
                      onChanged: _handlePasswordChanged,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPassword()),
                            );
                          },
                          child: const Text(
                            'forgot password?',
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceHeight * 0.08),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: const Text(
                          'Sign up Here',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF8F959E),
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            const TextSpan(
                              text: 'By connecting your account, you confirm that you agree with our ',
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle the tap event here
                                },
                            ),
                            const TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FullWidthButton(
            text: _isLoading ? 'Logging in...' : 'Login',
            onPressed: _isLoading ? (){} : _login,
            backgroundColor: const Color(0xFF9775FA),
            paddingVertical: 16.0,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            child: _isLoading ? const CircularProgressIndicator() : null,
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrors(Map<String, dynamic> errors) {
    setState(() {
      _emailError = errors['email']?.first;
      _passwordError = errors['password']?.first;
    });
  }

  void _handleEmailChanged(String value) {
    setState(() {
      _emailError = null; // Clear the error message
    });
  }

  void _handlePasswordChanged(String value) {
    setState(() {
      _passwordError = null; // Clear the error message
    });
  }

}
