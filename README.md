# PAYMOONEY API Integration Flutter Package

A Flutter package that simplifies integration with the PAYMOONEY API for seamless payment processing in your Flutter applications.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Example](#example)
- [Contributing](#contributing)
- [License](#license)
- [Disclaimer](#disclaimer)

## Features

- Easy integration with the PAYMOONEY API for various payment methods.
- Supports payment processing, refund requests, and transaction queries.
- Handles success and error responses effectively.
- Lightweight and user-friendly API.

## Installation

To use this package, add it to your project's `pubspec.yaml` file:

```yaml
dependencies:
  paymooney_gateway: ^0.0.2

```

 ## Usage
 1. In your file add the following import:

 ```dart
import 'package:paymooney_gateway/paymooney_gateway.dart';
```
2. Call the `checkout` method and handle the respons
```dart
await PaymooneyGateway.init(
      context,
      articleName: 'Sample Article',
      articleDescription: 'This is a description.',
      articleImage: 'https://via.placeholder.com/60', // or your app logo
      amount: '100', // amount
      phoneNumber: 'xxxxx', // phone number without country code
      currency: 'xaf', // currency
      publickKey:
          'PK_6KUj3tuKUrabAF4g0G2W', // your public key from paymooney dashboard
      itemRef:
          'code_test_15', // unique identifier for your payment on your side
      lang: 'fr', // language take 2 values: fr ou en
      onPaymentResult: (Map<String, dynamic> paymentResult) {
        if (paymentResult['status'] == 'success') {
          // Handle successful payment result
          //Write your logic
          // Navigator.pop(context); // if you want to disable the default success dialog
          print("Paiement successfuly !");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Paiement successfuly !")));
        } else {
          // Handle payment error
          print("error: Paiement has failed !");
          // Navigator.pop(context); // if you want to disable the default failed dialog
          // Note: Some time paiement return error due of internet connection or network from operator,
          //to make sure you can call call paymentstatus (/api/v1.0/mp/paymentstatus)
          //
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "error: Paiement has failed:" + paymentResult['message'])));
        }
      },
    );
```

## Contributing
Contributions are welcome! To contribute to this package, please follow these steps:

Fork the repository.
Create a new branch (git checkout -b feature-branch).
Make your modifications.
Commit your changes (git commit -m 'Add some feature').
Push to the branch (git push origin feature-branch).
Open a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Disclaimer
This package is intended for integration with the PAYMOONEY API for payment processing. By using this package, you acknowledge that you have reviewed the PAYMOONEY API documentation and agree to comply with all terms and conditions set forth by PAYMOONEY. The authors of this package make no representations about the suitability of this software for any purpose. Use at your own risk.

## Support
For support and more information, please refer to the official infos@paymooney.com documentation.




