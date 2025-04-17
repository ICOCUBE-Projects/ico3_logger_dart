import 'package:ico3_logger/ico3_logger.dart';


abstract class LogService{
  LoggerBase? masterLogger;

  LogError installLogger(LoggerBase logger){
    masterLogger = logger;
    return LogError(0);
  }

  LogError receiveLog(LogMessage message);
  LogError outLog(LogMessage message){
    return masterLogger?.postProcessLogMessage(message) ?? LogError(-1, message: "masterLogger don't exist");
  }

  LogError startService() => LogError(0);
  LogError stopService() => LogError(0);

}

class LogServiceMinimum extends LogService{
  @override
  LogError receiveLog(LogMessage message) => outLog(message);
}

