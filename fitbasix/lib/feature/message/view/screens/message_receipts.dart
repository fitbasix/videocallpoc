// import 'package:cometchat/cometchat_sdk.dart';
// import 'package:fitbasix/core/constants/credentials.dart';
// import 'package:fitbasix/core/reponsive/SizeConfig.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
//
//
// class MessageReceipts extends StatelessWidget {
//
//   final BaseMessage passedMessage;
//   final bool showTime;
//    MessageReceipts(
//       {Key? key, required this.passedMessage, this.showTime = true})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Widget receiptIcon = sentIcon();
//     if (passedMessage.deliveredAt != null) receiptIcon = deliveredIcon();
//     if (passedMessage.readAt != null) receiptIcon = readIcon();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (showTime)
//           Text(
//             receiptFormatter.format(passedMessage.sentAt!),
//             style: TextStyle(color: const Color(0xff141414).withOpacity(0.46),fontSize: 10*SizeConfig.textMultiplier!),
//
//           ),
//         receiptIcon
//       ],
//     );
//   }
//
//   Widget readIcon() {
//     return SvgPicture.asset(
//       "assets/Message Delivered.svg",
//       color: Colors.blue,
//       width: 16,
//       height: 16,
//     );
//   }
//
//   Widget deliveredIcon() {
//     return SvgPicture.asset(
//       "assets/Message Delivered.svg",
//       width: 16,
//       height: 16,
//       color: const Color(0xff141414).withOpacity(0.46),
//     );
//   }
//
//   Widget sentIcon() {
//     return SvgPicture.asset(
//       "assets/Message Sent.svg",
//       width: 16,
//       height: 16,
//       color: const Color(0xff141414).withOpacity(0.46),
//     );
//   }
// }
