import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String message;
  final String lang;
  final VoidCallback onContinue;

  const SuccessPage({
    Key? key,
    required this.message,
    required this.lang,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(lang == 'en' ? 'Continue' : 'Continuer',
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
