import 'package:aippmsa/components/city_selection_input.dart';
import 'package:aippmsa/components/dob_selector.dart';
import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/gender_selection_input.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String? _selectedGender = null;
  final String? _selectedCity = null;
  final TextEditingController _dobController = TextEditingController();
  final List<String> _cities = ['Kuliyapitiya', 'Colombo', 'Kurunegala', 'Kandy', 'Negombo'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the default back button
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24.0), // Spacing before the form
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FloatingLabelInput(
                        label: 'First Name',
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Last Name',
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      GenderSelectionInput(
                        label: 'Gender',
                        selectedGender: _selectedGender,
                        onChanged: (gender) {
                          // Handle gender selection change
                        },
                      ),
                      DOBSelector(
                        label: 'Date of Birth',
                        controller: _dobController,
                      ),
                      CitySelectionInput(
                        label: 'City',
                        cities: _cities,
                        selectedCity: _selectedCity,
                        onChanged: (city) {
                          // Handle city selection change
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 80), // Adjust the spacing as needed
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FullWidthButton(
              text: 'Signup',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle sign-up logic here
                }
              },
              backgroundColor: const Color(0xFF9775FA),
              paddingVertical: 16.0,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
