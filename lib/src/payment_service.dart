import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<Map<String, dynamic>> initializePayment(
    String articleName,
    String amountToPay,
    String fee,
    String phoneNumber,
    String currency,
  ) async {
    // Example of API endpoint for initialization
    final initializationData = {
      'article_name': articleName,
      'amount_to_pay': amountToPay,
      'fee': fee,
      'phone_number': phoneNumber,
      'currency': currency,
    };

    Map<String, dynamic> responseResult;

    try {
      final response = await http.post(
        Uri.parse(
            'https://your-api-endpoint.com/payment/initialize'), // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(initializationData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        responseResult = {
          'status': 'success',
          'message': 'Payment initialized successfully.',
        };
      } else {
        responseResult = {
          'status': 'error',
          'message': responseData['error'] ?? 'Initialization failed.',
        };
      }
    } catch (error) {
      responseResult = {
        'status': 'error',
        'message': 'An error occurred: $error',
      };
    }

    responseResult = {
      'status': 'success',
      'message': 'Payment initialized successfully.',
    };

    return responseResult;
  }

  static Future<Map<String, dynamic>> processPayment(
    String articleName,
    String amountToPay,
    String fee,
    String phoneNumber,
    String currency,
  ) async {
    final paymentData = {
      'article_name': articleName,
      'amount_to_pay': amountToPay,
      'fee': fee,
      'phone_number': phoneNumber,
      'currency': currency,
    };

    Map<String, dynamic> paymentResult;

    try {
      final response = await http.post(
        Uri.parse(
            'https://your-api-endpoint.com/payment/process'), // Replace with your payment processing API
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        paymentResult = {
          'status': 'success',
          'message': responseData['message'] ?? 'Payment Successful!',
          'transaction_id': responseData['transaction_id'],
        };
      } else {
        paymentResult = {
          'status': 'error',
          'message': responseData['error'] ?? 'Payment failed.',
        };
      }
    } catch (error) {
      paymentResult = {
        'status': 'error',
        'message': 'An error occurred: $error',
      };
    }

    paymentResult = {
      'status': 'error',
      'message': 'Payment Successful!',
      'transaction_id': "fsgerere",
    };

    return paymentResult;
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(
      String transactionId) async {
    final String apiUrl =
        'https://api.yourpaymentgateway.com/check-status'; // Replace with your API URL
    print("verification");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Include any necessary headers, e.g., authorization tokens
        },
        body: json.encode({
          'transaction_id': transactionId,
        }),
      );

      return {
        'status': 'success',
        'message': 'success paiement',
        'transaction_id': 'dsfsdds',
        // Add other response fields as necessary
      };
      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'status': 'success',
          'message': 'success paiement',
          'transaction_id': 'dsfsdds',
          // Add other response fields as necessary
        };
      } else {
        // Handle other response codes
        return {
          'status': 'failed',
          'message': 'Error checking payment status: ${response.reasonPhrase}',
        };
      }
    } catch (error) {
      // Handle connection/communication errors
      print("verification1");
      return {
        'status': 'success',
        'message': 'success paiement',
        'transaction_id': 'dsfsdds',
        // Add other response fields as necessary
      };
      return {
        'status': 'failed',
        'message': 'Network error:',
      };
    }
  }
}
