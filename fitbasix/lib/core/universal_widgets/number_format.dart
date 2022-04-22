class NumberFormatter {
  static String textFormatter(String currentBalance) {
    //try {

    // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};

    double value = double.parse(currentBalance);

    if (value > 1000 && value < 1000000) {
      // less than a million

      value = value / 1000;

      return value.toStringAsFixed(1) + "K";
    } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
      // less than 100 million

      double result = value / 1000000;

      return result.toStringAsFixed(1) + "M";
    } else if (value >= (1000000 * 10 * 100) &&
        value < (1000000 * 10 * 100 * 100)) {
      // less than 100 billion

      double result = value / (1000000 * 10 * 100);

      return result.toStringAsFixed(1) + "B";
    } else if (value >= (1000000 * 10 * 100 * 100) &&
        value < (1000000 * 10 * 100 * 100 * 100)) {
      // less than 100 trillion

      double result = value / (1000000 * 10 * 100 * 100);

      return result.toStringAsFixed(1) + "T";
    } else {
      return currentBalance;
    }

    //return currentBalance;

    // } catch (e) {

    //   print(e);

    //   return currentBalance;

    // }
  }
}
