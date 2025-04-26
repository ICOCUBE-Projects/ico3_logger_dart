import 'dart:core';
import 'package:ico3_logger/ico3_logger.dart';
import 'package:yaml/yaml.dart';

class LoggerManager {
  // Map<String, ICO3Logger> loggerMap = {};
  Map<String, LoggerBase> loggerMap = {};
  LoggerManager() {
    var logger = Logger('Main');    // , this
    loggerMap[logger.loggerID] = logger;
    logger.setCategories('All', clear: true);
  }

  LogError stopLoggers() {
    var err = LogError(0);
    for (var lg in loggerMap.values) {
      err.mergeError(lg.stopLogger());
    }

    return err;
  }

  LogError loadContext(String path,
      {Map<String, Function(LogMessage message)>? processMap}) {
    var str = LoggerFile.readStringFile(path);
    if (str == null) {
      return LogError(-1, message: "Error on file reading");
    }
    var map = processYaml(str);
    if (map.isEmpty) {
      return LogError(-1, message: "No data inside yaml file, check it");
    }
    var err = LogError(0);
    var logs = map['loggers'];
    if (logs is List) {
      for (var log in logs) {
        var idLog = log['id'];
        if (idLog != null) {
          var lg = loggerMap[idLog];
          if (lg == null) {
            createLogger(idLog);
            lg = loggerMap[idLog];
          }
          err.mergeError(lg?.installContext(log, processMap: processMap) ??
              LogError(-1, message: 'unable to process $idLog'));
        }
      }
    }
    return err;
  }

