import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

enum LogStatus { idle, running, closing, closed, error }

abstract class LoggerBase {
  LoggerBase(this.loggerID, this.manager);
  String loggerID;
  LoggerManager manager;
  Map<String, LogSelector> logSelectorMap = {};
  Map<String, LogSelector> logExcludeMap = {};
  String debugText = '';
  bool lockUpdate = false;
  bool envActive = true;
  bool withCategory = true;
  bool withTimeLine = false;
  bool withTimeStamp = false;
  bool withLoggerId = false;
  bool useConsole = true;
  bool useFile = false;
  bool useProcess = false;
  bool useStorage = false;
  bool timeLineEnable = false;

  List<LogMessage> messageList = [];

  int timeLineStart = 0;
  bool get useTimeLine => timeLineEnable; //  timeLineStart != 0;
  Decoration decoration = Decoration.none;

  Function(LogMessage message)? onLogMessage;

  LogError processLogMessage(LogMessage message) {
    if (isLogMessageMatchExclude(message)) {
      return LogError(-1, message: 'Log excluded');
    }
    if (isLogMessageMatchSelect(message)) {
      return internalProcessLogMessage(message);
    }
    return LogError(-1, message: 'Log don\'t match');
  }

  bool isLogMessageMatchSelect(LogMessage message) {
    for (var selector in logSelectorMap.values) {
      if (selector.isMessageMatch(message)) {
        return true;
      }
    }
    return false;
  }

  bool isLogMessageMatchExclude(LogMessage message) {
    for (var selector in logExcludeMap.values) {
      var rsl = selector.isMessageMatch(message);
      if (rsl) {
        return true;
      }
    }
    return false;
  }

  //modify
  LogError setOutputAvailable(String availableOutputs) {
    if (lockUpdate) {
      return LogError(-1, message: 'update locked');
    }
    // var err = LogError(0);
    var newUseConsole = false;
    var newUseFile = false;
    var newUseProcess = false;
    var newUseStorage = false;

    LogUtilities.printDebug('Change OutputAvailable: $availableOutputs');

    var outList = availableOutputs.split(',');

    for (var output in outList) {
      switch (output.trim().toLowerCase()) {
        case 'console':
          newUseConsole = true;
          break;
        case 'file':
          newUseFile = true;
          break;
        case 'process':
          newUseProcess = true;
          break;
        case 'storage':
          newUseStorage = true;
          break;
      }
    }
    return enableOutputs(
        newUseConsole: newUseConsole,
        newUseProcess: newUseProcess,
        newUseStorage: newUseStorage,
        newUseFile: newUseFile);
  }

  // Modify
  LogError enableOutputs(
      {required bool newUseConsole,
      required bool newUseProcess,
      required bool newUseStorage,
      required bool newUseFile}) {
    var err = LogError(0);

    if (useConsole != newUseConsole) {
      useConsole = newUseConsole;
    }
    if (useProcess != newUseProcess) {
      useProcess = newUseProcess;
    }
    if (useStorage != newUseStorage) {
      useStorage = newUseStorage;
    }
    if (useFile != newUseFile) {
      if (newUseFile) {
        if (!logFileReady()) {
          newUseFile = false;
          err = LogError(-2, message: 'Log File not available');
        }
      }
      useFile = newUseFile;
    }
    return err;
  }

  LogError disableConsoleOutput() {
    useConsole = false;
    return LogError(0);
  }

  LogError disableFileOutput() {
    closeFileSaver();
    useFile = false;
    return LogError(0);
  }

  LogError disableProcessOutput() {
    useProcess = false;
    return LogError(0);
  }

  LogError disableStorageOutput() {
    useStorage = false;
    return LogError(0);
  }

  LogError disableAllOutputs() {
    disableStorageOutput();
    disableProcessOutput();
    disableFileOutput();
    disableConsoleOutput();
    return LogError(0);
  }

  // Modify
  LogError enableConsoleOutput(bool exclusif) {
    return exclusif
        ? enableOutputs(
            newUseConsole: true,
            newUseProcess: false,
            newUseStorage: false,
            newUseFile: false)
        : enableOutputs(
            newUseConsole: true,
            newUseProcess: useProcess,
            newUseStorage: useStorage,
            newUseFile: useFile);
  }

