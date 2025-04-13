import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableProcessOutput(
      exclusive: true,
      onLogMessage: (log) {
        print('-->> $log');
      });
  Log.enableProcessOutput(exclusive: true, onLogMessage: processLog);
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
  Log.disableProcessOutput();
}

processLog(LogMessage message) {
  print('-->> $message');
}
