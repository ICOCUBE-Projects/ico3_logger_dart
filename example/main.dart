import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  /// === Minimal usage: just like print() ===
  Log.info('', 'Application started');
  Log.warning('db', 'Missing DB config');
  Log.debug('app', 'Application ready');

  /// === Advanced filtering and decoration ===

  // Filter: only 'network' and 'core' (critical only)
  Log.setCategories('<clear> network, core(critical)');

  Log.info('network', 'Network initialization phase 1/2'); // Shown
  Log.info('process', 'Process running 1/2'); // Ignored
  Log.warning('core', 'System warning'); // Ignored

  // Enable only timestamp and loggerID
  Log.setDecoration(timeStamp: true, category: true, loggerID: true);
  Log.setCategories('<clear> process, core');

  Log.info('network', 'Network initialization phase 2/2'); // Ignored
  Log.info('process', 'Process running 2/2'); // Shown
  Log.info('core', 'System running'); // Shown

  advancedFunction(); // to explore advancedFunction
}

/*  result
    [info] Application started

    [warning] (db) --> Missing DB config
    [debug] (app) --> Application ready

    [info] (network) --> Network initialization phase 1/2

    (Main) 2025-04-12 22:50:14.583913 [info] Process running 2/2
    (Main) 2025-04-12 22:50:14.584939 [info] System running
 */

advancedFunction() {
  Log.setCategories('<clear all'); // select all categories
  logToFile();
  logToProcess();
  logToStorage();
  Log.enableConsoleOutput(exclusive: true); // output on console
  advanceCategoryFilter();
  multiLogger();
  useDecoration();
  useTimeLine();
  useCriticalMode();
  useCriticalModeLoop();
  useCriticalModeLoop();
  useCriticalModeLoop();
  useCriticalModeLoop();
  usePostMortemLog();
  usePostMortemLogToConsole();
}

logToFile() {
  // open file to save log in json format, use only file output
  Log.enableFileOutput(
      logFileName: "log.json", format: SaveFormat.json, exclusive: true);
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.disableFileOutput(); // disable and close File output
}

logToProcess() {
  LogPrint.print('');
  LogPrint.print('------- Log to Process -------');
  Log.enableProcessOutput(
      onLogMessage: (message) {
        print('==> ${message.message}');
      },
      exclusive: true);
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.disableProcessOutput();
}

logToStorage() {
  LogPrint.print('');
  LogPrint.print('------- Log to Storage -------');
  Log.enableStorageOutput(
      exclusive: true); // active Storage output, use only Storage
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.printMessageList(); // output messages list to console;
  Log.saveMessageList(logFileName: 'log1.csv', format: SaveFormat.csv);
  Log.processMessageList(onLogMessage: (message) {
    print(message.message);
  });
  for (var message in Log.getMessageList()) {
    print('--> ${message.message}');
  }
  Log.clearMessageList();
  Log.disableStorageOutput();
}

advanceCategoryFilter() {
  LogPrint.print('');
  LogPrint.print('------- Category Filters -------');
  Log.setCategories(
      '<clear> app, core(critical)'); // select categories app and core level critical and higher
  Log.info('app', 'App function A');
  Log.info('network', 'connection OK');
  Log.info('core', 'System still running');
  Log.critical('core', 'System enter in critical phase');
  Log.setCategories(
      '<clear> all, -core(warning)'); // select all categories excepted  core level warning and lower
  Log.info('app', 'App function A');
  Log.info('network', 'connection OK');
  Log.info('core', 'System still running');
  Log.critical('core', 'System enter in critical phase');
  Log.setCategories('<clear> all'); // restore all categories
}

multiLogger() {
  LogPrint.print('');
  LogPrint.print('------- Multiple Loggers -------');
  Log.setCategories(
      '<clear> all, -app'); // main logger process All log excepted app.
  Log.createLogger('Logger1',
      categories:
          '<clear> app, core'); //create Logger1 and process only app and core.
  Log.setDecoration(loggerID: true, category: true); // display loggerId on log
  Log.setDecoration(
      logger: 'Logger1',
      loggerID: true,
      category: true); // display loggerId on log
  Log.info('app', 'App function A');
  Log.info('network', 'connection OK');
  Log.info('core', 'System still running');
  Log.info('app', 'App function B');
  Log.info('network', 'connection OK');
  Log.info('core', 'System still running');
  Log.setCategories('<clear> all'); // restore all categories on main logger
  Log.closeLogger(logger: 'Logger1');
}

useDecoration() {
  LogPrint.print('');
  LogPrint.print('------- Decorations -------');
  Log.setDecoration(
      timeStamp: true, loggerID: true, category: true, mode: 'emoji');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');

  // use custom emoji
  Log.setDecoration(
      timeStamp: true, loggerID: true, category: true, mode: 'emoji', emoji: '😛,🙂,😨,🥶,🥵,🤬');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');

  Log.setDecoration(
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'level',
      colorPanel: 'dark');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');
  Log.setDecoration(
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'simple',
      colorPanel: 'dark');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');
  Log.setDecoration(
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'full',
      colorPanel: 'dark');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');
  Log.setDecoration(loggerID: true, category: true, mode: 'none');
}

useTimeLine() {
  LogPrint.print('');
  LogPrint.print('------- TimeLine -------');
  Log.setDecoration(category: true, timeLine: true, mode: 'none');
  Log.startTimeLine();
  Log.info('app', 'App function A TimeLine');
  Log.info('network', 'connection OK TimeLine');
  Log.info('core', 'System still running TimeLine');
  Log.info('app', 'App function B TimeLine');
  Log.info('network', 'connection OK TimeLine');
  Log.info('core', 'System still running TimeLine');
  Log.stopTimeLine();
}

useCriticalMode() {
  LogPrint.print('');
  LogPrint.print('------- Critical Mode -------');
  Log.setDecoration(category: true, timeLine: true, mode: 'none');
  Log.enterCriticalMode(size: 50, growable: true);
  var start = Timeline.now;
  Log.info('app', 'App function A CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('app', 'App function B CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('app', 'App function A CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('app', 'App function B CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('app', 'App function A CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('app', 'App function B CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.info('core', 'System still running CriticalMode');
  var stop = Timeline.now;
  Log.exitCriticalMode();
  Log.info('test  CriticalMode', 'time : ${stop - start} average time per log : ${(stop - start)/20} ');
}

useCriticalModeLoop() {
  LogPrint.print('');
  LogPrint.print('------- Critical Mode Loop -------');
  Log.setDecoration(category: true, timeLine: true, mode: 'none');
  Log.enterCriticalMode(size: 200);
  var start = Timeline.now;
  var loopNB = 100;
  for(int i = 0 ; i < loopNB; i++){
    Log.info('core', 'System still running CriticalMode');
  }
  var stop = Timeline.now;
  Log.exitCriticalMode();
  Log.info('test  CriticalMode', 'time : ${stop - start} average time per log : ${(stop - start)/loopNB} ');
}



usePostMortemLog() {
  LogPrint.print('');
  LogPrint.print('------- PostMortem Logs to file -------');
  Log.enableProcessOutput(
      exclusive: true,
      onLogMessage: LoggerPostFatalExtension(
              size: 25,
              fileName: 'fatal.csv',
              format: SaveFormat.csv,
              autoExit: false)
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

usePostMortemLogToConsole() {
  LogPrint.print('');
  LogPrint.print('------- PostMortem Logs to console-------');
  Log.enableProcessOutput(
      exclusive: true,
      onLogMessage:
          LoggerPostFatalExtension(size: 25, useConsole: true).processMessage);
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