  // Modify
  LogError enableFileOutput(bool exclusif,
      {String? logFileName,
      bool append = false,
      bool flush = true,
      SaveFormat format = SaveFormat.text}) {
    if (logFileName != null) {
      if (logFileName.isNotEmpty) {
        if (logFileReady()) {
          closeFileSaver();
        }
        openFileSaver(
            logFileName: logFileName,
            append: append,
            flush: flush,
            format: format);
      }
    }
    return exclusif
        ? enableOutputs(
            newUseConsole: false,
            newUseProcess: false,
            newUseStorage: false,
            newUseFile: true)
        : enableOutputs(
            newUseConsole: useConsole,
            newUseProcess: useProcess,
            newUseStorage: useStorage,
            newUseFile: true);
  }

  // Modify
  LogError enableProcessOutput(
      bool exclusif, Function(LogMessage message)? onLogMessageX) {
    if (onLogMessageX != null) {
      onLogMessage = onLogMessageX;
    }
    return exclusif
        ? enableOutputs(
            newUseConsole: false,
            newUseProcess: true,
            newUseStorage: false,
            newUseFile: false)
        : enableOutputs(
            newUseConsole: useConsole,
            newUseProcess: true,
            newUseStorage: useStorage,
            newUseFile: useFile);
  }

  // Modify
  LogError enableStorageOutput(bool exclusif) {
    return exclusif
        ? enableOutputs(
            newUseConsole: false,
            newUseProcess: false,
            newUseStorage: true,
            newUseFile: false)
        : enableOutputs(
            newUseConsole: useConsole,
            newUseProcess: useProcess,
            newUseStorage: true,
            newUseFile: useFile);
  }

  List<String> getOutputsActive() {
    List<String> outPuts = [];
    if (useStorage) {
      outPuts.add('storage');
    }
    if (useProcess) {
      outPuts.add('process');
    }
    if (useFile) {
      outPuts.add('file');
    }
    if (useConsole) {
      outPuts.add('console');
    }
    return outPuts;
  }

  LoggerFileBase? getOutputFileActive();

  LogError setCategories(String categories, {bool clear = false}) {
    if (lockUpdate) {
      return LogError(-1, message: 'update locked');
    }
    if (categories.contains('<clear>')) {
      logSelectorMap.clear();
      logExcludeMap.clear();
      categories = categories.replaceAll('<clear>', '');
    }
    if (clear) {
      logSelectorMap.clear();
      logExcludeMap.clear();
    }

    var err = LogError(0);
    var propList = categories.split(',');
    for (var cate in propList) {
      err.mergeError(_setCategory(cate));
    }
    return err;
  }

  LogError _setCategory(String cat) {
    var category = cat.toLowerCase();
    try {
      var logSel = LogSelector.fromString(category);
      if (logSel.isExclusion) {
        if (logSel.logLevel == LogLevel.none) {
          logExcludeMap.remove(logSel.logCategory);
          return LogError(0);
        }
        logExcludeMap[logSel.logCategory] = logSel;
      } else {
        if (logSel.logLevel == LogLevel.none) {
          logSelectorMap.remove(logSel.logCategory);
          return LogError(0);
        }
        logSelectorMap[logSel.logCategory] = logSel;
      }
      _reduceLogicMap(logSel.logCategory);
      return LogError(0);
    } catch (ex) {
      return LogError(-1, message: ex.toString());
    }
  }

  _reduceLogicMap(String category) {}

  List<String> getAllCategories() {
    var selList =
        logSelectorMap.values.map((valeur) => valeur.toString()).toList();
    var excluList =
        logExcludeMap.values.map((valeur) => valeur.toString()).toList();
    return excluList + selList;
  }

  bool isCategoryActive(String category, LogLevel level) {
    var sel = logSelectorMap['All']?.isLevelMatch(level) ?? false;
    if (sel) {
      return sel;
    }
    return logSelectorMap[category]?.isLevelMatch(level) ?? false;
  }

  LogError internalProcessLogMessage(LogMessage message) =>
      LogError(-5, message: 'Function not implemented');

  LogError command(dynamic command) =>
      LogError(-5, message: 'Function not implemented');

  LogError startTimeLine() {
    timeLineStart = Timeline.now;
    timeLineEnable = true;
    return LogError(0);
  }

  LogError stopTimeLine() {
    timeLineStart = 0;
    timeLineEnable = false;
    return LogError(0);
  }

  LogError stopLogger() {
    return closeLogger();
  }

