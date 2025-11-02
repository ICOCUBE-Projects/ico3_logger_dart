import 'package:ico3_logger/ico3_logger.dart';

enum LogStatus { idle, running, closing, closed, error }

abstract class LoggerFileBase {
  // File? _logFile;
  // RandomAccessFile? _fileSync;
  LogStatus logStatus = LogStatus.idle;
  SaveFormat format2File;
  String loggerID = '';
  // String header = '';
  String logFileName;
  bool append;
  bool flush;
  bool first = true;

  LoggerFileBase(
      {required this.append,
      required this.logFileName,
      required this.loggerID,
      required this.format2File,
      this.flush = true});

  String getLoggerFullPath() {
    return '';
  }

  void writeHeader() {
    switch (format2File) {
      case SaveFormat.csv:
        writeStringSync('${LogMessage.getCSVHeader()}\n');
        break;
      case SaveFormat.text:
        break;
      case SaveFormat.json:
        writeStringSync('{"logList": [\n');
        first = true;
        break;
    }
  }

  void writeFooter() {
    switch (format2File) {
      case SaveFormat.csv:
        break;
      case SaveFormat.text:
        break;
      case SaveFormat.json:
        writeStringSync('\n]}\n');
        break;
    }
  }

  LogError writeStringSync(String data) {
    return LogError(-3, message: 'Function not supported');
  }

  LogStatus get currentStatus => logStatus;

  closeFile() {}

  LogError saveMessage(LogMessage message) {
    switch (format2File) {
      case SaveFormat.text:
        var strMessage = message.getStringMessageForLogger(true, true, true);
        var fullMessage = '($loggerID) $strMessage';
        return writeStringSync('$fullMessage\n');
      case SaveFormat.csv:
        return writeStringSync(message.getCSVString());
      case SaveFormat.json:
        return writeStringSync(message.getJsonString(first));
    }
  }

  LogError saveMessageList(List<LogMessage> messageList,
      {bool withCategory = false,
      bool envActive = false,
      bool withTimeLine = false}) {
    String content = '';
    try {
      switch (format2File) {
        case SaveFormat.json:
          final List<String> jsonItems =
              messageList.map((item) => item.getJsonString(true)).toList();
          content = jsonItems.join(',\n');
          break;
        case SaveFormat.csv:
          content += messageList.map((item) => item.getCSVString()).join();
          break;
        default:
          content += messageList
              .map((item) => item.getStringMessageForLogger(
                  withCategory, envActive, withTimeLine))
              .join('\n');
          break;
      }
      writeStringSync(content);
      closeFile();
      return LogError(0);
    } catch (e) {
      return LogError(-3);
    }
  }
}
