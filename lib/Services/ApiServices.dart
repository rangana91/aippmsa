import 'package:aippmsa/Services/user_service.dart';
import 'package:aippmsa/models/User.dart';
import 'package:aippmsa/response/auth_response_model.dart';
import 'package:aippmsa/response/password_reset_response.dart';
import 'package:aippmsa/response/register_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiServices {
  static late Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Defining the base urls
  static const String _devBaseUrl = 'https://dev.example.com/api';
  static const String _localBaseUrl = 'https://4c24-2402-4000-b280-7cc7-18ba-c2b3-a84c-bcff.ngrok-free.app/api';
  static const String _prodBaseUrl = 'https://prod.example.com/api';

  static const String _baseUrl = _localBaseUrl;

  ApiServices() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: 20000),
      receiveTimeout: const Duration(milliseconds: 20000),
    ));
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<void> _setAuthorizationHeader() async {
    final token = await _secureStorage.read(key: 'authToken');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
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

  //fetch item list
  Future<List<dynamic>> fetchItems() async {
    await _setAuthorizationHeader();
    final response = await _dio.get('$_baseUrl/items');
    return response.data as List<dynamic>;
  }

  //fetch item list
  Future<List<dynamic>> fetchRecommendedItems() async {
    await _setAuthorizationHeader();
    final response = await _dio.get('$_baseUrl/get-predictions');
    return response.data as List<dynamic>;
  }

  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      await _setAuthorizationHeader();
      final response = await _dio.post(
        '$_localBaseUrl/create-payment-intent',
        data: {
          'amount': amount,
          'currency': currency,
        },
      );
      return response.data['clientSecret'];  // Extract clientSecret
    } on DioException catch (e) {
      print('Error creating payment intent: ${e.response?.data}');
      return null;
    }
  }

  Future<void> sendCartDataToBackend(List<Map<String, dynamic>> cartItems, String shippingAddress) async {
    try {
      await _setAuthorizationHeader();
      final response = await _dio.post(
        '$_baseUrl/create-order', // Your API endpoint
        data: {
          'items': cartItems,
          'shipping_address': shippingAddress
        },
      );
      if (response.statusCode == 200) {
        print('Cart data successfully sent to the backend');
      } else {
        print('Failed to send cart data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending cart data: $e');
    }
  }

  Future<List<dynamic>> fetchOrdersFromApi() async {
    try {
      await _setAuthorizationHeader();
      final response = await _dio.get('$_baseUrl/get-orders');

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error while loading order data: $e');
      return [];
    }
  }

  Future<void> fetchAndSaveUserData() async {
    try {
      await _setAuthorizationHeader();
      final response = await _dio.get('$_baseUrl/get-user');

      // Check if the response is successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = response.data;
        User user = User.fromJson(userData);
        await UserService().clearUser();
        await UserService().saveUser(user);

        print('User data saved successfully');
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error if any
      print('Error fetching user data: $e');
    }
  }

  //update user
  Future<void> updateUserProfile(User updatedUser) async {
    try {
      await _setAuthorizationHeader();
      // Prepare the request data
      final data = {
        "first_name": updatedUser.firstName,
        "last_name": updatedUser.lastName,
        "date_of_birth": updatedUser.dateOfBirth,
        "gender": updatedUser.gender,
        "email": updatedUser.email,
        "address": updatedUser.address,
        "number": updatedUser.number,
        "city": updatedUser.city,
        "post_code": updatedUser.postCode,
      };

      // Making a POST request with authorization token
      final response = await _dio.post(
          "$_baseUrl/update-user",
          data: data
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print("Profile updated successfully: ${response.data}");
      } else {
        // Handle errors
        print("Failed to update profile: ${response.statusCode}");
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      // Handle exceptions
      print("Error updating profile: $e");
      throw e;
    }
  }

}

class ValidationException implements Exception {
  final Map<String, dynamic> errors;
  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}
