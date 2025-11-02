import 'package:ico3_logger/ico3_logger.dart';

/// A [ProbeController] that triggers only on fatal-level log messages.
class FatalTrigger extends ProbeController {
  LogProbeInterface? scope;

  @override
  void setScope(LogProbeInterface prob) {
    scope = prob;
  }

  @override
  bool trigMessage(LogMessage message) {
    return message.level == LogLevel.fatal;
  }
}

/// A configurable [ProbeController] that allows complex matching rules.
///
/// A message can be used as a trigger if it matches the configured:
/// - [level] or higher
/// - [environment] (if set)
/// - [category] (if set)
/// - [message] substring (if set)
class LogProbeController extends ProbeController {
  /// Optional substring that must be present in the log message.
  String message;

  /// Minimum [LogLevel] required for the message to be considered.
  LogLevel level;

  /// Optional environment name the log message must match.
  String environment;

  /// Optional category the log message must match.
  String category;
  LogProbeInterface? scope;

  /// Creates a [LogProbeController] with optional filtering rules.
  LogProbeController({
    this.message = '',
    this.level = LogLevel.none,
    this.environment = '',
    this.category = '',
  });

  @override
  void setScope(LogProbeInterface prob) {
    scope = prob;
  }

  /// Determines whether the [msg] should trigger the acquisition.
  @override
  bool trigMessage(LogMessage msg) {
    if (level != LogLevel.none && msg.level.index < level.index) {
      return false;
    }
    if (environment.isNotEmpty && msg.environment != environment) {
      return false;
    }
    if (category.isNotEmpty && msg.category != category) {
      return false;
    }
    if (message.isNotEmpty && !msg.message.contains(message)) {
      return false;
    }
    return true;
  }

  /// Stops the probe.
  ///
  /// If [clear] is true, the internal buffer is cleared and nothing is stored.
  void stopProbe({bool clear = true}) => scope?.stopProbe(clear: clear);

  /// Starts the probe with current configuration.
  void startProbe() => scope?.startProbe();

  /// Restarts the probe with optional updated parameters.
  ///
  /// Use -1 to retain existing values.
  void restartProbe({
    int preSize = -1,
    int postSize = -1,
    int repeat = -1,
    int triggerCount = -1,
  }) =>
      scope?.restartProbe(
        preSize: preSize,
        postSize: postSize,
        triggerCount: triggerCount,
        repeat: repeat,
      );

  /// Forces a manual trigger.
  ///
  /// Optionally provide a [message] to be logged.
  void forceTrigger({String? message}) => scope?.forceTrigger(message: message);

  /// Updates the trigger configuration.
  ///
  /// Fields left null will keep their current value.
  void setup({
    String? message,
    LogLevel? level,
    String? environment,
    String? category,
  }) {
    this.message = message ?? this.message;
    this.level = level ?? this.level;
    this.environment = environment ?? this.environment;
    this.category = category ?? this.category;
  }

  /// Returns the current probe status.
  ProbeStatus get probe => scope?.probeStatus ?? ProbeStatus.na;

  @override
  String toString() {
    return 'MessageTrigger('
        'message: "$message", '
        'level: $level, '
        'environment: "$environment", '
        'category: "$category"'
        ')';
  }
}
