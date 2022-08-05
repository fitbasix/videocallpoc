import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:fitbasix/core/api_service/dio_service.dart';
import 'package:fitbasix/core/constants/app_text_style.dart';
import 'package:fitbasix/core/constants/color_palette.dart';
import 'package:fitbasix/core/constants/image_path.dart';
import 'package:fitbasix/core/reponsive/SizeConfig.dart';
import 'package:fitbasix/core/routes/api_routes.dart';
import 'package:fitbasix/core/routes/app_routes.dart';
import 'package:fitbasix/core/universal_widgets/customized_circular_indicator.dart';
import 'package:fitbasix/feature/Home/controller/Home_Controller.dart';
import 'package:fitbasix/feature/get_trained/controller/trainer_controller.dart';
import 'package:fitbasix/feature/get_trained/model/PlanModel.dart';
import 'package:fitbasix/feature/get_trained/services/trainer_services.dart';
import 'package:fitbasix/feature/log_in/services/login_services.dart';
import 'package:fitbasix/feature/plans/controller/plans_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({
    Key? key,
    this.initialUrl,
    this.cardNumber,
    this.expiryDate,
    this.cardSecurityCode,
    this.userName,
    this.amount,
    this.planId,
    this.trainerId,
    this.planDuration,
    this.selectedPlan,
  }) : super(key: key);

  final String? initialUrl;
  final String? cardNumber;
  final String? expiryDate;
  final String? cardSecurityCode;
  final String? userName;
  final String? amount;
  final String? planId;
  final String? trainerId;
  final int? planDuration;
  final Plan? selectedPlan;

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  static var dio = DioUtil().getInstance();
  Uuid uuid = const Uuid();
  bool isLoading = true;
  InAppWebViewController? webViewController;
  TrainerController trainerController = Get.find<TrainerController>();
  var planController = Get.find<PlansController>();

  var accessCode = 'USyYFjt6JLdOqLvng6Ar';
  var merchantIdendifier = '7f2c4c82';
  var language = 'en';
  var merchantReference = '165760244160';
  var returnUrl = '${ApiUrl.liveBaseURL}/api/payment/tokenizationUrl';
  var cardNumber = '';
  var expiryDate = '';
  var signature = '';
  var serviceCommand = 'TOKENIZATION';
  var cardSecurityCode = '';

  var paymentForm = {};

  static Future<Map<String, dynamic>> getPaymentLink({
    required String accessCode,
    required String merchantIdentifier,
    required String merchantReference,
    required String currency,
    required String customerEmail,
    required String language,
    required String amount,
    required String tokenName,
    required String trainerId,
    required String planId,
    required int planDuration,
  }) async {
    dio!.options.headers["language"] = "1";
    dio!.options.headers['Authorization'] = await LogInService.getAccessToken();
    var response = await dio!.post(ApiUrl.getPaymentLink, data: {
      "command": "PURCHASE",
      "access_code": accessCode,
      "merchant_extra": trainerId,
      "merchant_extra1": planId,
      "merchant_extra3": planDuration,
      "merchant_identifier": merchantIdentifier,
      "merchant_reference": merchantReference,
      "currency": currency,
      "customer_email": customerEmail,
      "language": language,
      "amount": amount,
      "token_name": tokenName,
      "return_url": "${ApiUrl.liveBaseURL}/api/payment/purchaseUrl"
    });
    return {
      "response_code": response.statusCode,
      "response_message": response.statusMessage,
      "payment_link": jsonDecode(response.toString())["response"]["paymentLink"]
    };
  }

  @override
  void initState() {
    merchantReference = DateTime.now().microsecondsSinceEpoch.toString();
    if (widget.cardNumber != null) {
      cardNumber = widget.cardNumber!.replaceAll(' ', '');
      var dates = widget.expiryDate!.split('/');
      expiryDate = dates[1] + dates[0];
      cardSecurityCode = widget.cardSecurityCode!;
    }

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
    return WillPopScope(
      onWillPop: () {
        // if (widget.initialUrl == null) {
        //   return Future.value(false);
        // } else {
        return Future.value(true);
        // }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: widget.initialUrl != null
                    ? Uri.parse(widget.initialUrl!)
                    : Uri.parse(
                        'https://sbcheckout.PayFort.com/FortAPI/paymentPage?access_code=${accessCode}&card_number=${cardNumber}&card_security_code=${cardSecurityCode}&expiry_date=${expiryDate}&language=${language}&merchant_identifier=${merchantIdendifier}&merchant_reference=${merchantReference}&return_url=${returnUrl}&service_command=${serviceCommand}&signature=${signature}'),
                method: 'POST',
              ),
              onLoadStop: (controller, __) async {
                if (widget.initialUrl == null) {
                  setState(() {
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
                var response = await controller.evaluateJavascript(
                    contentWorld: ContentWorld.PAGE,
                    source: "document.documentElement.innerHTML");
                final document = parse(response);
                final String parsedString =
                    parse(document.body!.text).documentElement!.text;
                printInfo(info: parsedString);

                // if(widget.initialUrl == null && !parsedString.contains('18000')){
                //   Navigator.pop(context);
                //   Get.dialog(
                //       const SuccessFailureDialog(
                //       message: 'There is an error. Please try again later.',
                //       isSuccess: false));
                // }

                if (widget.initialUrl == null) {
                  if (jsonDecode(parsedString)["response"]["response_code"] ==
                      200) {
                    var paymentResponse = await getPaymentLink(
                      accessCode: accessCode,
                      amount: widget.amount!,
                      currency: "AED",
                      customerEmail: "email@gmail.com",
                      language: "en",
                      planId: widget.planId!,
                      trainerId: widget.trainerId!,
                      merchantIdentifier: merchantIdendifier,
                      merchantReference: merchantReference,
                      planDuration: widget.planDuration!,
                      tokenName: jsonDecode(parsedString)["response"]
                          ["token_name"],
                    );
                    printInfo(info: paymentResponse.toString());
                    Navigator.pop(context, paymentResponse);
                  } else {
                    Navigator.pop(context);
                    Get.dialog(SuccessFailureDialog(
                        message: jsonDecode(parsedString)["response"]
                            ["error_message"],
                        isSuccess: false));
                  }
                } else {
                  if (jsonDecode(parsedString)["response"]["response_code"] ==
                      "14000") {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    planController.clearValues();
                    List<int> selectedDays = [];
                    for (var days in trainerController.selectedDays) {
                      selectedDays.add(trainerController
                          .weekAvailableSlots[trainerController
                              .weekAvailableSlots
                              .indexWhere((element) => element.id == days)]
                          .day!);
                    }

                    bool booked = await TrainerServices.bookSlot(
                        trainerController.selectedDays,
                        planController.selectedPlan!.id!,
                        trainerController.selectedTimeSlot.value,
                        selectedDays,
                        trainerController.atrainerDetail.value.user?.id ?? '',
                        context);

                    if (booked == true) {
                      Get.dialog(const SuccessFailureDialog(
                          message: "Booking Successful", isSuccess: true));

                      trainerController.enrolledTrainer
                          .add(trainerController.atrainerDetail.value.id!);
                      trainerController.setUp();

                      trainerController.atrainerDetail.value.isEnrolled = true;
                      final HomeController _homeController = Get.find();
                      _homeController.setup();
                      trainerController.setUp();
                    } else {
                      Get.dialog(SuccessFailureDialog(
                          message: jsonDecode(parsedString)["response"]
                              ["error_message"],
                          isSuccess: false));
                    }
                  } else {
                    Navigator.pop(context);

                    Get.dialog(SuccessFailureDialog(
                        message: jsonDecode(parsedString)["response"]
                            ["error_message"],
                        isSuccess: false));
                  }
                }
              },
              onLoadError: (controller, _, __, ___) {
                setState(() {
                  isLoading = false;
                });
              },
              onProgressChanged: (
                controller,
                _,
              ) async{
                if (widget.initialUrl == null && isLoading == false) {
                  setState(() {
                    isLoading = true;
                  });
                }
                var url = await controller.getUrl();
                printInfo(info: url.toString());
                if(url.toString() == "${ApiUrl.liveBaseURL}/api/payment/purchaseUrl"){
                  printInfo(info:'=================> Matched');
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              onWebViewCreated: (controller) async {
                webViewController = controller;
              },
            ),
            if (isLoading)
              Container(
                height: Get.height,
                width: Get.width,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            if (isLoading)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Payment Processing ...',
                      style: AppTextStyle.normalWhiteText
                          .copyWith(fontSize: 16 * SizeConfig.textMultiplier!),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 90 * SizeConfig.widthMultiplier!,
                      child: const LinearProgressIndicator(
                        color: kGreenColor,
                        backgroundColor: kPureWhite,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SuccessFailureDialog extends StatelessWidget {
  const SuccessFailureDialog({
    Key? key,
    required this.isSuccess,
    required this.message,
  });

  final bool isSuccess;
  final String message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Get.back();
      },
      child: Container(
        color: kBlack.withOpacity(0.6),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(
                  vertical: 0, horizontal: 10 * SizeConfig.widthMultiplier!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8 * SizeConfig.imageSizeMultiplier!)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              content: Stack(
                children: [
                  if (isSuccess)
                    SizedBox(
                      height: 330 * SizeConfig.heightMultiplier!,
                      width: 250 * SizeConfig.widthMultiplier!,
                      child: Image.asset(
                        ImagePath.animatedCongratulationIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Container(
                    height: 330 * SizeConfig.heightMultiplier!,
                    width: 250 * SizeConfig.widthMultiplier!,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isSuccess
                              ? SizedBox(
                                  height: 42 * SizeConfig.heightMultiplier!,
                                  width: 42 * SizeConfig.widthMultiplier!,
                                  child: SvgPicture.asset(
                                      ImagePath.greenRightTick))
                              : const Icon(
                                  Icons.info_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                          SizedBox(
                            height: 8 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            isSuccess ? "congratulations".tr : "Ooops!",
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 24 * SizeConfig.textMultiplier!,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 8 * SizeConfig.heightMultiplier!,
                          ),
                          Text(
                            message,
                            style: AppTextStyle.black400Text.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
