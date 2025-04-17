import 'package:ico3_logger/ico3_logger.dart';


abstract class LogService{
  LoggerBase? masterLogger;

  LogError installLogger(LoggerBase logger){
    masterLogger = logger;
    return LogError(0);
  }

  LogError processMessage(LogMessage message);

  LogError startService() => LogError(0);
  LogError stopService() => LogError(0);


}