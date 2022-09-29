import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
        text: newValue.text[0].toUpperCase() + newValue.text.substring(1));
  }
}

class CapitalizeFunction {
  static String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