  LogError installContext(Map context,
      {Map<String, Function(LogMessage message)>? processMap}) {
    var cat = context['categories'];
    if (cat != null && cat is String) {
      setCategories(cat);
    }
    var outs = context['outputs'];
    if (outs != null && outs is Map) {
      useConsole = false;
      useFile = false;
      useProcess = false;
      useStorage = false;

      var cons = outs['console'];
      if (cons == true) {
        enableConsoleOutput(false);
      }

      var store = outs['storage'];
      if (store == true) {
        enableStorageOutput(false);
      }

      var proc = outs['process'];
      if (proc != null && proc is Map) {
        var funcName = proc['function'];
        Function(LogMessage)? procFunc;
        if (funcName != null) {
          procFunc = processMap?[funcName];
        }
        enableProcessOutput(false, procFunc);
      }
      if (proc == true) {
        enableProcessOutput(false, null);
      }

      var file = outs['file'];
      if (file != null && file is Map) {
        var path = file['path'];
        var form = LoggerManager.parseSaveFormat(file['format'] ?? 'text');
        var app = file['append'] == true;
        var flush = file['flush'] != false;
        if (path != null) {
          enableFileOutput(false,
              logFileName: path, format: form, append: app, flush: flush);
        }
      }
    }

    var deco = context['decoration'];
    if (deco != null && deco is Map) {
      var cat = deco['category'] != false;
      var lID = deco['loggerID'] != false;
      var tStamp = deco['timeStamp'] != false;
      var tLine = deco['timeLine'] != false;

      var mode = deco['mode'];
      if (mode == null && mode is! String) {
        mode = 'none';
      }
      var panel = deco['colorPanel'];
      if (panel == null && panel is! String) {
        mode = 'none';
      }
      setDecoration(
          category: cat,
          loggerID: lID,
          timeStamp: tStamp,
          timeLine: tLine,
          decoration: mode,
          colorPanel: panel);
    }

    return LogError(0);
  }

  setLockUpdate(bool lock) => lockUpdate = lock;

  bool logFileReady(); // modify
  LogError openFileSaver(
          {required String logFileName,
          bool append = false,
          bool flush = true,
          SaveFormat format = SaveFormat.text}) =>
      LogError(-5, message: 'Function not implemented');
  LogError closeFileSaver() =>
      LogError(-5, message: 'Function not implemented');
  LogStatus getFileSaverStatus() => LogStatus.error;
  LogError closeLogger() => LogError(-5, message: 'Function not implemented');
  LogError saveMessageList(String filePath, SaveFormat format,
          {bool flush = true, bool clear = false}) =>
      LogError(-5, message: 'Function not implemented');
  LogError printMessageList({bool clear = false}) =>
      LogError(-5, message: 'Function not implemented');
  LogError clearMessageList() =>
      LogError(-5, message: 'Function not implemented');
  LogError processMessageList(
          {Function(LogMessage message)? onLogMessage, bool clear = false}) =>
      LogError(-5, message: 'Function not implemented');

  LogError setDecoration(
      {bool timeStamp = false,
      bool timeLine = false,
      bool loggerID = false,
      bool category = false,
      String decoration = 'none',
      String colorPanel = 'none'}) {
    withCategory = category;
    withLoggerId = loggerID;
    withTimeStamp = timeStamp;
    withTimeLine = timeLine;
    this.decoration = LoggerBase.parseDecoration(decoration);

    if (colorPanel.trim().toLowerCase() == 'none') {
      levelColorMap = null;
      return LogError(0);
    }
    if (colorPanel.trim().toLowerCase() == 'standard') {
      installColorMap(standardLevelColorMap);
      return LogError(0);
    }
    if (colorPanel.trim().toLowerCase() == 'dark') {
      installColorMap(darkLevelColorMap);
      return LogError(0);
    }

    return installLevelColorJson(colorPanel);
  }

