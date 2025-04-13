import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableFileOutput(logFileName: 'log.text', exclusive: true);
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
  Log.disableFileOutput();

//  Log.setDecoration(timeStamp: false, timeLine: false, loggerID: false, category: false, mode: 'emoji', colorPanel: 'dark');
  Log.setDecoration(); // is none => normal display
  Log.warning('core', 'warning system');
  Log.setDecoration(
      timeStamp: false,
      timeLine: false,
      loggerID: false,
      category: false); // minimal message
  Log.warning('core', 'warning system');
  Log.setDecoration(mode: 'emoji'); // color panel is not necessary
  Log.warning('core', 'warning system');
  Log.setDecoration(
      mode: 'level',
      colorPanel: 'dark'); // color only on level with dark color panel
  Log.warning('core', 'warning system');
  Log.setDecoration(
      mode: 'simple',
      colorPanel:
          'dark'); // color only on level with dark color panel, and Logger and category in highlight
  Log.warning('core', 'warning system');
  Log.setDecoration(
      mode: 'full',
      colorPanel:
          'standard'); // color only on the full message with standard color panel,
  Log.warning('core', 'warning system');
  Log.setDecoration(mode: 'full', colorPanel: '''{ "levelColors": {
      "info":"\\u001B[97m",
      "debug":"dark",
      "warning":"standard",
      "error":"dark",
      "critical":"standard",
      "fatal":"whiteOnBlue"
      }}''');
  Log.error('core', 'error system');

  Log.setDecoration(mode: 'simple', colorPanel: 'dark');
  Log.enableStorageOutput(exclusive: true);
  Log.startTimeLine();
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
  var start = Timeline.now;
  for (int j = 0; j < 10; j++) {
    start = Timeline.now;
    for (int i = 0; i < 20; i++) {
      Log.critical('core', 'Critical system failure');
    }
  }
  var stop = Timeline.now;
  var totalTimeUs = stop - start;
  var averageTimeUs = totalTimeUs / 20;

  // Log.fatal('core', 'Fatal system failure');
  Log.printMessageList();
  Log.enableConsoleOutput(exclusive: true);
  Log.stopTimeLine();
  Log.info('',
      'Test storage speed time for 20 logs: $totalTimeUs µs, average time per log = ${averageTimeUs.toStringAsFixed(2)} µs');
  Log.setDecoration(
      timeStamp: false,
      timeLine: false,
      loggerID: false,
      category: false,
      mode: 'full',
      colorPanel: 'dark');
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
  Log.fatal('core', 'Fatal system failure');

  Log.info('', 'Hello World');
  Log.critical('core', 'Critical system failure');
  Log.debug('core', 'core is Ok ');

  Log.loadContext('start.yaml');
  Log.log('network', 'Network initialization phase 1'); // Processed
  Log.critical('', 'Process running 1/3'); // Processed
  Log.log('core', 'Critical system failure', level: 'warning'); // Processed
  Log.warning('core', 'Critical system failure 2'); // Processed
  Log.setCategories('network(warning), process, core(critical)');

  Log.info('network', 'Network initialization phase 2'); // not Processed
  Log.log('process', 'Process running 2/3', level: 'info'); // Processed
  Log.warning('core', 'Critical system failure'); // not Processed

  Log.enableStorageOutput(); // All message stored inside memory

  Log.log('network', 'Network initialization phase 3',
      level: 'warning'); // Processed
  Log.log('network', 'Network initialization phase 4',
      level: 'critical'); // Processed
  Log.log('process', 'Process running 3/3'); // Processed
  Log.saveMessageList(logFileName: 'logs.csv', format: SaveFormat.csv);
  Log.setCategories('<clear>');

  Log.createLogger('loggerExt', categories: 'network(critical)');

  Log.log('network', 'Network initialization phase 3',
      level: 'warning'); // Processed
  Log.log('network', 'Network initialization phase 4',
      level: 'critical'); // Processed
  Log.log('process', 'Process running 3/3'); // Processed
}
