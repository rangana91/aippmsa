class User {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String address;
  final String number;
  final String city;
  final String postCode;

  User({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.address,
    required this.number,
    required this.city,
    required this.postCode,
  });

  // Create a method to convert JSON response to a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      email: json['email'],
      address: json['address'],
      number: json['number'],
      city: json['city'],
      postCode: json['post_code'],
    );
  }

  // Create a method to convert the User object to a Map for saving in local storage
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'email': email,
      'address': address,
      'number': number,
      'city': city,
      'post_code': postCode,
    };
  }
}
