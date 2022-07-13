import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, this.initialUrl}) : super(key: key);

  final String? initialUrl;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static var dio = DioUtil().getInstance();
  Uuid uuid = const Uuid();
  InAppWebView inAppWebView = InAppWebView();
  bool isLoading = true;
  InAppWebViewController? webViewController;

  var accessCode = 'USyYFjt6JLdOqLvng6Ar';
  var merchantIdendifier = '7f2c4c82';
  var language = 'en';
  var merchantReference = '165760244160';
  var returnUrl = 'https://7e1d-122-161-82-110.in.ngrok.io/api/payment/testing';
  var cardNumber = '4005550000000001';
  var expiryDate = '2505';
  var signature = '';
  var serviceCommand = 'TOKENIZATION';
  var cardSecurityCode = '123';

  var paymentForm = {};

  static Future<String> getPaymentLink(
      {required String accessCode,
      required String merchantIdentifier,
      required String merchantReference,
      required String currency,
      required String customerEmail,
      required String language,
      required String amount,
      required String tokenName,}) async {
    dio!.options.headers["language"] = "1";
    // dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getPaymentLink, data: {
      "command": "PURCHASE",
      "access_code": accessCode,
      "merchant_identifier": merchantIdentifier,
      "merchant_reference": merchantReference,
      "currency": currency,
      "customer_email": customerEmail,
      "language": language,
      "amount": amount,
      "token_name": tokenName,
      "return_url": "${ApiUrl.liveBaseURL}/api/payment/paymentWebhook"
    });
    return jsonDecode(response.toString())["response"]["paymentLink"];
  }

  @override
  void initState() {
    merchantReference = DateTime.now().microsecondsSinceEpoch.toString();

    var signatureString =
        '25i9lP79iW0.6Lk4I0diMq)-access_code=${accessCode}language=${language}merchant_identifier=${merchantIdendifier}merchant_reference=${merchantReference}return_url=${returnUrl}service_command=${serviceCommand}25i9lP79iW0.6Lk4I0diMq)-';

    var bytes = utf8.encode(signatureString.toString());

    var digest = sha256.convert(bytes);

    signature = digest.toString();

    printInfo(info: digest.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (webViewController != null) {
                webViewController!.reload();
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: widget.initialUrl != null? Uri.parse(widget.initialUrl!) :Uri.parse(
                  'https://sbcheckout.PayFort.com/FortAPI/paymentPage?access_code=${accessCode}&card_number=${cardNumber}&card_security_code=${cardSecurityCode}&expiry_date=${expiryDate}&language=${language}&merchant_identifier=${merchantIdendifier}&merchant_reference=${merchantReference}&return_url=${returnUrl}&service_command=${serviceCommand}&signature=${signature}'),
              method: 'POST',
            ),
            onLoadStop: (controller, __) async {
              setState(() {
                isLoading = false;
              });
              printInfo(info: "=====================> Page Loaded"); //
              var url = await controller.getUrl();
              printInfo(info: url.toString());
              var response = await controller.evaluateJavascript(
                contentWorld: ContentWorld.PAGE,
                source: "document.documentElement.innerHTML",
              );
              final document = parse(response);
              final String parsedString =
                  parse(document.body!.text).documentElement!.text;

              printInfo(info: parsedString);
              var paymentResponse = await getPaymentLink(
                accessCode: accessCode,
                amount: "100",
                currency: "AED",
                customerEmail: "email@gmail.com",
                language: "en",
                merchantIdentifier: merchantIdendifier,
                merchantReference: merchantReference,
                tokenName: jsonDecode(parsedString)["response"]["token_name"]
              );
              printInfo(info: paymentResponse);
              Navigator.pop(context,paymentResponse);
            },
            onLoadError: (controller, _, __, ___) {
              setState(() {
                isLoading = false;
              });
            },
            onWebViewCreated: (controller) async {
              webViewController = controller;
            },
          ),
          if (isLoading)
            Center(
              child: SizedBox(
                height: 30 * SizeConfig.widthMultiplier!,
                width: 30 * SizeConfig.widthMultiplier!,
                child: CustomizedCircularProgress(),
              ),
            ),
        ],
      ),
    );
  }
}
