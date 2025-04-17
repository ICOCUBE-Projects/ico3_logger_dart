import 'package:ico3_logger/ico3_logger.dart';

class LogTrigger extends SnifferTrigger{

  LogTrigger({ String level = 'info'}){
    logLevel = LogSelector.parseLogLevel(level);
  }

  late LogLevel logLevel;

  @override
  bool trigMessage(LogMessage message){
    return message.level == logLevel;
  }
}

