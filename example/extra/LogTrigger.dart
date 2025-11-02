import 'package:ico3_logger/ico3_logger.dart';

class LogTrigger extends ProbeController {
  LogTrigger({String level = 'info'}) {
    logLevel = LogSelector.parseLogLevel(level);
  }

  late LogLevel logLevel;

  @override
  bool trigMessage(LogMessage message) {
    return message.level == logLevel;
  }

  LogProbeInterface? probeService;

  @override
  void setScope(LogProbeInterface prob) {
    probeService = prob;
  }
}