  LogError commandLogger(dynamic cmd, {String logger = 'Main'}) {
    return loggerMap[logger]?.command(cmd) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError createLogger(String logId,
      {String? categories, bool enableConsoleOutput = false}) {
    if (loggerMap.containsKey(logId)) {
      return LogError(-1, message: 'cannot create logger exist');
    }
    var logger = Logger(logId);   // , this
    loggerMap[logger.loggerID] = logger;
    if (categories != null) {
      logger.setCategories(categories);
    }
    if (enableConsoleOutput) {
      logger.enableConsoleOutput(true);
    }
    return LogError(0);
  }

  removeLogger(Logger logger) {
    loggerMap.remove(logger.loggerID);
  }

  LogError processLogMessage(LogMessage msg) {
    int count = 0;
    for (var lgr in loggerMap.values) {
      if (lgr.processLogMessage(msg).isSuccess) {
        count++;
      }
    }
    return LogError(count);
  }

  LogError setOnLogMessage(Function(LogMessage message)? func,
      {String logger = 'Main'}) {
    if (loggerMap.containsKey(logger)) {
      loggerMap[logger]?.onLogMessage = func;
      return LogError(0);
    }
    return LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError setOutputAvailable(String availableOutputs,
      {String logger = 'Main'}) {
    return loggerMap[logger]?.setOutputAvailable(availableOutputs) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError enableConsoleOutput(
      {String logger = 'Main', bool exclusive = false}) {
    return loggerMap[logger]?.enableConsoleOutput(exclusive) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError enableProcessOutput(
      {String logger = 'Main',
      bool exclusive = false,
      Function(LogMessage message)? onLogMessage}) {
    return loggerMap[logger]?.enableProcessOutput(exclusive, onLogMessage) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError enableStorageOutput(
      {String logger = 'Main', bool exclusive = false}) {
    return loggerMap[logger]?.enableStorageOutput(exclusive) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError enableFileOutput(
      {String logger = 'Main',
      bool exclusive = false,
      String? logFileName,
      bool append = false,
      bool flush = true,
      SaveFormat format = SaveFormat.text}) {
    return loggerMap[logger]?.enableFileOutput(exclusive,
            logFileName: logFileName,
            append: append,
            flush: flush,
            format: format) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError disableConsoleOutput({String logger = 'Main'}) {
    return loggerMap[logger]?.disableConsoleOutput() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError disableFileOutput({String logger = 'Main'}) {
    return loggerMap[logger]?.disableFileOutput() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError disableProcessOutput({String logger = 'Main'}) {
    return loggerMap[logger]?.disableProcessOutput() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError disableStorageOutput({String logger = 'Main'}) {
    return loggerMap[logger]?.disableConsoleOutput() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError disableAllOutputs({String logger = 'Main'}) {
    return loggerMap[logger]?.disableAllOutputs() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  List<String> getOutputsActive({required String logger}) {
    return loggerMap[logger]?.getOutputsActive() ?? [];
  }

  LoggerFileBase? getOutputFileActive({required String logger}) {
    return loggerMap[logger]?.getOutputFileActive();
  }

  LogError setLockUpdate(bool lock, {String logger = 'Main'}) {
    return loggerMap[logger]?.setLockUpdate(lock) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError setCategories(String category,
      {String logger = 'Main', bool clear = false}) {
    return loggerMap[logger]?.setCategories(category, clear: clear) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  List<String> getAllCategories({String logger = 'Main'}) {
    return loggerMap[logger]?.getAllCategories() ?? [];
  }

  bool isCategoryActive(String category,
      {LogLevel level = LogLevel.info, String logger = 'Main'}) {
    return loggerMap[logger]?.isCategoryActive(category, level) ?? false;
  }

  LogError openFileSaver(
      {required String logFileName,
      bool append = false,
      bool flush = true,
      String logger = 'Main',
      required SaveFormat format}) {
    return loggerMap[logger]?.openFileSaver(
            logFileName: logFileName,
            append: append,
            flush: flush,
            format: format) ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogError closeFileSaver({String logger = 'Main'}) {
    return loggerMap[logger]?.closeFileSaver() ??
        LogError(-1, message: 'Logger not found [$logger]');
  }

  LogStatus getFileSaverStatus({String logger = 'Main'}) {
    return loggerMap[logger]?.getFileSaverStatus() ?? LogStatus.error;
  }

  LogError closeLogger({String logger = 'Main'}) {
    if (logger == 'Main') {
      return LogError(-1, message: 'Main Logger cannot be closed');
    }
    if (loggerMap.containsKey(logger)) {
      loggerMap[logger]?.closeLogger();
      loggerMap.remove(logger);
      return LogError(0);
    }
    return LogError(-1, message: 'Logger not found [$logger]');
  }

  List<LogMessage> getMessageList({String logger = 'Main'}) {
    return loggerMap[logger]?.messageList ?? [];
  }

  LogError saveMessageList(String path,
      {String logger = 'Main',
      SaveFormat format = SaveFormat.text,
      bool append = false,
      bool flush = true,
      bool clear = false}) {
    return loggerMap[logger]
            ?.saveMessageList(path, format, flush: flush, clear: clear) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError printMessageList({String logger = 'Main', bool clear = false}) {
    return loggerMap[logger]?.printMessageList(clear: clear) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError processMessageList(
      {String logger = 'Main',
      Function(LogMessage message)? onLogMessage,
      bool clear = false}) {
    return loggerMap[logger]
            ?.processMessageList(clear: clear, onLogMessage: onLogMessage) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError clearMessageList({String logger = 'Main'}) {
    return loggerMap[logger]?.clearMessageList() ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError startTimeLine({String logger = 'Main'}) {
    return loggerMap[logger]?.startTimeLine() ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError stopTimeLine({String logger = 'Main'}) {
    return loggerMap[logger]?.stopTimeLine() ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError installCustomLogger(LoggerBase cLogger) {
    if (loggerMap.containsKey(cLogger.loggerID)) {
      return LogError(-1, message: 'cannot install, logger exist');
    }

    loggerMap[cLogger.loggerID] = cLogger;
    return LogError(0);
  }

  LogError setDecoration({
    String logger = 'Main',
    bool timeStamp = false,
    bool timeLine = false,
    bool loggerID = false,
    bool category = false,
    bool environment = false,
    String mode = 'none',
    String emoji = 'none',
    String colorPanel = 'none',
  }) {
    return loggerMap[logger]?.setDecoration(
            category: category,
            loggerID: loggerID,
            timeLine: timeLine,
            timeStamp: timeStamp,
            decoration: mode,
            environment: environment,
            emoji: emoji,
            colorPanel: colorPanel) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError installService(
      {String logger = 'Main', required LogService service}) {
    return loggerMap[logger]?.installService(service) ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  LogError removeService({String logger = 'Main'}) {
    return loggerMap[logger]?.removeService() ??
        LogError(-2, message: 'Logger not found [$logger]');
  }

  Map<String, Object> processYaml(String yamlString) {
    try {
      final dynamic yamlData = loadYaml(yamlString);

      if (yamlData is Map) {
        return _convertYamlMap(yamlData);
      } else {
        //  print("Erreur: Le fichier YAML à la racine ne contient pas une map.");
        return <String, Object>{};
      }
    } catch (e) {
      // print("Erreur lors du chargement du fichier YAML '$path': $e");
      return <String, Object>{};
    }
  }

  Map<String, Object> _convertYamlMap(Map yamlMap) {
    final dartMap = <String, Object>{};
    yamlMap.forEach((key, value) {
      if (key is String) {
        dartMap[key] = _convertYamlValue(value);
      } else {
        print("Avertissement: Clé YAML non string ignorée: $key");
      }
    });
    return dartMap;
  }

  dynamic _convertYamlValue(dynamic value) {
    if (value is YamlMap) {
      return _convertYamlMap(value);
    } else if (value is YamlList) {
      return _convertYamlList(value);
    } else {
      return value; // Les types primitifs YAML (string, num, bool, null) sont directement compatibles
    }
  }

  List<Object?> _convertYamlList(YamlList yamlList) {
    final dartList = <Object?>[];
    for (final item in yamlList) {
      dartList.add(_convertYamlValue(item));
    }
    return dartList;
  }

  static SaveFormat parseSaveFormat(String str) {
    switch (str.trim().toLowerCase()) {
      case 'json':
        return SaveFormat.json;
      case 'csv':
        return SaveFormat.csv;
      default:
        return SaveFormat.text;
    }
  }
}
