import 'package:ico3_logger/ico3_logger.dart';

/// A logger extension that handles fatal log messages with automatic saving and exit.
///
/// The [LoggerPostFatalExtension] class maintains a circular buffer of log messages
/// and saves them to a file when a fatal log is encountered. It can optionally
/// terminate the application after saving.
///
/// Example:
/// ```dart
/// void main() {
///
///   // set directly Extension.processMessage in  onLogMessage
///     Log.enableProcessOutput(
///       exclusif: true,
///       onLogMessage: LoggerPostFatalExtension(
///           size: 25,
///           fileName: 'fatal.csv',
///           format: SaveFormat.csv,
///           autoExit: true)
///           .processMessage);
///
///   // test it...
///   for (int i = 0; i < 56; i++) {
///     Log.log('testLog', ' log n°: $i test', level: 'warning');
///   }
///   // do a fatal error
///   Log.log('testLog', ' log Fatal test', level: 'fatal');
///   for (int i = 0; i < 56; i++) {
///     Log.log('testLog', ' log bis n°: $i test', level: 'warning');
///   }
/// }
/// ```
class LoggerPostFatalExtension {
  /// Creates a new [LoggerPostFatalExtension] instance.
  ///
  /// - [size]: The maximum number of log messages to store in the buffer.
  /// - [fileName]: The name of the file to save logs to (defaults to "fatal.txt").
  /// - [format]: The format for saving logs (defaults to [SaveFormat.text]).
  /// - [useConsole]: If true, if true display logs on console, not save to file. (defaults to false).
  /// - [autoExit]: If true, exits the application after saving a fatal log (defaults to true).
  LoggerPostFatalExtension(
      {this.size = 10,
      this.fileName = 'fatal.txt',
      this.format = SaveFormat.text,
      this.useConsole = false,
      this.autoExit = true}) {
    logList = List<LogMessage?>.filled(size, null);
  }

  /// The maximum number of log messages the buffer can hold.
  int size;

  /// The current position in the circular buffer.
  int _logPointer = 0;

  /// The name of the file where logs are saved when a fatal message is processed.
  String fileName;

  /// The format used to save log messages (e.g., text, CSV, JSON).
  SaveFormat format;

  /// Determines whether the application exits automatically after a fatal log.
  bool autoExit;

  bool useConsole;

  /// The circular buffer storing log messages.
  ///
  /// Initialized as a fixed-size list with null values, updated as messages are added.
  late final List<LogMessage?> logList;

  /// Processes a log message, saving and exiting if it’s fatal.
  ///
  /// - [message]: The [LogMessage] to process.
  ///
  /// If the [message] has a [LogLevel.fatal] level, the buffer is saved to [fileName]
  /// and the application may exit based on [autoExit].
  processMessage(LogMessage message) {
    _addMessage(message);
    if (message.level == LogLevel.fatal) {
      if (useConsole) {
        _displayMessageAndExit();
      } else {
        _saveMessageAndExit();
      }
    }
  }

  /// Adds a log message to the circular buffer.
  ///
  /// - [message]: The [LogMessage] to add.
  ///
  /// Overwrites the oldest message if the buffer is full, advancing [_logPointer] in a circular manner.
  _addMessage(LogMessage message) {
    logList[_logPointer] = message;
    _logPointer = (_logPointer + 1) % size;
  }

  /// Saves the log buffer to a file and optionally exits the application.
  ///
  /// Collects all non-null messages from [logList] in order, saves them to [fileName]
  /// using [format], and exits with status code -1 if [autoExit] is true.
  _saveMessageAndExit() {
    // List<LogMessage> listMessage = [];
    // var ptrLog = _logPointer;
    // do {
    //   var lg = logList[ptrLog];
    //   if (lg != null) {
    //     listMessage.add(lg);
    //   }
    //   ptrLog = (ptrLog + 1) % size;
    // } while (ptrLog != _logPointer);
    LoggerFile(logFileName: fileName, format2File: format, append: false)
        .saveMessageList(_getMessageList());
    if (autoExit) {
      LogIO.exitApplication();
      // exit(-1);
    }
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

  _displayMessageAndExit() {
    for (var msg in _getMessageList()) {
      LogPrint.print(msg.toString());
    }
    if (autoExit) {
      LogIO.exitApplication();
      // exit(-1);
    }
  }
}
