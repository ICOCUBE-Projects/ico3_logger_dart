import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableFileOutput(
      logFileName: 'logA.csv', format: SaveFormat.csv, exclusive: true);
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
  Log.disableFileOutput();
}
