import 'package:ico3_logger/ico3_logger.dart';

// this is an example of  PostMortem Capture service (Not supported)
class LoggerPostFatalService extends LogService {
  LoggerPostFatalService({this.size = 10, this.autoExit = false}) {
    logList = List<LogMessage?>.filled(size, null);
  }
  late final List<LogMessage?> logList;
  int size;
  int _logPointer = 0;
  bool autoExit;

  @override
  LogError receiveLog(LogMessage message) {
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
      masterLogger!.disableAllOutputs();
      // exit(-1);
    }
  }
}
