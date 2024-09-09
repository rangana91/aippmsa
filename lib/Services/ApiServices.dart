import 'package:aippmsa/models/auth_response_model.dart';
import 'package:aippmsa/models/password_reset_response.dart';
import 'package:aippmsa/models/register_response_model.dart';
import 'package:dio/dio.dart';

class ApiServices {
  static late Dio _dio;

  // Defining the base urls
  static const String _devBaseUrl = 'https://dev.example.com/api';
  static const String _localBaseUrl = 'https://f109-2402-4000-b280-48f5-accb-5d6f-c9f9-5c35.ngrok-free.app/api';
  static const String _prodBaseUrl = 'https://prod.example.com/api';

  static const String _baseUrl = _localBaseUrl;

  ApiServices() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ));
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  //login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      print(response);
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('test 1 $e');
      if (e.response?.statusCode == 422) {
        // Handle validation errors
        final errors = e.response?.data['errors'] ?? {};
        throw ValidationException(errors);
      } else {
        // Handle other errors
        print('test 2 $e');
        return AuthResponse.fromJson(e.response?.data);
      }
    }
  }

  //register
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String postCode,
    required String gender,
    required String dob,
    required String number
  }) async {
    try {
      final response = await _dio.post('/create-user', data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'post_code': postCode,
        'gender': gender,
        'date_of_birth': dob,
        'number': number
      });
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        throw ValidationException(errors);
      } else {
        return RegisterResponse.fromJson(e.response?.data);
      }
    }
  }

  //forgot password
  Future<PasswordResetResponse> resetPassword(String email) async {
    try {
      final response = await _dio.post('/password-reset', data: {
        'email': email,
      });

      return PasswordResetResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] ?? {};
        throw ValidationException(errors);
      } else {
        print(e);
        return PasswordResetResponse.fromJson(e.response?.data);
      }
    }
  }

}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}
