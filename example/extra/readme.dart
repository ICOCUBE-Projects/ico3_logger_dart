import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.info('', 'Hello World');
  Log.setDecoration(mode: 'emoji', timeLine: true, category: true);
  Log.debug('network', 'Connected 🚀');
  Log.enterCriticalMode(size: 200);
  Log.critical('core', 'critical 🚨');
  Log.warning('core', 'faster');
  Log.critical('core', 'faster 🚀');
  Log.debug('core', 'fast ');
  Log.warning('dev', 'faster');
  Log.critical('dev', 'faster 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'Start the job 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'Start the job 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.debug('', 'fast ');
  Log.warning('', 'faster');
  Log.critical('', 'faster 🚀');
  Log.exitCriticalMode();

  //ADD INFORMATION
  Log.setDecoration(category: true); // Add Log Information
  Log.debug('network', 'Start connection');

  // FILTER BY CATEGORIES
  Log.setCategories('<clear> core, ui'); // select log on categories
  Log.warning('network', 'Waiting connection'); //not selected
  Log.warning('core', 'Waiting core initialisation'); //selected
  Log.info('ui', 'enter in ui'); //selected

  // FILTER BY CATEGORY + LEVEL
  Log.setCategories(
      '<clear> core, ui(critical)'); // select log on categories and level
  Log.warning('core', 'Waiting core initialisation'); //selected
  Log.warning(
      'ui', 'try to restart initialisation'); //not selected lower to critical
  Log.critical('ui', 'cannot restart initialisation'); // selected

  // ADD TIMESTAMP
  Log.setDecoration(
      category: true, timeStamp: true); // Add more Log Information
  Log.warning('core', 'Waiting core initialisation');
  Log.fatal('ui', 'enter in CLI mode');

  // SEND LOG TO FILE IN JSON FORMAT  or CSV
  Log.setCategories('<clear> all');
  Log.enableFileOutput(
      logFileName: "log.json", format: SaveFormat.json, exclusive: true);
  // logFileName: "log.csv", format: SaveFormat.csv, exclusive: true);
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.disableFileOutput(); // disable and close File output

  // SEND LOG TO PROCESS
  Log.enableProcessOutput(
      onLogMessage: (message) {
        print('==> ${message.message}');
      },
      exclusive: true);
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.disableProcessOutput();

  // STORE LOG IN MEMORY AND PROCESS IT
  Log.enableStorageOutput(
      exclusive: true); // active Storage output, use only Storage
  Log.info('app', 'App function A');
  Log.info('app', 'App function B');
  Log.info('core', 'System still running');
  Log.printMessageList(); // output messages list to console;
  Log.saveMessageList(
      logFileName: 'log1.csv', format: SaveFormat.csv); //output to File
  Log.processMessageList(onLogMessage: (message) {
    // process messages list in custom function
    print(message.message);
  });
  for (var message in Log.getMessageList()) {
    // use directly the messages stored
    print('--> ${message.message}');
  }
  Log.clearMessageList();
  Log.disableStorageOutput();

  // USE TIMELINE
  Log.setDecoration(category: true, timeLine: true, mode: 'none');
  Log.startTimeLine();
  Log.info('app', 'App function A TimeLine');
  Log.info('network', 'connection OK TimeLine');
  Log.stopTimeLine();

  // USE CRITICAL MODE
  Log.setDecoration(category: true, timeLine: true, mode: 'none');
  Log.enterCriticalMode(size: 50, growable: true);
  Log.info('app', 'App function A CriticalMode');
  Log.info('network', 'connection OK CriticalMode');
  Log.exitCriticalMode();

  // POSTMORTEM LOG
 //  Log.installService(service: LoggerPostFatalService(size: 10));
  // Log.enableProcessOutput(
  //     onLogMessage: LoggerPostFatalExtension(size: 25, useConsole: true).processMessage);

  // set Decoration je ne sais pas ou le mettre
// SET DECORATION TO PUT CONSOLE LOG MESSAGE
  //----------------------------------------------------------
  Log.setDecoration(
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'emoji'); // Add emoji
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');

  // use custom emoji
  Log.setDecoration(
      // with custom emoji
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'emoji',
      emoji: '😛,🙂,😨,🥶,🥵,🤬');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');

  Log.setDecoration(
      // Level colored depending level
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
      mode: 'simple', // level colored and loggerID and category high lighted
      colorPanel: 'dark');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');

  Log.setDecoration(
      timeStamp: true,
      loggerID: true,
      category: true,
      mode: 'full', // full message colored
      colorPanel: 'dark');
  Log.info('app', 'App function A');
  Log.critical('network', 'connection critical');
  Log.setDecoration(loggerID: true, category: true, mode: 'none');
  //----------------------------------------------------

  // Log.loadContext('path');

  /*
  loggers:
    -   id: "Main"
        categories: "<clear> core(warning), network"
        outputs:
          console: true
          file:
            path: "log.json"
            format: "json"
            append: true
            flush: false

    -   id: "log1"
        categories: "<clear> all(warning), -ui(warning), -core(warning)"
        outputs:
          console: true
          storage: true
        decoration:
          mode: 'full'
          colorPanel: |
            {
              "levelColors": {
                "info":"\\u001B[97m",
                "debug":"dark",
                "warning":"standard",
                "error":"dark",
                "critical":"standard",
                "fatal":"whiteOnBlue"
              }
            }

    -   id: "log2"
        categories: "<clear> all"
        outputs:
          process:
            function: "printMessage"


   */
}
