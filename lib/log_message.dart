import 'dart:core';
import 'dart:convert';
import 'package:ico3_logger/ico3_logger.dart';
import 'package:intl/intl.dart';

/// Defines the possible output destinations for log messages.
///
/// This enum specifies where log messages can be directed, such as the console,
/// a file, a process, or storage.
enum OutputMode {
  /// Output logs to the console.
  console,

  /// Output logs to a file.
  file,

  /// Output logs to a process (e.g., for external handling).
  process,

  /// Output logs to storage (e.g., in-memory or persistent storage).
  storage,
}

/// Specifies the format for saving log messages.
///
/// This enum determines the file format used when saving logs, such as plain text,
/// CSV, or JSON.
enum SaveFormat {
  /// Save logs as plain text.
  text,

  /// Save logs in CSV (Comma-Separated Values) format.
  csv,

  /// Save logs in JSON (JavaScript Object Notation) format.
  json,
}

// /// Represents the severity levels of log messages.
// ///
// /// This enum categorizes logs by their importance or urgency, ranging from
// /// informational messages to fatal errors. It includes a [none] level for
// /// unclassified logs.
// enum LogLevel {
//   /// An informational message, typically for general status updates.
//   info,
//
//   /// A debug message, useful for troubleshooting and development.
//   debug,
//
//   /// A warning message, indicating a potential issue that doesn’t stop execution.
//   warning,
//
//   /// An error message, indicating a problem that affects functionality.
//   error,
//
//   /// A critical message, indicating a severe issue requiring immediate attention.
//   critical,
//
//   /// A fatal message, indicating an unrecoverable error that may crash the application.
//   fatal,
//
//   /// No specific level assigned, used as a default or placeholder.
//   none,
// }

/// Represents a log message with associated metadata.
///
/// A [LogMessage] encapsulates the details of a log entry, including its message,
/// level, category, environment, and timestamp. It provides methods to format
/// the message in various ways (e.g., JSON, CSV, or string).
///
/// Example:
/// ```dart
/// var logMsg = LogMessage(message: "App started", category: "App", level: LogLevel.info);
/// print(logMsg.toString());
/// ```
class LogMessage {
  /// Creates a new [LogMessage] instance.
  ///
  /// - [message]: The log message content (required).
  /// - [level]: The severity level of the log (defaults to [LogLevel.none]).
  /// - [environment]: The environment context (defaults to an empty string).
  /// - [category]: The category of the log (defaults to an empty string).
  ///
  /// The [timeStamp] is automatically set to the current time upon creation.
  LogMessage({
    required this.message,
    this.level = LogLevel.none,
    this.environment = '',
    this.category = '',
  }) {
    timeStamp = DateTime.now();
  }

  /// The severity level of the log message.
  LogLevel level;

  /// The content of the log message.
  String message;

  /// The environment context for the log (e.g., "prod", "dev").
  String environment;

  /// The category of the log (e.g., "App", "Network").
  String category;

  Object? serviceTag;

  /// The timestamp when the log message was created.
  ///
  /// Defaults to the current time if not explicitly set.
  DateTime? timeStamp;

  /// The timeline identifier for the log message.
  ///
  /// Used to track logs within a sequence or timeline.
  int timeLine = 0;

  /// Indicates whether the message has been formatted with a timestamp.
  bool isDated = false;

  bool isCritical = false;

  /// Creates a [LogMessage] from string parameters.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The log message content.
  /// - [environment]: Optional environment context (defaults to an empty string).
  /// - [level]: The log level, either as a [LogLevel] or a string (defaults to "info").
  ///
  /// Returns: A new [LogMessage] instance with the specified values.
  static LogMessage fromString(
    String category,
    String message, {
    String? environment,
    Object level = 'info',
  }) {
    return level is LogLevel
        ? LogMessage(
            message: message,
            category: category,
            environment: environment ?? '',
            level: level,
          )
        : LogMessage(
            message: message,
            category: category,
            environment: environment ?? '',
            level: LogSelector.parseLogLevel(level.toString()),
          );
  }

  /// Converts the log message to a JSON string.
  ///
  /// - [first]: If true, omits the leading comma and newline (for the first entry in a list).
  ///
  /// Returns: A JSON-encoded string representing the log message.
  String getJsonString(bool first) {
    final Map<String, dynamic> data = {
      'level': level.toString().split('.').last,
      'category': category,
      'message': message,
      'environment': environment,
      'timeStamp': timeStamp?.toIso8601String() ?? DateTime.now(),
      'timeLine': timeLine,
    };
    if (!first) {
      return ',\n${jsonEncode(data)}';
    }
    return jsonEncode(data);
  }

  /// Converts the log message to a CSV row string.
  ///
  /// Returns: A CSV-formatted string with fields separated by commas.
  String getCSVString() {
    final List<String> row = [
      (timeStamp ?? DateTime.now()).toIso8601String(),
      level.toString().split('.').last,
      '"${category.replaceAll('"', '""')}"',
      '"${message.replaceAll('"', '""')}"',
      '"${environment.replaceAll('"', '""')}"',
      timeLine.toString(),
    ];
    return '${row.join(',')}\n';
  }

  /// Provides the CSV header for log messages.
  ///
  /// Returns: A string containing the column names for a CSV file.
  static String getCSVHeader() {
    return 'timeStamp,level,category,message,environment,timeLine';
  }

  /// Formats the log message as a human-readable string for logging.
  ///
  /// - [withCategory]: If true, includes the category in the output.
  /// - [envActive]: If true, includes the environment if it’s non-empty.
  /// - [withTimeLine]: If true, includes the timeline identifier.
  ///
  /// Returns: A formatted string suitable for display in a logger.
  String getStringMessageForLogger(
      bool withCategory, bool envActive, bool withTimeLine) {
    isDated = true;
    return [
      if (isDated) LogUtilities.getTimeStampedString(),
      if (withTimeLine) '<$timeLine>',
      if (level != LogLevel.none) '[${level.name.toUpperCase()}]',
      if (envActive && environment.isNotEmpty) '$environment ##',
      if (withCategory) '($category)',
      '--> $message',
    ].join(' ');
  }

  /// Formats the timestamp in a readable format.
  ///
  /// Returns: A string in the format 'yyyy-MM-dd HH:mm:ss.SSS'.
  String getTimeStampedFormated() {
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
        .format(timeStamp ?? DateTime.now());
  }

  /// Creates a deep copy of the [LogMessage].
  ///
  /// Returns: A new [LogMessage] instance with the same properties.
  LogMessage clone() {
    return LogMessage(
      message: message,
      level: level,
      environment: environment,
      category: category,
    )
      ..serviceTag = serviceTag
      ..timeStamp = timeStamp
      ..timeLine = timeLine
      ..isCritical = isCritical;
  }

  /// Returns a string representation of the log message with timestamp.
  ///
  /// Includes all fields in a concise format.
  @override
  String toString() {
    return '${(timeStamp ?? DateTime.now()).toIso8601String()} <$timeLine> [${level.name}] ($category) $environment --> $message ';
  }

  /// Returns a string representation of the log message without timestamp.
  ///
  /// Useful for compact logging scenarios.
  String toStringWOTimeStamp() {
    return '[${level.name}] ($category) $environment --> $message ';
  }

  /// indicate message comes from CriticalMode
  setCritical() {
    isCritical = true;
  }
}
