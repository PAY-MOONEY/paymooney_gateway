import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onVerify;
  final String lang;

  const ErrorPage({
    Key? key,
    required this.errorMessage,
    this.onRetry,
    this.onVerify,
    required this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error, size: 80, color: Colors.red),
          SizedBox(height: 20),
          Text(
            errorMessage,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(lang == 'en' ? 'Try Again' : 'Reéssayez',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          SizedBox(height: 10),
          Text('-OR-', style: TextStyle(fontSize: 16, color: Colors.black)),
          SizedBox(height: 10),
          if (onVerify != null)
            TextButton(
              onPressed: onVerify,
              child: Text(
                  lang == 'en'
                      ? 'Verify Payment Status'
                      : 'Verifiez le status du paiement',
                  style: TextStyle(color: Colors.orange, fontSize: 16)),
            ),
        ],
      ),
    );
  }
}
