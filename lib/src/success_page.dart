import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  final String transactionId;
  final VoidCallback onContinue;

  const SuccessPage({
    Key? key,
    required this.message,
    required this.transactionId,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.check_circle, size: 80, color: Colors.green),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Transaction ID: $transactionId',
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Continue', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
