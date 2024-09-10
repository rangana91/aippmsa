import 'package:aippmsa/Services/ApiServices.dart';
import 'package:dio/dio.dart';

class PaymentService {

  Future<String?> createPaymentIntent(int amount, String currency) async {
    return ApiServices().createPaymentIntent(amount, currency);
  }

}
