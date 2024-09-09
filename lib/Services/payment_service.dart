import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio = Dio();

  Future<String?> createPaymentIntent(int amount, String currency) async {
    try {
      final response = await _dio.post(
        'https://your-backend-url.com/api/create-payment-intent',
        data: {
          'amount': amount,      // Amount in cents (for USD or other minor units)
          'currency': currency,  // For example, 'usd', 'eur', etc.
        },
      );
      return response.data['clientSecret'];  // Extract clientSecret
    } on DioError catch (e) {
      print('Error creating payment intent: ${e.response?.data}');
      return null;
    }
  }
}
