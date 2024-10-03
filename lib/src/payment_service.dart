import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paymooney_gateway/src/constant.dart';

class PaymentService {
  static Future<Map<String, dynamic>> initializePayment(
    String articleName,
    String articleDescription,
    String amount,
    String publickKey,
    String phoneNumber,
    String currency,
    String articleImage,
    String itemRef,
  ) async {
    Map<String, dynamic> postData = {};
    postData = {
      "amount": amount,
      "currency_code": currency,
      "ccode": "CM",
      "lang": "fr",
      "item_name": articleName,
      "description": articleDescription,
      "email": '',
      "item_ref": itemRef,
      "first_name": '',
      "phone": phoneNumber,
      "last_name": "",
      "public_key": publickKey,
      "logo": articleImage,
      "environement": "live"
    };

    Map<String, dynamic> responseResult;

    try {
      final response = await http.post(
        Uri.parse(paymooney_init_url), // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(postData),
      );

      final responseData = json.decode(response.body);

      //print(responseData);

      responseResult = responseData;

      /* if (response.statusCode == 200 && responseData['response'] == 'success') {
        responseResult = {
          'status': 'success',
          'message': 'Payment initialized successfully.',
        };
      } else {
        responseResult = {
          'status': 'error',
          'message': responseData['message'] ?? 'Initialization failed.',
        };
      }*/
    } catch (error) {
      responseResult = {
        'response': 'error',
        'message': 'An error occurred: $error',
      };
    }

    return responseResult;
  }

  static Future<Map<String, dynamic>> processPayment(
    String articleName,
    String amountToPay,
    String fee,
    String phoneNumber,
    String currency,
    String token,
  ) async {
    Map<String, dynamic> paymentResult;

    String url = paymooney_init_orange;
    String query = '_token=' +
        token +
        '&phone=' +
        phoneNumber +
        '&cname=Cameroon&lang=fr&ccode=cm&dial_code=237';

    final paymentData = {'query': query};
    //print(json.encode(paymentData));

    if (detectOperator(phoneNumber) == 'mtn') url = paymooney_init_mtn;
    try {
      final response = await http.post(
        Uri.parse(url), // Replace with your payment processing API
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      final responseData = json.decode(response.body);
      //  print(responseData);
      paymentResult = responseData;
      //print(paymentResult);

      /*if (response.statusCode == 200 && responseData['status'] == 'success') {
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
      }*/
    } catch (error) {
      paymentResult = {
        'status': 'failed',
        'message': 'An error occurred',
      };
    }

    return paymentResult;
  }

  static String detectOperator(String phoneNumber) {
    // Regular expression patterns for operator detection
    final RegExp mtnPattern = RegExp(r'^6((7|8)[0-9]{7}$)|(5[0-4][0-9]{6}$)');
    final RegExp orangePattern = RegExp(r'^6((9)[0-9]{7}$)|(5[5-9][0-9]{6}$)');

    // Check patterns against phoneNumber
    if (orangePattern.hasMatch(phoneNumber)) {
      return 'orange';
    } else if (mtnPattern.hasMatch(phoneNumber)) {
      return 'mtn';
    } else {
      return 'unknown';
    }
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(
      String itemRef, String publicKey) async {
    final String apiUrl = paymooney_payment_status; // Replace with your API URL
    print("verification");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Include any necessary headers, e.g., authorization tokens
        },
        body: json.encode({'item_ref': itemRef, 'public_key': publicKey}),
      );

      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> data = json.decode(response.body);
        //print(data);
        return data;
      } else {
        // Handle other response codes
        return {
          'status': 'failed',
          'message': 'Error checking payment status !',
        };
      }
    } catch (error) {
      return {
        'status': 'failed',
        'message': 'Network error:',
      };
    }
  }
}
