// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:ktechshop/constants/routes.dart';
import 'package:ktechshop/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:ktechshop/provider/app_provider.dart';
import 'package:ktechshop/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:provider/provider.dart';

class StripHelper {
  static StripHelper instence = StripHelper();
  Map<String, dynamic>? paymentIntent;
  Future<void> makePayment(String amount, BuildContext context) async {
    print(amount);
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      print(amount);
      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'KaaKa',
                  googlePay: gpay))
          .then((value) {});
      // ignore: use_build_context_synchronously
      displayPaymentSheet(context);
    } catch (e) {
      print(e);
    }
  }

  displayPaymentSheet(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        bool value = await FirebaseFirestoreHelper.instance
            .uploadOrderProductFirebase(appProvider.getBuyProductList, context,
                "Paid", appProvider.getUserInformation.address!);
        appProvider.clearBuyProduct();
        if (value) {
          Future.delayed(Duration(seconds: 2), () {
            Routes.instance.push(widget: CustomBottomBar(), context: context);
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {'amount': amount, 'currency': currency};
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              "Bearer sk_test_51NcQH0CizuobP5vVKDY72s3RjPXJ6c0uyHGYZehGXOx3wzrWbKkoMGrbVB0ZC0kW7Oxe9EibT00T03GPlzIkDi6N00LjkfH6eP",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
