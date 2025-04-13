import 'package:ico3_logger/ico3_logger.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class LogUtilities {
  static String getTimeStampedString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
  }

  static String getListStringWOTime(List<LogMessage> llm) =>
      llm.map((objet) => objet.toStringWOTimeStamp()).toList().toString();

  static OutputMode? tryParseOutputMode(String value) {
    for (var out in OutputMode.values) {
      if (value == out.name) {
        return out;
      }
    }
    return null;
  }

  static String getTimeStampedMessage(String message) {
    return '${DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now())} - $message';
  }

  static bool noDisplay = true;

  static void printDebug(String data) {
    if (!noDisplay) {
      LogPrint.print("printDebug --> $data");
    }
  }

  static void consolePrint(String msg, {String color = ""}) {
    if (color.isNotEmpty) {
      LogPrint.coloredPrint(msg, color); // "\x1B[31m");
    } else {
      LogPrint.print(msg);
    }
  }
}
