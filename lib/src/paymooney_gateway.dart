import 'package:flutter/material.dart';
import 'payment_dialog_builder.dart';
import 'payment_service.dart';

class PaymooneyGateway {
  static Future<void> init(
    BuildContext context, {
    required String articleName,
    required String articleDescription,
    required String articleImage,
    required String amount,
    required String phoneNumber,
    required String currency,
    required String publickKey,
    required String itemRef,
    required String lang,
    required Function(Map<String, dynamic>) onPaymentResult,
  }) async {
    await PaymentDialogBuilder.show(
      context,
      articleName,
      articleDescription,
      articleImage,
      amount,
      phoneNumber,
      currency,
      publickKey,
      itemRef,
      lang,
      onPaymentResult,
    );
  }
}