  LogError installLevelColorJson(String jsonString) {
    try {
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      if (decodedJson.containsKey("levelColors")) {
        if (decodedJson["levelColors"].toString() == 'none') {
          levelColorMap = null;
          return LogError(0);
        }
        if (decodedJson["levelColors"].toString() == 'standard') {
          installColorMap(standardLevelColorMap);
          return LogError(0);
        }
        if (decodedJson["levelColors"].toString() == 'dark') {
          installColorMap(darkLevelColorMap);
          return LogError(0);
        }
        var mCol = decodedJson["levelColors"];

        if (mCol is Map) {
          Map<LogLevel, String> levelColorMap = {};
          for (var item in mCol.entries) {
            var lLvl =
                LogSelector.parseLogLevel(item.key.toString().toLowerCase());
            if (item.value.toString().trim().toLowerCase() == 'standard') {
              levelColorMap[lLvl] = standardLevelColorMap[lLvl] ?? '';
            } else {
              if (item.value.toString().trim().toLowerCase() == 'dark') {
                levelColorMap[lLvl] = darkLevelColorMap[lLvl] ?? '';
              } else {
                levelColorMap[lLvl] = item.value.toString();
              }
            }
          }
          installColorMap(levelColorMap);
          return LogError(0);
        } else {
          return LogError(-1,
              message: "Warning: Json Structure Error 'levelColors' Missing.");
        }
      }
    } catch (e) {
      return LogError(-1, message: "Json Decode Error: $e");
    }
    return LogError(-1, message: "Warning: unknow  Error .");
  }

  LogError installColorMap(Map<LogLevel, String> cMap) {
    levelColorMap = {};
    for (var lLevel in LogLevel.values) {
      var col = cMap[lLevel];
      if (col == null) {
        levelColorMap![lLevel] = "\x1B[0m";
      } else {
        if (col.startsWith("\x1B")) {
          levelColorMap![lLevel] = col;
        } else {
          var lCol = LoggerBase.standardColorMap[col] ?? '';
          if (lCol.startsWith("\x1B")) {
            levelColorMap![lLevel] = lCol;
          } else {
            levelColorMap![lLevel] = "\x1B[0m";
          }
        }
      }
    }
    return LogError(0);
  }

  String getMessageColor(LogLevel level) {
    if (decoration != Decoration.full) {
      return '';
    }
    return levelColorMap?[level] ?? '';
  }

  String getLevelColor(LogLevel level) {
    if (decoration != Decoration.level && decoration != Decoration.simple) {
      return '';
    }
    return levelColorMap?[level] ?? '';
  }

  String getMessageEmoji(LogLevel level) {
    if (decoration != Decoration.emoji) {
      return '';
    }
    return emojiMap[level] ?? '';
  }

  Map<LogLevel, String>? levelColorMap;

  Map<LogLevel, String> emojiMap = {
    LogLevel.info: 'ℹ️',
    LogLevel.debug: '🪲',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.critical: '🔥',
    LogLevel.fatal: '☠️',
  };

  static Map<String, String> standardColorMap = {
    "black": "\x1B[30m",
    "red": "\x1B[31m",
    "green": "\x1B[32m",
    "yellow": "\x1B[33m",
    "blue": "\x1B[34m",
    "magenta": "\x1B[35m",
    "cyan": "\x1B[36m",
    "white": "\x1B[37m",
    "Grey": "\x1B[90m",
    "redLight": "\x1B[91m",
    "greenLight": "\x1B[92m",
    "yellowLight": "\x1B[93m",
    "blueLight": "\x1B[94m",
    "magentaLight": "\x1B[95m",
    "cyanLight": "\x1B[96m",
    "whiteAccent": "\x1B[97m",
    "whiteOnBlack": "\x1B[97;40m",
    "whiteOnRed": "\x1B[97;41m",
    "whiteOnGreen": "\x1B[97;42m",
    "whiteOnYellow": "\x1B[97;43m",
    "whiteOnBlue": "\x1B[97;44m",
    "whiteOnMagenta": "\x1B[97;45m",
    "whiteOnCyan": "\x1B[97;46m",
  };

  static Map<LogLevel, String> standardLevelColorMap = {
    LogLevel.info: "green",
    LogLevel.debug: "cyan",
    LogLevel.warning: "yellow",
    LogLevel.error: "magenta",
    LogLevel.critical: "red",
    LogLevel.fatal: "whiteOnRed"
  };

  static Map<LogLevel, String> darkLevelColorMap = {
    LogLevel.info: "greenLight",
    LogLevel.debug: "cyanLight",
    LogLevel.warning: "yellowLight",
    LogLevel.error: "magentaLight",
    LogLevel.critical: "redLight",
    LogLevel.fatal: "whiteOnRed"
  };

  static Decoration parseDecoration(String decorationStr) {
    switch (decorationStr.trim().toLowerCase()) {
      case 'emoji':
        return Decoration.emoji;
      case 'level':
        return Decoration.level;
      case 'simple':
        return Decoration.simple;
      case 'full':
        return Decoration.full;
      case 'none':
        return Decoration.none;
      default:
        return Decoration.none;
    }
  }
}

enum Decoration { none, emoji, level, simple, full }
