import 'dart:ui';

import 'package:aippmsa/auth/sign_up.dart';
import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Padding(
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
                const FloatingLabelInput(
                  label: 'User name',
                ),
                const SizedBox(height: 16),
                const FloatingLabelInput(
                  label: 'Password',
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
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
                    onTap: () {},
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
          FullWidthButton(
            text: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            backgroundColor: const Color(0xFF9775FA),
            paddingVertical: 16.0,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ],
      ),
    );
  }
}
