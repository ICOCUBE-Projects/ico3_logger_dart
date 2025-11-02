/// Represents the severity levels of log messages.
///
/// This enum categorizes logs by their importance or urgency, ranging from
/// informational messages to fatal errors. It includes a [none] level for
/// unclassified logs.
enum LogLevel {
  info,
  debug,
  warning,
  error,
  critical,
  fatal,
  none,
}

class LogSelector {
  LogSelector(this.logCategory,
      {this.logLevel = LogLevel.info,
      this.exclude = false,
      this.inverse = false});

  String logCategory;
  LogLevel logLevel;
  bool exclude;
  bool inverse;

  factory LogSelector.fromString(String str) {
    str = str.trim();
    bool isExclusion = str.startsWith('-');
    str = isExclusion ? str.substring(1) : str;
    if (str.contains('(') || str.contains(')')) {
      final openParenIndex = str.indexOf('(');
      final closeParenIndex = str.indexOf(')');
      if (openParenIndex == -1 ||
          closeParenIndex == -1 ||
          openParenIndex >= closeParenIndex) {
        throw FormatException('Invalid format. Expected format: "name(level)"');
      }
      final name = str.substring(0, openParenIndex).trim().toLowerCase();
      final levelStr =
          str.substring(openParenIndex + 1, closeParenIndex).trim();
      var inverse = levelStr.trim().toLowerCase().startsWith('-');

      final level = parseLogLevel(levelStr, exclude: isExclusion);
      return LogSelector(name,
          logLevel: level, exclude: isExclusion, inverse: inverse);
    } else {
      // Cas sans parenthèses, juste "name"
      return LogSelector(str,
          logLevel: isExclusion ? LogLevel.fatal : LogLevel.info,
          exclude: isExclusion);
    }
  }

  bool get isExclusion => exclude;
  bool get isInverse => inverse;

  bool isMessageMatch(LogLevel levelMsg, String categoryMsg) {
    if (logCategory.toLowerCase() == 'all' ||
        categoryMsg.toLowerCase() == logCategory.toLowerCase()) {
      return isLevelMatch(levelMsg);
    }
    return false;
  }

  bool isLevelMatch(LogLevel a) {
    if (a == LogLevel.none || logLevel == LogLevel.none) {
      return exclude;
    }
    if (inverse) {
      return exclude ? a.index >= logLevel.index : a.index <= logLevel.index;
    }
    return exclude ? a.index <= logLevel.index : a.index >= logLevel.index;
  }

  @override
  String toString() {
    return '${isExclusion ? '-' : ''}$logCategory(${isInverse ? '-' : ''}${logLevel.name})';
  }

  static LogLevel? upperLogLevel(LogLevel level) {
    try {
      return LogLevel.values[level.index + 1];
    } catch (ex) {
      return null;
    }
  }

  static LogLevel? lowerLogLevel(LogLevel level) {
    try {
      return LogLevel.values[level.index - 1];
    } catch (ex) {
      return null;
    }
  }

  static LogLevel parseLogLevel(String levelStr, {bool exclude = false}) {
    var str = levelStr.trim().toLowerCase();
    if (str.startsWith('-')) {
      str = str.substring(1);
    }
    switch (str.trim().toLowerCase()) {
      case 'info':
        return LogLevel.info;
      case 'debug':
        return LogLevel.debug;
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'critical':
        return LogLevel.critical;
      case 'fatal':
        return LogLevel.fatal;
      case 'none':
        return LogLevel.none;
      default:
        return exclude ? LogLevel.fatal : LogLevel.info;
    }
  }
}
