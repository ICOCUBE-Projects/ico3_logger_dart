import 'package:ico3_logger/ico3_logger.dart';
import 'dart:core';

class LogPrint {
  static Function(Object?)? onPrint;
  static print(Object? data) {
    if (onPrint == null) {
      return LogIO.print('$data');
    }
    return onPrint?.call(data);
  }

  static coloredPrint(Object? data, String color) {
    LogIO.coloredPrint(data, color);
  }
}
