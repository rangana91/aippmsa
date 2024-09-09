import 'dart:developer';

import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/components/city_selection_input.dart';
import 'package:aippmsa/components/dob_selector.dart';
import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/gender_selection_input.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:aippmsa/helpers/show_modal.dart';
import 'package:aippmsa/main.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _telNoController = TextEditingController();
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _genderError;
  String? _telNoError;
  String? _dobError;
  String? _addrLine1Error;
  String? _addrLine2Error;
  String? _cityError;
  String? _postCodeError;
  String? _passwordError;
  String? _selectedCity;
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();
  final List<String> _cities = ['Kuliyapitiya', 'Colombo', 'Kurunegala', 'Kandy', 'Negombo'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        errorText: _firstNameError,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _firstNameError = null; // Clear the error message
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Last Name',
                        errorText: _lastNameError,
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _lastNameError = null; // Clear the error message
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Email',
                        errorText: _emailError,
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
                        onChanged: (value) {
                          setState(() {
                            _emailError = null; // Clear the error message
                          });
                        },
                      ),
                      GenderSelectionInput(
                        label: 'Gender',
                        selectedGender: _selectedGender,
                        onChanged: (gender) {
                          setState(() {
                            _selectedGender = gender;
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Telephone Number',
                        errorText: _telNoError,
                        controller: _telNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your telephone number.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _telNoError = null; // Clear the error message
                          });
                        },
                      ),
                      DOBSelector(
                        label: 'Date of Birth',
                        controller: _dobController,
                      ),
                      FloatingLabelInput(
                        label: 'Address Line 1',
                        errorText: _addrLine1Error,
                        controller: _addressLine1Controller,
                        onChanged: (value) {
                          setState(() {
                            _addrLine1Error = null; // Clear the error message
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Address Line 2',
                        errorText: _addrLine2Error,
                        controller: _addressLine2Controller,
                        onChanged: (value) {
                          setState(() {
                            _addrLine2Error = null; // Clear the error message
                          });
                        },
                      ),
                      CitySelectionInput(
                        label: 'City',
                        cities: _cities,
                        selectedCity: _selectedCity,
                        onChanged: (city) {
                          setState(() {
                            _selectedCity = city;
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'PostCode',
                        errorText: _postCodeError,
                        controller: _postCodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your post code.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _postCodeError = null; // Clear the error message
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Password',
                        errorText: _passwordError,
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
                        onChanged: (value) {
                          setState(() {
                            _passwordError = null; // Clear the error message
                          });
                        },
                      ),
                      FloatingLabelInput(
                        label: 'Password Confirmation',
                        controller: _passwordConfirmationController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
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
              text: _isLoading ? 'Loading...' : 'Sign Up',
              onPressed: _isLoading ? (){} : () async {
                setState(() {
                  _isLoading = true; // Show loader and disable button
                });
                if (_formKey.currentState!.validate()) {
                  final BuildContext currentContext = context;
                  try {
                    final apiService = ApiServices();
                    final response = await apiService.register(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        passwordConfirmation: _passwordConfirmationController.text,
                        addressLine1: _addressLine1Controller.text,
                        addressLine2: _addressLine2Controller.text,
                        city: _selectedCity ?? '',
                        postCode: _postCodeController.text,
                        gender: _selectedGender ?? '',
                        dob: _dobController.text,
                        number: _telNoController.text
                    );

                    // _showSuccessDialog(response.message!);
                    if (context.mounted) {
                      ShowModal().showSuccessDialog(
                          response.message!, context, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                  title: 'AIPPMSA')),
                        );
                      });
                    }

                    // Navigate to the next page or handle success logic
                  } on ValidationException catch (e) {
                    _showValidationErrors(e.errors);
                  } catch (e) {
                    if (context.mounted) {
                      ShowModal().showErrorDialog('Something went wrong', context, () {
                        Navigator.of(context).pop(); // Close the dialog
                      });
                    }
                    // _showErrorDialog('Something went wrong. Please try again.');
                  } finally {
                    setState(() {
                      _isLoading = false; // Hide loader and enable button
                    });
                  }
                } else {
                  setState(() {
                    _isLoading = false; // Show loader and disable button
                  });
                }
              },
              backgroundColor: const Color(0xFF9775FA),
              paddingVertical: 16.0,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              child: _isLoading ? const CircularProgressIndicator() : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationErrors(Map<String, dynamic> errors) {
    setState(() {
      _emailError = errors['email']?.first;
      _passwordError = errors['password']?.first;
    });
  }

}
