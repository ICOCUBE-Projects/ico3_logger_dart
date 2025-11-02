import 'package:ico3_logger/ico3_logger.dart';
import 'dart:convert';

enum DecorationEnum { none, emoji, level, simple, full }

class DecorationManager {
  bool withCategory = true;
  bool withTimeLine = false;
  bool withTimeStamp = false;
  bool withLoggerId = false;
  bool withEnvironment = false;
  DecorationEnum decoration = DecorationEnum.none;

  LogError setDecoration({
    bool timeStamp = false,
    bool timeLine = false,
    bool loggerID = false,
    bool category = false,
    bool environment = false,
    String decoration = 'none',
    String emoji = 'none',
    String colorPanel = 'none',
  }) {
    withCategory = category;
    withLoggerId = loggerID;
    withTimeStamp = timeStamp;
    withTimeLine = timeLine;
    withEnvironment = environment;
    this.decoration = DecorationManager.parseDecoration(decoration);

    if (emoji.trim().toLowerCase() != 'none') {
      setEmojiMap(emoji);
    }

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
          var lCol = DecorationManager.standardColorMap[col] ?? '';
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
    if (decoration != DecorationEnum.full) {
      return '';
    }
    return levelColorMap?[level] ?? '';
  }

  String getLevelColor(LogLevel level) {
    if (decoration != DecorationEnum.level &&
        decoration != DecorationEnum.simple) {
      return '';
    }
    return levelColorMap?[level] ?? '';
  }

  String getMessageEmoji(LogLevel level) {
    if (decoration != DecorationEnum.emoji) {
      return '';
    }
    return emojiMap[level] ?? '';
  }

  Map<LogLevel, String>? levelColorMap;

  Map<LogLevel, String> emojiMap = {
    LogLevel.info: 'ℹ️',
    LogLevel.debug: '🛠️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.critical: '🔥',
    LogLevel.fatal: '☠️',
  };

  Map<LogLevel, String> standardEmojiMap = {
    LogLevel.info: 'ℹ️',
    LogLevel.debug: '🛠️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.critical: '🔥',
    LogLevel.fatal: '☠️',
  };

  Map<LogLevel, String> customEmojiMap = {
    LogLevel.info: 'ℹ️',
    LogLevel.debug: '🛠️',
    LogLevel.warning: '⚠️',
    LogLevel.error: '❌',
    LogLevel.critical: '🔥',
    LogLevel.fatal: '☠️',
  };

  setEmojiMap(String emo) {
    if (emo.trim().toLowerCase() == 'standard') {
      emojiMap = standardEmojiMap;
      return;
    }
    var emoSplit = emo.split(',');
    var idx = 0;
    for (var emj in emoSplit) {
      try {
        var key = customEmojiMap.keys.toList().elementAt(idx);
        customEmojiMap[key] = emj;
      } catch (ex) {
        emj.trim(); // I do a dummy code!!!!!!!
      }
      idx++;
    }
    emojiMap = customEmojiMap;
  }

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

  static DecorationEnum parseDecoration(String decorationStr) {
    switch (decorationStr.trim().toLowerCase()) {
      case 'emoji':
        return DecorationEnum.emoji;
      case 'level':
        return DecorationEnum.level;
      case 'simple':
        return DecorationEnum.simple;
      case 'full':
        return DecorationEnum.full;
      case 'none':
        return DecorationEnum.none;
      default:
        return DecorationEnum.none;
    }
  }
}
