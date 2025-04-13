import 'package:ico3_logger/ico3_logger.dart';

class LoggerFile extends LoggerFileBase {
  LoggerFile(
      {required super.append,
      required super.logFileName,
      super.flush = true,
      super.loggerID = '',
      super.format2File = SaveFormat.text});

  // static LogError saveMessageList(
  //     List<LogMessage> messageList, String filePath, SaveFormat format,
  //     {bool withCategory = false,
  //     bool envActive = false,
  //     bool withTimeLine = false,
  //     String header = ''}) {
  //   return LogError(-3, message: 'Function not supported');
  // }

  static String? readStringFile(String path) {
    return null;
  }
}
