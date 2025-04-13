class LogIO {
  static print(Object? data) {
    throw UnsupportedError('Unsupported print function');
  }

  static printWithColor(Object? data, String color) {
    throw UnsupportedError('Unsupported print function');
  }

  static coloredPrint(Object? data, String color) {
    LogIO.print('$data');
  }

  static String get endOfColor => '';
  static String get highLight => '';

  static exitApplication() {
    throw UnsupportedError('Unsupported exit function');
  }
}
