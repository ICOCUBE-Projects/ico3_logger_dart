import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

// Copyright (c) Gilles PREVOT

class CriticalStorage {
  static String micro = String.fromCharCode(0x00B5);
  List<CriticalMessage> criticalMessageList = [];
  static int timeLineStart = 0;
  int startReset = 0;
  int lastTime = 0;
  int size;
  bool growable;
  int index = 0;

  CriticalStorage(this.size, {this.growable = true}) {
    criticalMessageList.clear();
    initStorage();
    timeLineStart = Timeline.now;
  }

  initStorage() {
    for (int i = 0; i < size; i++) {
      criticalMessageList.add(CriticalMessage.dummy());
    }
    index = 0;
  }

  resetIndex() {
    startReset = Timeline.now;
    criticalMessageList[0] = CriticalMessage.dummy();
    index = 0;
    // var loop = 0;
    // for(int i = 0; i < 1000 ; i++){
    //   loop++;
    // }
    timeLineStart = Timeline.now;
  }

  storeMessage(String category, String message, String? env, Object level) {
    lastTime = Timeline.now;
    if (index < size) {
      criticalMessageList[index] =
          CriticalMessage(category, message, env, level, lastTime);
      index++;
    } else {
      if (growable) {
        criticalMessageList
            .add(CriticalMessage(category, message, env, level, Timeline.now));
        index++;
      }
    }
  }

  LogError exitCriticalMode() {
    //var duration = lastTime - timeLineStart;
    var dt = DateTime.now();
    var err = LogError(0);
    var rank = 0;
    //var validCount = 0;
    for (var cMessage in criticalMessageList) {
      if (cMessage is! DummyCriticalMessage) {
        var logMessage = CriticalLogMessage.fromString(
            cMessage.category, cMessage.message,
            environment: cMessage.env, level: cMessage.level, rank: rank);
        logMessage.timeLine = cMessage.timeLine - timeLineStart;
        logMessage.timeStamp = dt;
        err.mergeError(Log.processLogMessage(logMessage));
        //validCount++;
      }
      rank++;
    }
    // if (report != null) {
    //   double average = duration.toDouble() / validCount;
    //   var reportMessage = LogMessage.fromString(category,
    //       '$report duration: $duration ${CriticalStorage.micro}s  Logs: $validCount  average time between log: $average ${CriticalStorage.micro}s ',
    //       level: level ?? LogLevel.info);
    //   err.mergeError(Log.processLogMessage(reportMessage));
    // }
    return err;
  }
}

class CriticalMessage {
  CriticalMessage(
      this.category, this.message, this.env, this.level, this.timeLine);
  String category;
  String message;
  String? env;
  Object level;
  int timeLine;

  factory CriticalMessage.dummy() {
    return DummyCriticalMessage(
      '', // category empty
      '', // message empty
      '', // env null
      '', // level empty
      0, // timeLine 0
    );
  }
}

class DummyCriticalMessage extends CriticalMessage {
  DummyCriticalMessage(
      super.category, super.message, super.env, super.level, super.timeLine);
}

class CriticalLogMessage extends LogMessage {
  int rank;

  CriticalLogMessage(
      {required super.message,
      super.level = LogLevel.none,
      super.environment = '',
      super.category = '',
      this.rank = -1}) {
    // this.isTimeLine = false
    timeStamp = DateTime.now();
    isCritical = true;
  }

  static CriticalLogMessage fromString(String category, String message,
      {String? environment, Object level = 'info', rank = -1}) {
    return level is LogLevel
        ? CriticalLogMessage(
            message: message,
            category: category,
            environment: environment ?? '',
            level: level,
            rank: rank)
        : CriticalLogMessage(
            message: message,
            category: category,
            environment: environment ?? '',
            rank: rank,
            level: LogSelector.parseLogLevel(level.toString()));
  }

  @override
  CriticalLogMessage clone() {
    return CriticalLogMessage(
        message: message,
        level: level,
        environment: environment,
        category: category)
      ..timeStamp = timeStamp
      ..timeLine = timeLine
      ..isCritical = isCritical
      ..rank = rank;
  }

  @override
  String getStringMessageForLogger(
      bool withCategory, bool envActive, bool withTimeLine) {
    String eMsg = '';
    isDated = true;
    if (isDated) {
      eMsg += '$timeStamp ';
    }
    if (withTimeLine) {
      eMsg += '< $timeLine${CriticalStorage.micro}s ($rank)> ';
    }
    if (level != LogLevel.none) {
      eMsg += '[${level.toString().split('.').last.toUpperCase()}] ';
    }
    if (envActive == true) {
      if (environment.isNotEmpty) {
        eMsg += '$environment ## ';
      }
    }
    if (withCategory == true) {
      eMsg += '$category ';
    }
    return '$eMsg--> $message';
  }

  @override
  String toString() {
    return '${(timeStamp ?? DateTime.now()).toIso8601String()} <($rank)$timeLine ${CriticalStorage.micro}s> [${level.name}] ($category) $environment --> $message ';
  }
}
