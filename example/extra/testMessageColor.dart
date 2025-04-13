import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.log('network', 'Network initialization phase 1'); // Processed
  Log.log('process', 'Process running 1/3', level: 'info'); // Processed
  Log.log('core', 'Critical system failure', level: 'warning'); // Processed
  Log.setDecoration(mode: 'full', colorPanel: '{ "levelColors": "standard"}');
  Log.info('network', 'Network initialization info');
  Log.debug('network', 'Network initialization debug');
  Log.warning('network', 'Network initialization warning');
  Log.error('network', 'Network initialization error');
  Log.critical('network', 'Network initialization critical');
  Log.fatal('network', 'Network initialization fatal');
  Log.setDecoration(mode: 'emoji', colorPanel: 'none');
  Log.info('network', 'Network initialization info');
  Log.debug('network', 'Network initialization debug');
  Log.warning('network', 'Network initialization warning');
  Log.error('network', 'Network initialization error');
  Log.critical('network', 'Network initialization critical');
  Log.fatal('network', 'Network initialization fatal');
  //  Log.setColorsLevel(colorPanel: 'dark');
  Log.setDecoration(mode: 'level', colorPanel: '{ "levelColors": "dark"}');
  Log.info('network', 'Network initialization info');
  Log.debug('network', 'Network initialization debug');
  Log.warning('network', 'Network initialization warning');
  Log.error('network', 'Network initialization error');
  Log.critical('network', 'Network initialization critical');
  Log.fatal('network', 'Network initialization fatal');
  Log.setDecoration(mode: 'simple', colorPanel: '{ "levelColors": "dark"}');
  Log.info('network', 'Network initialization info');
  Log.debug('network', 'Network initialization debug');
  Log.warning('network', 'Network initialization warning');
  Log.error('network', 'Network initialization error');
  Log.critical('network', 'Network initialization critical');
  Log.fatal('network', 'Network initialization fatal');

  var err = Log.setDecoration(mode: 'full', colorPanel: '''{ "levelColors": {
      "info":"\\u001B[97m",
      "debug":"dark",
      "warning":"standard",
      "error":"dark",
      "critical":"standard",
      "fatal":"whiteOnBlue"
      }}''');
  print(err);
  Log.info('network', 'Network initialization info');
  Log.debug('network', 'Network initialization debug');
  Log.warning('network', 'Network initialization warning');
  Log.error('network', 'Network initialization error');
  Log.critical('network', 'Network initialization critical');
  Log.fatal('network', 'Network initialization fatal');
}
