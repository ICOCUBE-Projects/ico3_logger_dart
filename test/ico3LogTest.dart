import 'package:ico3_logger/ico3_logger.dart';

import 'package:test/test.dart';

void main() {
  test('Test base ICO3Log', () {
    var testCount = 0;
    Log.setCategories('', clear: true);
    Log.setCategories('network(error), core(warning)');
    Log.log('core', 'test core info');
    Log.warning('core', 'test core warning');
    Log.createLogger('logTech');
    Log.setCategories(
        logger: 'logTech', 'extends(error), logical(critical), core(fatal)');
    LogUtilities.consolePrint(
        'test 1 cat ${Log.getAllCategories(logger: 'logTech')}');
    try {
      expect(Log.getAllCategories(logger: 'logTech').toString(),
          equals('[extends(error), logical(critical), core(fatal)]'));
      testCount++;
    } catch (ex) {
      LogUtilities.consolePrint(ex.toString(), color: "\x1B[31m");
      // stderr.writeln(ex);
    }
    Log.critical('core', 'test core critical');
    Log.fatal('core', 'test core fatal');
    Log.setCategories(logger: 'logTech', 'core(none)');
    Log.fatal('core', 'test core fatal bis');
    LogUtilities.consolePrint(
        'test 2 logger: logTech categories: ${Log.getAllCategories(logger: 'logTech')}');
    try {
      expect(Log.getAllCategories(logger: 'logTech').toString(),
          equals('[extends(error), logical(critical)]'));
      testCount++;
    } catch (ex) {
      // LogUtilities.consolePrint(ex.toString(), isRed: true);
      // stderr.writeln(ex);
    }
    var err = Log.setCategories(
        logger: 'logTech', 'core(none), tttt(none), ffff(none), extends(none)');
    LogUtilities.consolePrint('$err');
    LogUtilities.consolePrint(
        'test 3 logger: logTech categories: ${Log.getAllCategories(logger: 'logTech')}');
    try {
      expect(Log.getAllCategories(logger: 'logTech').toString(),
          equals('[logical(critical)]'));
      testCount++;
    } catch (ex) {
      //LogUtilities.consolePrint(ex.toString(), isRed: true);
      // stderr.writeln(ex);
    }
    Log.enableConsoleOutput(logger: 'logTech');
    Log.enableStorageOutput(logger: 'logTech');
    Log.critical('logical', 'test logical critical 1/4');
    Log.critical('logical', 'test logical critical 2/4');
    Log.critical('logical', 'test logical critical 3/4');
    Log.critical('logical', 'test logical critical 4/4');
    LogUtilities.consolePrint(LogUtilities.getListStringWOTime(
        Log.getMessageList(logger: 'logTech')));
    try {
      expect(
          LogUtilities.getListStringWOTime(
              Log.getMessageList(logger: 'logTech')),
          equals(
              '[[critical] (logical)  --> test logical critical 1/4 , [critical] (logical)  --> test logical critical 2/4 , [critical] (logical)  --> test logical critical 3/4 , [critical] (logical)  --> test logical critical 4/4 ]'));
      testCount++;
    } catch (ex) {
      // LogUtilities.consolePrint(ex.toString(), isRed: true);
      //stderr.writeln(ex);
    }
    var errA = Log.setCategories(
        logger: 'logTechxx', 'extends(error), logical(critical), core(fatal)');
    LogUtilities.consolePrint('$errA');
    try {
      expect(errA.toString(),
          equals('error:-1 --> (Logger not found [logTechxx])'));
      testCount++;
    } catch (ex) {
      // LogUtilities.consolePrint(ex.toString(), isRed: true);
      // stderr.writeln(ex);
    }
    var cat = Log.getAllCategories();
    var lMsg =
        LogMessage(message: 'testA', level: LogLevel.warning, category: 'test');
    Log.setOnLogMessage((message) {});

    Log.enableProcessOutput();

    LogUtilities.consolePrint('End of Test success $testCount/5');
  });
}
