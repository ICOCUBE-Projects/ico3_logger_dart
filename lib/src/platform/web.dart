import 'dart:html';

class LogIO {
  static print(Object? data) {
    window.console.log('$data');
  }

  static coloredPrint(Object? data, String color) {
    LogIO.print('$data');
  }

  static String get endOfColor => '';

  static String get highLight => '';

  static exitApplication() {}
}
