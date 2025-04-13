import 'package:ico3_logger/ico3_logger.dart';

void main() {
  // set directly Extension.processMessage in  onLogMessage
  Log.enableProcessOutput(
      exclusive: true,
      onLogMessage: LoggerPostFatalExtension(
              size: 25,
              fileName: 'fatal.csv',
              format: SaveFormat.csv,
              autoExit: true)
          .processMessage);
  // test it...
  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log n°: $i test', level: 'warning');
  }
  // do a fatal error
  Log.log('testLog', ' log Fatal test', level: 'fatal');
  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log bis n°: $i test', level: 'warning');
  }
}
