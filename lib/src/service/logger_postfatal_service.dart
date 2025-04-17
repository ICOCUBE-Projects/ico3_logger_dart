import 'package:ico3_logger/ico3_logger.dart';

class LoggerPostFatalService extends LogService{

  LoggerPostFatalService(
      {this.size = 10,
      this.autoExit = true}) {
    logList = List<LogMessage?>.filled(size, null);
  }
  late final List<LogMessage?> logList;
  int size;
  int _logPointer = 0;
  bool autoExit;



  @override
  LogError processMessage(LogMessage message) {
    _addMessage(message);
    if (message.level == LogLevel.fatal) {
      _processMessageAndExit();
    }
    return LogError(0);
  }

  _addMessage(LogMessage message) {
    logList[_logPointer] = message;
    _logPointer = (_logPointer + 1) % size;
  }

  List<LogMessage> _getMessageList() {
    List<LogMessage> listMessage = [];
    var ptrLog = _logPointer;
    do {
      var lg = logList[ptrLog];
      if (lg != null) {
        listMessage.add(lg);
      }
      ptrLog = (ptrLog + 1) % size;
    } while (ptrLog != _logPointer);
    return listMessage;
  }

  _processMessageAndExit() {
    if (masterLogger != null) {
      for (var msg in _getMessageList()) {
        masterLogger!.postProcessServiceLogMessage(msg);
      }
    }
    if (autoExit) {
      LogIO.exitApplication();
      // exit(-1);
    }
  }

}
