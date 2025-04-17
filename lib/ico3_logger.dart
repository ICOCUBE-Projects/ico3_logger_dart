/// The main library for the ico3logger package.
///
/// This library provides a comprehensive logging system for Dart applications,
/// supporting multiple log levels, output modes, and custom logger extensions.
/// It serves as the central entry point for accessing core logging utilities
/// like [Log], [LogMessage], and [LogError], as well as advanced features such
/// as critical mode handling and platform-specific file logging.
///
/// Example:
/// ```dart
/// import 'package:ico3logger/ico3logger_dart.dart';
///
/// void main() {
///   Log.info("App", "Application started");
///   var logger = LoggerPostFatalExtension(5);
///   logger.processMessage(LogMessage(message: "Crash", level: LogLevel.fatal));
/// }
/// ```
library;

// Core public APIs
/// Exports the main logging class.
export 'package:ico3_logger/log.dart';

/// Exports the error handling class for logging operations.
export 'package:ico3_logger/log_error.dart';

/// Exports the log message representation class.
export 'package:ico3_logger/log_message.dart';

// Internal utilities (from src/)
/// Exports utility functions for log formatting and timestamping.
export 'package:ico3_logger/src/log_utilities.dart';

// Internal utilities (from src/)
/// Exports print function.
export 'package:ico3_logger/src/log_print.dart';

/// Exports the manager for creating and handling loggers.
export 'package:ico3_logger/src/logger_manager.dart';

/// Exports the log level selector utility.
export 'package:ico3_logger/src/log_selector.dart';

/// Exports the storage system for critical mode logging.
export 'package:ico3_logger/src/critical_storage.dart';

// Logger implementations
/// Exports the abstract base class for custom loggers.
export 'package:ico3_logger/src/logger_base.dart';

/// Exports the default logger implementation.
export 'package:ico3_logger/src/logger.dart';

/// Exports the extension for handling fatal logs with automatic saving.
export 'package:ico3_logger/logger_postfatal_extension.dart';

/// Exports the extension for handling fatal logs with automatic saving.
export 'package:ico3_logger/src/service/log_service.dart';
export 'package:ico3_logger/src/service/postFatal_service.dart';
export 'package:ico3_logger/src/service/snifferLog_service.dart';
// Platform-specific abstractions
/// Exports the base interface for file-based logging.
export 'package:ico3_logger/src/platform/logger_filebase.dart';

/// Exports platform-specific logger implementations with conditional support:
/// - Unsupported fallback for unknown platforms.
/// - Web-specific implementation for JavaScript environments.
/// - Native implementation for IO-capable environments (e.g., desktop, mobile).
export 'package:ico3_logger/src/platform/unsupported.dart'
    if (dart.library.js) 'package:ico3_logger/src/platform/web.dart'
    if (dart.library.io) 'package:ico3_logger/src/platform/native.dart';

// Platform-specific file logging
/// Exports file logging implementations with conditional support:
/// - Unsupported fallback for unknown platforms.
/// - Native file logging for IO-capable environments.
/// - Web file logging for JavaScript environments.
export 'package:ico3_logger/src/platform/logger_fileunsupported.dart'
    if (dart.library.io) 'package:ico3_logger/src/platform/logger_filenative.dart'
    if (dart.library.html) 'package:ico3_logger/src/platform/logger_fileweb.dart';
// if (dart.library.js) 'package:ico3logger_dart/src/platform/logger_fileweb.dart';
