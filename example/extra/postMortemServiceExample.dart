import 'package:ico3_logger/ico3_logger.dart';

void main() {
  usePostMortemLogToFile();
  usePostMortemLogToConsole();
}

usePostMortemLogToFile() {
  LogPrint.print('');
  LogPrint.print('------- PostMortem Logs to file -------');
  Log.enableFileOutput(
    exclusive: true,
    logFileName: 'fatal.txt',
  );

  Log.installService(
      service: LogProbeService(
          probeName: 'PostMortem',
          onEndRepeat: (id) {
            Log.disableAllOutputs();
          },
          probeController: FatalTrigger(),
          preSize: 10));

  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log n°: $i test', level: 'warning');
  }
  // do a fatal error
  Log.log('testLog', ' log Fatal test', level: 'fatal');
  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log bis n°: $i test', level: 'warning');
  }
}

usePostMortemLogToConsole() {
  LogPrint.print('');
  LogPrint.print('------- PostMortem Logs to console-------');
  Log.enableConsoleOutput(exclusive: true);
  Log.installService(
      service: LogProbeService(
          probeName: 'PostMortem',
          onEndRepeat: (id) {
            Log.disableAllOutputs();
            LogIO.exitApplication();
          },
          probeController: FatalTrigger(),
          preSize: 10));

  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log n°: $i test', level: 'warning');
  }
  // do a fatal error
  Log.log('testLog', ' log Fatal test', level: 'fatal');
  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log bis n°: $i test', level: 'warning');
  }
}
