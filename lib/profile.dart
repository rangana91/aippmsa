import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/components/custom_card_input_field.dart';
import 'package:aippmsa/services/user_service.dart';
import 'package:aippmsa/models/User.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Dispose controllers
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    _cityController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      await ApiServices().fetchAndSaveUserData();

      // Now load the user data from the local database
      User? user = await UserService().getUser();

      if (user != null) {
        setState(() {
          _firstNameController.text = user.firstName ?? '';
          _lastNameController.text = user.lastName ?? '';
          _dobController.text = user.dateOfBirth ?? '';
          _emailController.text = user.email ?? '';
          _addressController.text = user.address ?? '';
          _contactNumberController.text = user.number ?? '';
          _cityController.text = user.city ?? '';
          _postCodeController.text = user.postCode ?? '';
          _selectedGender = user.gender ?? 'Male';
        });
      }
    } catch (e) {
      // Handle any errors, such as showing a snackbar
      print('Error loading user data: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Create a User object with the updated data
        User updatedUser = User(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          dateOfBirth: _dobController.text,
          gender: _selectedGender ?? 'Male',
          email: _emailController.text,
          address: _addressController.text,
          number: _contactNumberController.text,
          city: _cityController.text,
          postCode: _postCodeController.text,
        );

        await ApiServices().updateUserProfile(updatedUser);

        // Show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          await _loadUserData();
        }
      } catch (e) {
        // Handle any errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTPNViadqRr2TUSAJKhblKIwIgtO7dIkZcyY2WQWdRoIXmN5Nr-hZwbM4o56PDRGJwJ7c&usqp=CAU'), // Replace with actual image URL or asset
              ),
              const SizedBox(height: 20),

              // User Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_firstNameController.text} ${_lastNameController.text}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _emailController.text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _contactNumberController.text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Input Fields styled as a card
              CustomCardInputField(
                labelText: 'First Name',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              CustomCardInputField(
                labelText: 'Last Name',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),

              // Date of Birth Field as Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                      }
                    },
                  ),
                ),
              ),

              // Gender Selection as Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: InputBorder.none,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                  ),
                ),
              ),

              CustomCardInputField(
                labelText: 'Email',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              CustomCardInputField(
                labelText: 'Address',
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              CustomCardInputField(
                labelText: 'Contact Number',
                controller: _contactNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              CustomCardInputField(
                labelText: 'City',
                controller: _cityController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              CustomCardInputField(
                labelText: 'Post Code',
                controller: _postCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter post code';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(134, 102, 225, 100),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
