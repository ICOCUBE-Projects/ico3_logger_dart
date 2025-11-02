import 'package:ico3_logger/ico3_logger.dart';

abstract class LogProbeInterface {
  void forceTrigger({String? message});

  ProbeStatus get probeStatus;

  void restartProbe({
    int preSize = -1,
    int postSize = -1,
    int triggerCount = -1,
    int repeat = -1,
  });

  void startProbe();

  void stopProbe({bool clear = true});
}

abstract class ProbeController {
  void setScope(LogProbeInterface prob);

  bool trigMessage(LogMessage message);
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
