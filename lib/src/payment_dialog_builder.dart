import 'package:flutter/material.dart';
import 'package:paymooney_gateway/src/error_page.dart';
import 'package:paymooney_gateway/src/success_page.dart';
import 'payment_service.dart';
import 'payment_summary_field.dart';

class PaymentDialogBuilder {
  static Future<void> show(
    BuildContext context,
    String articleName,
    String articleDescription,
    String articleImage,
    String amount,
    String phoneNumber,
    String currency,
    String publickKey,
    String itemRef,
    String lang,
    Function(Map<String, dynamic>) onPaymentResult,
  ) async {
    // Call the REST API before showing the modal
    final initializationResponse = await PaymentService.initializePayment(
        articleName,
        articleDescription,
        amount,
        publickKey,
        phoneNumber,
        currency,
        articleImage,
        itemRef);

    if (initializationResponse['response'] == 'success') {
      // Show the modal bottom sheet as the API call was successful
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return PaymentProcessWidget(
            articleName: articleName,
            articleDescription: articleDescription,
            articleImage: articleImage != null
                ? articleImage
                : 'https://via.placeholder.com/60',
            amountToPay: initializationResponse['amount_to_paid'].toString(),
            amount:
                initializationResponse['payment_intent']['amount'].toString(),
            fee: initializationResponse['fees'].toString(),
            phoneNumber: initializationResponse['payment_intent']['phone'],
            currency: initializationResponse['payment_intent']['currency_code'],
            token: initializationResponse['payment_intent']['token'],
            publicKey: publickKey,
            itemRef: itemRef,
            lang: lang,
            onPaymentResult: onPaymentResult,
          );
        },
      );
    } else {
      // Handle API initialization error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(initializationResponse['message'] ??
                'Failed to initialize payment.')),
      );
    }
  }
}

class PaymentProcessWidget extends StatefulWidget {
  final String articleName;
  final String articleDescription;
  final String articleImage;
  final String amountToPay;
  final String amount;
  final String fee;
  final String phoneNumber;
  final String currency;
  final String publicKey;
  final String itemRef;
  final String token;
  final String lang;
  final Function(Map<String, dynamic>) onPaymentResult;

  const PaymentProcessWidget({
    Key? key,
    required this.articleName,
    required this.articleDescription,
    required this.articleImage,
    required this.amountToPay,
    required this.amount,
    required this.fee,
    required this.phoneNumber,
    required this.currency,
    required this.publicKey,
    required this.itemRef,
    required this.token,
    required this.lang,
    required this.onPaymentResult,
  }) : super(key: key);

  @override
  _PaymentProcessWidgetState createState() => _PaymentProcessWidgetState();
}

class _PaymentProcessWidgetState extends State<PaymentProcessWidget> {
  bool _isProcessing = false;
  Map<String, dynamic>? _paymentResult;
  bool _paymentCompleted = false;
  bool _isSuccess = false;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    _paymentResult = await PaymentService.processPayment(
        widget.articleName,
        widget.amountToPay,
        widget.fee,
        widget.phoneNumber,
        widget.currency,
        widget.token);

    widget.onPaymentResult(_paymentResult!);

    setState(() {
      _isProcessing = false;
      _paymentCompleted = true;
      _isSuccess = _paymentResult!['status'] == 'success';
    });
  }

  Future<void> _verifyPaymentStatus() async {
    if (_paymentResult != null) {
      final statusResult = await PaymentService.checkPaymentStatus(
          widget.itemRef, widget.publicKey);
      if (statusResult['status'] == 'Success') {
        setState(() {
          _paymentCompleted = true;
          _isSuccess = true;
          //_paymentResult = statusResult;
          _paymentResult = {'status': 'success'};
          // Update payment result with the status
        });
      } else {
        // Handle the case where the payment status is still pending or failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(statusResult['error_message'] ??
                  'Unable to verify payment status.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!_paymentCompleted) ...[
            // Payment details layout remains unchanged
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image for Paymooney
                Image.network(
                  'https://paymooney.com/images/logo_paymoone3.jpeg', // Use your local path
                  width: 150,
                  height: 30,
                ),
                Spacer(), // Push the close button to the right
                // Close Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            // Separator
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: 10),

            // Article Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[50],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.articleImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.articleName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.articleDescription,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Price and Fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.lang == 'fr'
                          ? 'Montant à Payer'
                          : 'Amount to paid',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.amount} ${widget.currency}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.lang == 'fr'
                          ? 'Frais: ${widget.fee} ${widget.currency}'
                          : 'Fees: ${widget.fee} ${widget.currency}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Including currency
              ],
            ),
            SizedBox(height: 10),
            PaymentSummaryField(
                label: 'Total',
                value: '${widget.amountToPay} ${widget.currency}',
                isTotal: true), // Including currency
            SizedBox(height: 10),

            PaymentSummaryField(
                label: widget.lang == 'fr'
                    ? 'Numéro de Téléphone'
                    : 'Phone number',
                value: '${widget.phoneNumber}',
                isTotal: true), //

            SizedBox(height: 10),

            // Show payment processing message if processing is true
            if (_isProcessing) ...[
              SizedBox(height: 10),
              if (PaymentService.detectOperator(widget.phoneNumber) == 'orange')
                Text(
                  widget.lang == 'fr'
                      ? "Vous allez recevoir un message pour valider le paiement ou composez #150*50#"
                      : "You are going to receive message to valid payment or dial #150*50#",
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
              if (PaymentService.detectOperator(widget.phoneNumber) == 'mtn')
                Text(
                  widget.lang == 'fr'
                      ? "Vous allez recevoir un message pour valider le paiement ou composez *126*14#"
                      : "You are going to receive message to valid payment or dial *126*14#",
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 10),
            ],
            ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isProcessing
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.lang == 'fr'
                          ? 'Payer ${widget.amountToPay} ${widget.currency}'
                          : 'Pay ${widget.amountToPay} ${widget.currency}',
                      style: TextStyle(fontSize: 18, color: Colors.black87)),
            ),
            SizedBox(height: 0),
            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            // Secured by Paymooney with lock icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: Colors.grey[600]), // Lock icon
                SizedBox(width: 5), // Space between the icon and text
                Text(
                  widget.lang == 'fr' ? 'Sécurisé par' : 'Secured by',
                  style: TextStyle(
                    color: Colors.black, // Change color to blue
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 3),
                Text(
                  'Paymooney',
                  style: TextStyle(
                    color: Colors.blue, // Change color to blue
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ] else if (_isSuccess) ...[
            //widget.onPaymentResult(_paymentResult!), // Call the callback function with the result
            // Success Page
            SuccessPage(
              message: widget.lang == 'en'
                  ? 'Payment Successful!'
                  : 'Paiement Réussi !',
              onContinue: () {
                Navigator.pop(context); // Close the dialog
              },
              lang: widget.lang,
            )
          ] else ...[
            //widget.onPaymentResult(_paymentResult!),
            // Error Page
            ErrorPage(
              errorMessage:
                  widget.lang == 'en' ? 'Payment failed.' : 'Paiement échoué',
              onRetry: () {
                setState(() {
                  _paymentCompleted =
                      false; // Reset to show payment details again
                });
              },
              lang: widget.lang,
              onVerify:
                  _verifyPaymentStatus, // Link to check the payment status
            ),
          ],
        ],
      ),
    );
  }
}
