import 'package:ico3_logger/ico3_logger.dart';

abstract class LogService implements LogProbeInterface {
  // LoggerBase? masterLogger;
  LogError Function(LogMessage)? processLogMessage;

  LogError installLogProcessor(LogError Function(LogMessage)? processMessage) {
    processLogMessage = processMessage;
    return LogError(0);
  }

  LogError receiveLog(LogMessage message);
  LogError outLog(LogMessage message) {
    return processLogMessage?.call(message) ??
        LogError(-1, message: "postProcess don't exist");
  }

  LogError startService() => LogError(0);
  LogError stopService() => LogError(0);
}

// class LogServiceMinimum extends LogService {
//   @override
//   LogError receiveLog(LogMessage message) => outLog(message);
// }
