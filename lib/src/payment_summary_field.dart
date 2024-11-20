import 'package:flutter/material.dart';

class PaymentSummaryField extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const PaymentSummaryField({
    Key? key,
    required this.label,
    required this.value,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal)),
          ),
          Container(
            child: Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          )
        ],
      ),
    );
    /*return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );*/
  }
}
