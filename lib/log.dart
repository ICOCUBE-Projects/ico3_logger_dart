import 'dart:core';
import 'package:ico3_logger/ico3_logger.dart';

// Copyright (c) 2025 Gilles PREVOT

/// A utility class for managing logging operations.
///
/// The [Log] class provides static methods to log messages with various levels
/// (e.g., info, error, debug), configure loggers, and handle critical mode operations.
/// It interacts with [LoggerManager] for standard logging and [CriticalStorage] for
/// critical mode storage.
///
/// Example:
/// ```dart
/// Log.info("App", "Application started");
/// Log.createLogger("MyLogger", categories: "App,Debug");
/// ```
class Log {
  /// The manager responsible for handling loggers and their configurations.
  static LoggerManager loggerManager = LoggerManager();

  /// Indicates whether the logger is in critical mode.
  ///
  /// When `true`, logs are stored in [criticalStorage] instead of being processed normally.
  static bool isCriticalMode = false;

  /// Storage for log messages when in critical mode.
  ///
  /// This is initialized when entering critical mode and cleared when exiting.
  static CriticalStorage? criticalStorage;

  /// Loads a YAML file to initialize the different loggers.
  ///
  /// This function reads the file specified by [path] and uses its content
  /// to configure the internal loggers. The YAML file should define
  /// log categories and their associated outputs (e.g., console,
  /// files).
  /// - [path]: The path to the YAML configuration file.
  ///
  /// Returns: A [LogError] indicating the result of the operation.
  static LogError loadContext(String path,
      {Map<String, Function(LogMessage message)>? processMap}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.loadContext(path, processMap: processMap);
  }

  /// Stops all active loggers and closes their output files.
  ///
  /// This function ensures that all pending messages are written
  /// and that the resources used by the loggers (such as file handles)
  /// are properly released before the program terminates.
  ///
  /// Returns: A [LogError] indicating the result of the operation.

  static LogError stopLoggers() {
    return loggerManager.stopLoggers();
  }

