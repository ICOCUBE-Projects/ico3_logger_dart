class LogIO {
  static void print(Object? data) {
    throw UnsupportedError('Unsupported print function');
  }

  static void printWithColor(Object? data, String color) {
    throw UnsupportedError('Unsupported print function');
  }

  static void coloredPrint(Object? data, String color) {
    LogIO.print('$data');
  }

  static String get endOfColor => '';
  static String get highLight => '';

  static void exitApplication() {
    throw UnsupportedError('Unsupported exit function');
  }
}
