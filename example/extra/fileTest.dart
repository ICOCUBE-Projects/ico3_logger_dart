import 'package:ico3_logger/ico3_logger.dart';

void main() {
  LogPrint.print(Log.getOutputsEnabled());
  Log.disableConsoleOutput();
  Log.enableFileOutput(logFileName: 'testLog.json', format: SaveFormat.json);
  Log.info('network', 'test log 1');
  Log.info('network', 'test log 2');
  Log.info('network', 'test log 3');
  Log.info('network', 'test log 4');
  Log.info('network', 'test log 5');
  Log.info('network', 'test log 6');
  Log.info('network', 'test log 7');
  Log.info('network', 'test log 8');
  Log.info('network', 'test log 9');
  Log.info('network', 'test log 10');
  Log.disableFileOutput();
}