  /// Processes a [LogMessage] and returns the result.
  ///
  /// If in critical mode, returns an error. Otherwise, delegates to [loggerManager].
  /// - [message]: The log message to process.
  ///
  /// Returns: A [LogError] indicating the result of the operation.
  static LogError processLogMessage(LogMessage message) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.processLogMessage(message);
  }

  /// Logs a message with the specified category and level.
  ///
  /// - [category]: The category of the log (e.g., "App", "Network").
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context (e.g., "prod", "dev").
  /// - [level]: The log level (e.g., "info", "error"). Defaults to "info".
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError log(String category, String message,
      {String? environment, Object level = 'info'}) {
    if (isCriticalMode) {
      criticalStorage!.storeMessage(category, message, environment, level);
      return LogError(0);
    }
    var logMessage = LogMessage.fromString(category, message,
        environment: environment, level: level);
    return processLogMessage(logMessage);
  }

  /// Logs an informational message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError info(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.info);

  /// Logs an error message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError error(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.error);

  /// Logs a debug message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError debug(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.debug);

  /// Logs a warning message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError warning(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.warning);

  /// Logs a critical message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError critical(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.critical);

  /// Logs a fatal message.
  ///
  /// - [category]: The category of the log.
  /// - [message]: The message to log.
  /// - [environment]: Optional environment context.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError fatal(String category, String message,
          {String? environment}) =>
      log(category, message,
          environment: environment ?? '', level: LogLevel.fatal);

  /// Creates a new logger with the specified configuration.
  ///
  /// - [logId]: Unique identifier for the logger.
  /// - [categories]: Optional comma-separated list of categories.
  /// - [enableConsoleOutput]: Enables console output (default true).
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError createLogger(String logId,
      {String? categories, bool enableConsoleOutput = true}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.createLogger(logId,
            categories: categories, enableConsoleOutput: enableConsoleOutput);
  }

  /// Installs a custom logger implementation.
  ///
  /// - [logger]: The custom [LoggerBase] implementation to install.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError installCustomLogger(LoggerBase logger) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.installCustomLogger(logger);
  }

  /// Sets a callback for log message events.
  ///
  /// - [onLogMessage]: The callback to invoke when a message is logged.
  /// - [logger]: The logger name (defaults to "Main").
  static setOnLogMessage(Function(LogMessage message)? onLogMessage,
      {String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.setOnLogMessage(onLogMessage, logger: logger);
  }

  // /// Sends a command to the specified logger.
  // ///
  // /// - [cmd]: The command to execute.
  // /// - [logger]: The logger name (defaults to "Main").
  // ///
  // /// Returns: A [LogError] indicating success or failure.
  // static LogError commandLogger(dynamic cmd, {String logger = 'Main'}) {
  //   return isCriticalMode
  //       ? LogError(-5, message: 'is in critical mode')
  //       : loggerManager.commandLogger(cmd, logger: logger);
  // }

  /// Closes the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError closeLogger({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.closeLogger(logger: logger);
  }

  /// Sets up categories for the specified logger.
  ///
  /// Categories are divided into two types: `select` and `exclude`.
  /// - `select` categories specify which categories to include, optionally with a minimum level in parentheses.
  ///   Example: `network(warning)` selects the `network` category with a minimum level of `warning`. If no level is
  ///   specified, the default level is the lowest, `info`. Example: `core` implies `core(info)`.
  /// - `exclude` categories specify which categories to exclude, prefixed with a `-`, optionally with a maximum
  ///   level in parentheses. Example: `-core(error)` excludes the `core` category up to the `error` level. If no
  ///   level is specified, the default level is the highest, `fatal`. Example: `-core` implies `-core(fatal)`.
  /// - To selectively remove a category entirely, use the `none` level. Examples: `-core(none)` or `network(none)`.
  ///
  /// Usage examples:
  /// ```dart
  /// Log.setCategories('network(warning), core, -core(error)', clear: true);
  /// Log.setCategories('-core(none)');
  /// ```
  ///
  /// - [categories]: A comma-separated list of categories.
  /// - [logger]: The logger name (defaults to `"Main"`).
  /// - [clear]: If `true`, clears both the `select` and `exclude` category lists (defaults to `false`).
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError setCategories(String categories,
      {String logger = 'Main', bool clear = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.setCategories(categories, logger: logger, clear: clear);
  }

  /// Retrieves all categories for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A list of category/level names, or an empty list if in critical mode.
  static List<String> getAllCategories({String logger = 'Main'}) {
    return isCriticalMode ? [] : loggerManager.getAllCategories(logger: logger);
  }

  /// Enables console output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [exclusive]: If true, disables other outputs.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError enableConsoleOutput(
      {String logger = 'Main', bool exclusive = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.enableConsoleOutput(
            logger: logger, exclusive: exclusive);
  }

  /// Enables process output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [exclusive]: If true, disables other outputs.
  /// - [onLogMessage]: Optional callback for processing log messages.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError enableProcessOutput(
      {String logger = 'Main',
      bool exclusive = false,
      Function(LogMessage message)? onLogMessage}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.enableProcessOutput(
            logger: logger, exclusive: exclusive, onLogMessage: onLogMessage);
  }

  /// Enables storage output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [exclusive]: If true, disables other outputs.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError enableStorageOutput(
      {String logger = 'Main', bool exclusive = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.enableStorageOutput(
            logger: logger, exclusive: exclusive);
  }

  /// Enables file output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [exclusive]: If true, disables other outputs.
  /// - [logFileName]: Optional file name for the log file.
  /// - [append]: If true, appends to the file instead of overwriting.
  /// - [format]: The save format (defaults to [SaveFormat.text]).
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError enableFileOutput(
      {String logger = 'Main',
      bool exclusive = false,
      String? logFileName,
      bool append = false,
      bool flush = false,
      SaveFormat format = SaveFormat.text}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.enableFileOutput(
            logger: logger,
            exclusive: exclusive,
            logFileName: logFileName,
            append: append,
            flush: flush,
            format: format);
  }

  /// Disables console output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError disableConsoleOutput({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.disableConsoleOutput(logger: logger);
  }

  /// Disables storage output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError disableStorageOutput({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.disableStorageOutput(logger: logger);
  }

  /// Disables process output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError disableProcessOutput({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.disableProcessOutput(logger: logger);
  }

  /// Disables file output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError disableFileOutput({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.disableFileOutput(logger: logger);
  }

  /// Disables All output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError disableAllOutputs({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.disableAllOutputs(logger: logger);
  }

  /// Retrieves the list of enabled outputs for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A list of enabled output names, or an empty list if in critical mode.
  static List<String> getOutputsEnabled({String logger = 'Main'}) {
    return isCriticalMode ? [] : loggerManager.getOutputsActive(logger: logger);
  }

  /// Retrieves the active file output for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: The active [LoggerFileBase], or `null` if in critical mode or none is active.
  static LoggerFileBase? getOutputFileActive({String logger = 'Main'}) {
    return isCriticalMode
        ? null
        : loggerManager.getOutputFileActive(logger: logger);
  }

  /// Locks or unlocks updates for the specified logger.
  ///
  /// - [lock]: If true, locks updates; if false, unlocks them.
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError setLockUpdate(bool lock, {String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.setLockUpdate(lock, logger: logger);
  }

  /// Retrieves the list of stored log messages for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A list of [LogMessage] objects, or an empty list if in critical mode.
  static List<LogMessage> getMessageList({String logger = 'Main'}) {
    return isCriticalMode ? [] : loggerManager.getMessageList(logger: logger);
  }

  /// Saves the message list to a file.
  ///
  /// - [logFileName]: The name of the file to save to.
  /// - [logger]: The logger name (defaults to "Main").
  /// - [append]: If true, appends to the file instead of overwriting.
  /// - [format]: The save format (defaults to [SaveFormat.text]).
  /// - [clear]: If true, clears the message list after saving.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError saveMessageList(
      {required String logFileName,
      String logger = 'Main',
      bool append = false,
      bool flush = false,
      SaveFormat format = SaveFormat.text,
      bool clear = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.saveMessageList(logFileName,
            append: append,
            logger: logger,
            format: format,
            flush: flush,
            clear: clear);
  }

  /// Prints the message list to the console.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [clear]: If true, clears the message list after printing.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError printMessageList(
      {String logger = 'Main', bool clear = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.printMessageList(logger: logger, clear: clear);
  }

  /// Processes the message list with the configured outputs.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  /// - [clear]: If true, clears the message list after processing.
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError processMessageList(
      {String logger = 'Main',
      Function(LogMessage message)? onLogMessage,
      bool clear = false}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.processMessageList(
            logger: logger, onLogMessage: onLogMessage, clear: clear);
  }

  /// Clears the message list for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError clearMessageList({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.clearMessageList(logger: logger);
  }

  // /// Opens a file Output for continuous logging.
  // ///
  // /// - [logFileName]: The name of the file to save to.
  // /// - [append]: If true, appends to the file instead of overwriting.
  // /// - [logger]: The logger name (defaults to "Main").
  // /// - [format]: The save format (defaults to [SaveFormat.text]).
  // ///
  // /// Returns: A [LogError] indicating success or failure.
  // static LogError openFileOutput(
  //     {required String logFileName,
  //     bool append = false,
  //     String logger = 'Main',
  //     SaveFormat format = SaveFormat.text}) {
  //   return isCriticalMode
  //       ? LogError(-5, message: 'is in critical mode')
  //       : loggerManager.openFileSaver(
  //           logFileName: logFileName,
  //           append: append,
  //           logger: logger,
  //           format: format);
  // }
  //
  // /// Closes the active fileOutput.
  // ///
  // /// - [logger]: The logger name (defaults to "Main").
  // ///
  // /// Returns: A [LogError] indicating success or failure.
  // static LogError closeFileOutput({String logger = 'Main'}) {
  //   return isCriticalMode
  //       ? LogError(-5, message: 'is in critical mode')
  //       : loggerManager.closeFileSaver(logger: logger);
  // }

  // /// Retrieves the status of the file saver.
  // ///
  // /// - [logger]: The logger name (defaults to "Main").
  // ///
  // /// Returns: The [LogStatus] of the file saver, or [LogStatus.idle] if in critical mode.
  // static LogStatus getFileSaverStatus({String logger = 'Main'}) {
  //   return isCriticalMode
  //       ? LogStatus.idle
  //       : loggerManager.getFileSaverStatus(logger: logger);
  // }

  /// Starts a timeline for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError startTimeLine({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.startTimeLine(logger: logger);
  }

  /// Stops the timeline for the specified logger.
  ///
  /// - [logger]: The logger name (defaults to "Main").
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError stopTimeLine({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.stopTimeLine(logger: logger);
  }

  /// Enters critical mode, enabling message storage.
  ///
  /// - [size]: The maximum number of messages to store (defaults to 10).
  /// - [growable]: If true, the storage can grow beyond [size].
  ///
  /// Returns: A [LogError] indicating success (always 0).
  static LogError enterCriticalMode({int size = 10, bool growable = true}) {
    isCriticalMode = true;
    criticalStorage = CriticalStorage(size, growable: growable);
    criticalStorage!.storeMessage('', '', '', '');
    criticalStorage!.resetIndex();
    return LogError(0);
  }

  /// Exits critical mode and processes stored messages.
  ///
  ///
  /// Returns: A [LogError] indicating success or failure.
  static LogError exitCriticalMode(
      //{String? report, String category = '', Object? level}
      ) {
    isCriticalMode = false;
    var err = criticalStorage?.exitCriticalMode(); //report, category, level);
    criticalStorage = null;
    return err ?? LogError(-1, message: 'critical Storage not found');
  }

  /// Configures the visual decoration and color scheme used for log output on the console.
  ///
  /// This function allows you to customize how log messages appear for a specific logger by
  /// adjusting decoration style, display options, and color schemes.
  ///
  /// - [logger]: The name of the logger to configure (default: `'Main'`).
  /// - [timeStamp]: Whether to display the timestamp (default: `true`).
  /// - [timeLine]: Whether to display timeline information (default: `true`).
  /// - [loggerID]: Whether to display the logger ID (default: `true`).
  /// - [category]: Whether to display the category label (default: `true`).
  /// - [mode]: The decoration style to apply. Accepted values:
  ///   - `'none'`: No decoration.
  ///   - `'emoji'`: Adds emoji indicators per log level.
  ///   - `'level'`: Shows log level names (e.g., INFO, ERROR).
  ///   - `'simple'`: Minimal styling.
  ///   - `'full'`: Displays all decoration elements.
  ///   - [emoji]: a list of emojis, one per level in range, separated by commas.
  ///   - [colorPanel]: A JSON string defining the color scheme.
  ///   - `'none'`: Disables color output.
  ///   - `'standard'`: Uses the built-in standard color palette.
  ///   - Custom: A JSON map assigning ANSI codes or color names per log level:
  ///     ```json
  ///     {
  ///       "colorPanel": {
  ///         "critical": "\u001B[31m",
  ///         "info": "black",
  ///         "debug": "blue"
  ///       }
  ///     }
  ///     ```
  ///
  /// Notes:
  /// - If either [mode] or [colorPanel] is set to `'none'`, the respective feature is disabled.
  /// - If the system is currently in critical mode, this call has no effect and returns an error.
  ///
  /// Returns a [LogError] object indicating success or failure.
  static LogError setDecoration(
      {String logger = 'Main',
      bool timeStamp = false,
      bool timeLine = false,
      bool loggerID = false,
      bool category = false,
      bool environment = false,
      String mode = 'none',
      String emoji = 'none',
      String colorPanel = 'none'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.setDecoration(
            logger: logger,
            category: category,
            loggerID: loggerID,
            timeLine: timeLine,
            timeStamp: timeStamp,
            environment: environment,
            mode: mode,
            emoji: emoji,
            colorPanel: colorPanel);
  }

  static LogError installService(
      {String logger = 'Main', required LogService service}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.installService(logger: logger, service: service);
  }

  static LogError removeService({String logger = 'Main'}) {
    return isCriticalMode
        ? LogError(-5, message: 'is in critical mode')
        : loggerManager.removeService(logger: logger);
  }
}
