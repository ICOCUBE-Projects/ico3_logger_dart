import 'package:web/web.dart';
import 'dart:js_interop';

class LogIO {
  static print(Object? data) {
    console.log(convertObjectToJsAny(data));
  }

  static JSAny? convertObjectToJsAny(Object? dartObject) {
    if (dartObject == null) return null;
    return dartObject.toString().toJS;
  }

  static coloredPrint(Object? data, String color) {
    LogIO.print('$data');
  }

  static String get endOfColor => '';

  static String get highLight => '';

  static exitApplication() {}
}
