import 'package:ico3_logger/ico3_logger.dart';

/// A service used to capture logs in a structured pre-trigger/post-trigger fashion.
///
/// This is useful for debugging scenarios where you want to observe log context
/// before and after a specific trigger condition is met.
class LogProbeService extends LogService {
  /// Creates a new [LogProbeService].
  ///
  /// [probeController] manages the trigger condition.
  /// [probeName] is an optional identifier used in tagging.
  /// [preSize] and [postSize] determine the size of log buffers before and after trigger.
  /// [repeat] defines how many capture cycles should run.
  /// Optional callbacks are triggered on acquisition validation, completion, and final repetition end.
  LogProbeService({
    required this.probeController,
    this.probeName,
    this.preSize = 0,
    this.postSize = 0,
    int repeat = 1,
    this.onTriggerValidation,
    this.onAcquisitionComplete,
    this.onEndRepeat,
    this.triggerCount = 1,
  }) {
    probeController.setScope(this);
    probeRepeat = ProbeRepeat(count: repeat);
    startProbe();
  }

  /// The main buffer that stores log messages.
  late LogBuffer<LogMessage?> mainLogBuffer;

  /// Manages the repetition count of acquisitions.
  late ProbeRepeat probeRepeat;

  /// Controls the triggering logic.
  final ProbeController probeController;

  /// Number of log entries to store before the trigger.
  int preSize;

  /// Number of log entries to store after the trigger.
  int postSize;

  /// Counter for the number of post-trigger logs collected.
  int postCount = 0;

  /// Number of trigger events required before transition to post-load.
  int triggerCount;

  /// Optional identifier used in log tags.
  final String? probeName;

  /// Current state of the probe.
  ProbeStatus probeStatus = ProbeStatus.idle;

  /// Counts the number of acquisition cycles completed.
  int acquisitionCount = 0;

  /// Counts the number of triggers received in the current cycle.
  int triggerIndex = 0;

  /// Called when a trigger condition is validated. Return false to ignore trigger.
  final bool Function(String id, LogMessage message)? onTriggerValidation;

  /// Called when a capture cycle (acquisition) completes.
  final Function(String id)? onAcquisitionComplete;

  /// Called when all capture repetitions are completed.
  final Function(String id)? onEndRepeat;

  @override
  LogError receiveLog(LogMessage message) {
    if (probeStatus == ProbeStatus.idle) {
      return LogError(-1, message: 'LogScope Stopped');
    }
    if (probeStatus == ProbeStatus.complete) {
      return LogError(-1, message: 'LogScope Completed');
    }

    message.serviceTag = idNoTrig;
    _addMainLoadMessage(message);
    if (probeStatus == ProbeStatus.postLoad) {
      postCount++;
    }


    if (probeStatus == ProbeStatus.preLoad) {
      if (probeController.trigMessage(message)) {
        triggerIndex++;
        if (triggerIndex == triggerCount) {
          bool val = onTriggerValidation?.call(
                  '%$probeName-$acquisitionCount', message) ??
              true;
          if (!val) {
            triggerIndex--;
          } else {
            message.serviceTag = idTrig;
            probeStatus = ProbeStatus.postLoad;
            postCount = 0;
          }
        }
      }
    }

    if (probeStatus == ProbeStatus.postLoad) {
      if (postCount >= postSize) {
        probeStatus = ProbeStatus.complete;
      }
    }

    if (probeStatus == ProbeStatus.complete) {
      _processScopeMessage();
      onAcquisitionComplete?.call('%$probeName-$acquisitionCount');
      probeRepeat.increment();
      if (probeRepeat.isComplete) {
        // running = false;
        onEndRepeat?.call('%$probeName-$acquisitionCount');
        probeStatus = ProbeStatus.end;
      } else {
        startProbe();
      }
      acquisitionCount++;
    }

    return LogError(0);
  }

  /// Adds a log message to the main buffer.
  void _addMainLoadMessage(LogMessage message) {
    mainLogBuffer.add(message);
  }

  /// Starts a new scope capture cycle.
  void startProbe() {
    mainLogBuffer = LogBuffer(size: preSize + postSize + 1);
    probeStatus = ProbeStatus.preLoad;
    triggerIndex = 0;
  }

  /// Stops the current capture scope.
  ///
  /// If [clear] is false, processes the buffer before stopping.
  void stopProbe({bool clear = true}) {
    if (!clear) {
      probeStatus = ProbeStatus.complete;
      // completed = true;
      _processScopeMessage();
    }
    probeStatus = ProbeStatus.end;
    // running = false;
  }

  /// Returns the tag used for messages after trigger is detected.
  String get idTrig => (probeName == null)
      ? '-TRIGGER-🔥 '
      : '-TRIGGER-🔥 %$probeName-$acquisitionCount';

  /// Returns the tag used for messages before trigger is detected.
  String get idNoTrig => (probeName == null)
      ? '            '
      : '            %$probeName-$acquisitionCount';

  /// Forces the trigger manually, bypassing trigger logic.
  ///
  /// An optional [message] can be provided for the forced log.
  void forceTrigger({String? message}) {
    var log = LogMessage(
        message: message ?? 'Trigger Forced',
        level: LogLevel.info,
        category: '**trigger**');
    _addMainLoadMessage(log);
    bool val =
        onTriggerValidation?.call('%$probeName-$acquisitionCount', log) ?? true;
    if (val) {
      probeStatus = ProbeStatus.postLoad;
      postCount = 0;
      log.serviceTag = idTrig;
    }
  }

  /// Sets up the scope parameters and restarts the capture cycle.
  void restartProbe({
    int preSize = -1,
    int postSize = -1,
    int triggerCount = -1,
    int repeat = -1,
  }) {
    stopProbe();
    this.preSize = preSize < 0 ? this.preSize : preSize;
    this.postSize = postSize < 0 ? this.postSize : postSize;
    this.triggerCount = triggerCount < 0 ? this.triggerCount : triggerCount;
    this.probeRepeat =
        ProbeRepeat(count: repeat < 0 ? probeRepeat.count : repeat);
    startProbe();
  }

  /// Processes the buffered messages by sending them to the master logger.
  void _processScopeMessage() {
    if (processLogMessage != null) {
      for (var msg in mainLogBuffer.getList()) {
        if (msg != null) {
          outLog(msg);
        }
      }
    }
  }
}

/// Defines the states of the [LogProbeService] capture cycle.
enum ProbeStatus {
  /// Probe is idle and not capturing logs.
  idle,

  /// Probe is capturing logs before the trigger.
  preLoad,

  /// Probe is capturing logs after the trigger.
  postLoad,

  /// Probe has completed its log capture.
  complete,

  end,

  na,
}

/// Abstract base class for defining a trigger mechanism used by a [LogProbeService].
///
/// A [ProbeController] decides whether a given [LogMessage] should trigger
/// the transition from pre-acquisition to post-acquisition state.
///
/// You can extend this class to define custom trigger logic.
abstract class ProbeController {
  /// Associated [LogProbeService] instance.
  LogProbeService? scope;

  /// Links this controller to a specific [LogProbeService].
  void setScope(LogProbeService prob) {
    scope = prob;
  }

  /// Evaluates the provided [LogMessage] to determine if it should act as a trigger.
  bool trigMessage(LogMessage message);
}
