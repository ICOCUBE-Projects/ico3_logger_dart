import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';
import 'dart:io';

// to compile benchmark on windows
// dart compile exe benchmark.dart -o benchmark.exe

void main() {
  //  LogPrint.onPrint = (obj) => print(obj);

  List<BenchReport> benchList = [];
  Log.enableConsoleOutput(exclusive: true);
  Log.startTimeLine();
  var start = Timeline.now;
  var stop = 0;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    var stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test console system',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  Log.stopTimeLine();

  LogPrint.onPrint = (obj) => print(obj);
  Log.enableConsoleOutput(exclusive: true);
  Log.startTimeLine();
  start = Timeline.now;
  stop = 0;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    var stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test console print ext ',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  Log.stopTimeLine();

  LogPrint.onPrint = (obj) => stdout.writeln(obj);
  Log.enableConsoleOutput(exclusive: true);
  Log.startTimeLine();
  start = Timeline.now;
  stop = 0;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    var stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test console stdout ',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  Log.stopTimeLine();

  LogPrint.onPrint = (obj) => {};
  Log.enableConsoleOutput(exclusive: true);
  Log.startTimeLine();
  start = Timeline.now;
  stop = 0;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    var stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test null console ',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  Log.stopTimeLine();

  LogPrint.onPrint = null;

  Log.enableStorageOutput(exclusive: true);
  Log.startTimeLine();
  start = Timeline.now;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test Storage',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }

  Log.clearMessageList();
  Log.enableConsoleOutput(exclusive: true);
  Log.stopTimeLine();

  Log.stopTimeLine();
  var testProcess = 0;
  Log.enableProcessOutput(
      exclusive: true,
      onLogMessage: (message) {
        testProcess++;
      });
  Log.startTimeLine();
  start = Timeline.now;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test Process without ',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  stop = Timeline.now;
  Log.stopTimeLine();
  Log.critical('core', 'testProcess : $testProcess');

  Log.enableFileOutput(exclusive: true, logFileName: 'bench.txt');
  Log.startTimeLine();
  start = Timeline.now;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test File with flush',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }
  stop = Timeline.now;

  Log.enableConsoleOutput(exclusive: true);
  // benchList.add(BenchReport(reportComment: 'Test File with flush', logCount: 100, startTime: start, stopTime: stop));
  // Log.info('',
  //     'Test File speed time for 100 logs: $totalTimeUs µs, average time per log = ${averageTimeUs.toStringAsFixed(2)} µs');

  Log.enableFileOutput(
      exclusive: true, logFileName: 'benchNoFlush.txt', flush: false);
  Log.startTimeLine();
  start = Timeline.now;
  for (int j = 0; j < 2; j++) {
    start = Timeline.now;
    for (int i = 0; i < 1000; i++) {
      Log.critical('core', 'Critical system failure');
    }
    stop = Timeline.now;
    benchList.add(BenchReport(
        reportComment: 'Test File no flush',
        logCount: 1000,
        startTime: start,
        stopTime: stop));
  }

  // Log.printMessageList();
  //  Log.enableConsoleOutput(exclusive: true);
  Log.stopTimeLine();
  Log.enableConsoleOutput(exclusive: true);

  // Log.info('',
  //     'Test File no flush speed time for 100 logs: $totalTimeUs µs, average time per log = ${averageTimeUs.toStringAsFixed(3)} µs');

  var criticalBenchList = criticalModeBenchmarkLoop();
  Log.enableFileOutput(
      exclusive: true, logFileName: 'benchmark.txt', flush: false);

  for (var ben in criticalBenchList) {
    Log.info('', ben.getInfo());
  }
  for (var ben in benchList) {
    Log.info('', ben.getInfo());
  }
  Log.stopLoggers();
}

List<BenchReport> criticalModeBenchmarkLoop() {
  List<BenchReport> benchList = [];
  Log.enableConsoleOutput(exclusive: true);
  var count = 0;
  do {
    Log.info('test', 'Start critical mode ');
    Log.enterCriticalMode(size: 200);
    var start = Timeline.now;
    for (int i = 0; i < 100; i++) {
      Log.info('network', 'Request sent 1');
    }
    var stop = Timeline.now;
    Log.exitCriticalMode();
    benchList.add(BenchReport(
        reportComment: 'Test critical mode',
        logCount: 100,
        startTime: start,
        stopTime: stop));
    count++;
  } while (count < 100);

  return benchList;
}

class BenchReport {
  String reportComment;
  int logCount;
  int startTime;
  int stopTime;
  BenchReport(
      {required this.reportComment,
      required this.logCount,
      required this.startTime,
      required this.stopTime});

  String getInfo() {
    var totalTimeUs = stopTime - startTime;
    var averageTimeUs = totalTimeUs / logCount;
    return '$reportComment time for $logCount logs: $totalTimeUs µs, average time per log = ${averageTimeUs.toStringAsFixed(3)} µs';
  }
}
