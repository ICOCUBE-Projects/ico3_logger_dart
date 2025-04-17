import 'dart:core';
import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

class Logger extends LoggerBase {
  Logger(super.loggerID, super.manager);

  // LoggerFile? loggerFile;

  //   SaveFormat format2File = SaveFormat.text;
  LoggerFile? loggerFile;

  @override
  LogError internalProcessLogMessage(LogMessage msg) {
    var err = LogError(1);
    var message = msg;
    // each Logger have it's own timeLine reference
    // You must clone LogMessage for each logger  to set timeLine
    // about critical mode timeLine is set inside CriticalMode Process
    if (useTimeLine || msg.isCritical) {
      message = msg.clone();
      if (!message.isCritical) {
        message.timeLine = Timeline.now - timeLineStart;
      }
    }

    if (logService != null) {
      logService?.receiveLog(msg);
      return err;
    }
    return postProcessLogMessage(message);
  }


  @override
  LogError postProcessLogMessage(LogMessage message){
    var err = LogError(1);

    if (useConsole) {
      consolePrint(message);
    }

    if (useFile && loggerFile != null) {
      err.mergeError(loggerFile!.saveMessage(message));
    }

    if (useProcess && onLogMessage != null) {
      err.mergeError(processExternalMessage(message));
    }

    if (useStorage) {
      messageList.add(message);
    }

    return err;
  }

  consolePrint(LogMessage message) {
    var fullMessage = '';
    fullMessage += printServiceMessage(message);
    fullMessage += printLoggerMessage(message);
    fullMessage += printTimeStampMessage(message);
    fullMessage += printTimeLineMessage(message);
    fullMessage += printLevelMessage(message);
    fullMessage += printCategoryMessage(message);
    fullMessage += message.message;
    fullMessage += printEnvironmentMessage(message);
    if (decoration == Decoration.full) {
      var messageColor = getMessageColor(message.level);
      fullMessage = '$messageColor$fullMessage$eOC';
    }
    LogPrint.print(fullMessage);
    return;
  }
  String printServiceMessage(LogMessage message) {
    if(message.serviceTag == null){
      return '';
    }
    return '${message.serviceTag.toString()}\t';

  }

  String printLoggerMessage(LogMessage message) {
    if (withLoggerId) {
      return decoration == Decoration.simple
          ? '($hl$loggerID$eOC) '
          : '($loggerID) ';
    }
    return '';
  }
  String printEnvironmentMessage(LogMessage message) {
    if (withEnvironment) {
      return message.environment.isEmpty? '':
          ' {${message.environment}}';
    }
    return '';
  }

  String printTimeStampMessage(LogMessage message) {
    if (withTimeStamp) {
      return '${message.timeStamp} ';
    }
    return '';
  }

  String printTimeLineMessage(LogMessage message) {
    if (withTimeLine) {
      return message.isCritical
          ? '<${message.timeLine}>. '
          : '<${message.timeLine}> ';
    }
    return '';
  }

  String printLevelMessage(LogMessage message) {
    switch (decoration) {
      case Decoration.emoji:
        var emoji = getMessageEmoji(message.level);
        return '[$emoji${message.level.name}] ';
      case Decoration.level:
      case Decoration.simple:
        var levelColor = getLevelColor(message.level);
        return '[$levelColor${message.level.name}$eOC] ';
      default:
        return '[${message.level.name}] ';
    }
  }

  String printCategoryMessage(LogMessage message) {
    if (message.category.isEmpty) {
      return '';
    }
    if (withCategory) {
      if (decoration == Decoration.simple) {
        return '($hl${message.category}$eOC) --> ';
      }
      return '(${message.category}) --> ';
    }
    return '';
  }

  String get eOC => LogIO.endOfColor;
  String get hl => LogIO.highLight;

  LogError processExternalMessage(LogMessage fullMessage) {
    if (onLogMessage != null) {
      onLogMessage?.call(fullMessage);
      LogError(0);
    }
    return LogError(-1, message: 'Callback not implemented');
  }

  @override
  LogStatus getFileSaverStatus() {
    return (loggerFile != null) ? loggerFile!.currentStatus : LogStatus.idle;
  }

  @override //modify
  LogError openFileSaver(
      {required String logFileName,
      bool append = false,
      bool flush = true,
      SaveFormat format = SaveFormat.text,
      String header = ''}) {
    if (loggerFile == null) {
      if (logFileName.isNotEmpty) {
        //  if (format == SaveFormat.text || format == SaveFormat.csv) {
        loggerFile = LoggerFile(
            logFileName: logFileName,
            loggerID: loggerID,
            append: append,
            flush: flush,
            format2File: format);
//           useFile = true;

        return LogError(0);
        // }
      }
      return LogError(-1, message: 'LoggerFileName Error');
    }
    return LogError(-1, message: 'LoggerFile Error');
  }

  @override
  bool logFileReady() {
    // modify
    return loggerFile != null;
  }

  @override
  LoggerFile? getOutputFileActive() {
    return loggerFile;
  }

  @override
  LogError closeFileSaver() {
    //modify
    if (loggerFile == null) {
      return LogError(-1, message: 'No LoggerFile Error');
    }
    loggerFile?.closeFile();
    loggerFile = null;
    useFile = false;
    return LogError(0);
  }

  @override
  LogError closeLogger() {
    try {
      closeFileSaver();
      return LogError(0);
    } catch (ex) {
      return LogError(-1, message: ex.toString());
    }
  }

  @override
  LogError saveMessageList(String filePath, SaveFormat format,
      {bool flush = true, bool clear = false}) {
    var err = LoggerFile(
            logFileName: filePath,
            format2File: format,
            append: false,
            flush: flush)
        .saveMessageList(messageList,
            withTimeLine: withCategory,
            envActive: envActive,
            withCategory: withTimeLine);
    if (clear) {
      messageList.clear();
    }
    return err;
  }

  @override
  LogError printMessageList({bool clear = false}) {
    for (var lg in messageList) {
      var strMessage =
          lg.getStringMessageForLogger(withCategory, envActive, withTimeLine);
      var fullMessage = '($loggerID) $strMessage';
      LogPrint.print(fullMessage);
    }
    if (clear) {
      messageList.clear();
    }
    return LogError(0);
  }

  @override
  LogError processMessageList(
      {Function(LogMessage message)? onLogMessage, bool clear = false}) {
    var err = LogError(0);
    if (onLogMessage != null) {
      for (var lg in messageList) {
        onLogMessage.call(lg);
      }
      return LogError(0);
    }
    for (var lg in messageList) {
      err.mergeError(processExternalMessage(lg));
    }
    if (clear) {
      messageList.clear();
    }
    return err;
  }

  @override
  LogError clearMessageList() {
    messageList.clear();
    return LogError(0);
  }
}
