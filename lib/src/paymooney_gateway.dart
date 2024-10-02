import 'package:flutter/material.dart';
import 'payment_dialog_builder.dart';
import 'payment_service.dart';

class PaymooneyGateway {
  static Future<void> init(
    BuildContext context, {
    required String articleName,
    required String articleDescription,
    required String articleImage,
    required String amountToPay,
    required String fee,
    required String phoneNumber,
    required String currency,
    required Function(Map<String, dynamic>) onPaymentResult,
  }) async {
    await PaymentDialogBuilder.show(
      context,
      articleName,
      articleDescription,
      articleImage,
      amountToPay,
      fee,
      phoneNumber,
      currency,
      onPaymentResult,
    );
  }
}
