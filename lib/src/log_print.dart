import 'package:ico3_logger/ico3_logger.dart';
import 'dart:core';

class LogPrint {
  static void Function(Object?)? onPrint;
  static ViewerCommunication? viewer;
  static void Function(Object?, String?)? onViewerPrint;
  static void print(Object? data) {
    if (viewer?.isRunning == true) {
      return  viewer!.print(data, null);
    }

    if (onPrint == null) {
      return LogIO.print('$data');
    }
    return onPrint?.call(data);
  }

  static void coloredPrint(Object? data, String color) {
    if (viewer?.isRunning == true) {
      return  viewer!.print(data, color);
    }
    LogIO.coloredPrint(data, color);
  }
}
