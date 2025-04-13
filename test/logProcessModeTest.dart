import 'package:ico3_logger/ico3_logger.dart';

import 'package:test/test.dart';

void main() {
  test('Test base ICO3Log', () {
    var count = 0;
    Log.setCategories('', clear: true);
    Log.setCategories('network(error), core(warning), test');
    expect(Log.getAllCategories(),
        equals(['network(error)', 'core(warning)', 'test(info)']));
    count++;
    var msgTest = LogMessage(
        message: 'test message', level: LogLevel.critical, category: 'core');
    LogMessage? msgResult;
    Log.enableProcessOutput(
        exclusive: true,
        onLogMessage: (message) {
          msgResult = message;
        });

    Log.critical(msgTest.category, msgTest.message);
    expect(msgResult?.toStringWOTimeStamp(),
        equals(msgTest.toStringWOTimeStamp()));
    msgTest.category = 'network';
    msgTest.message = 'test Message network';
    msgTest.level = LogLevel.warning;
    Log.warning(msgTest.category, msgTest.message);
    expect(msgResult?.toStringWOTimeStamp(),
        isNot(equals(msgTest.toStringWOTimeStamp())));
    msgTest.level = LogLevel.error;
    Log.error(msgTest.category, msgTest.message);
    expect(msgResult?.toStringWOTimeStamp(),
        equals(msgTest.toStringWOTimeStamp()));
  });

  test('Test base ICO3Log 2 ', () {
    print(Log.getAllCategories());
    Log.disableProcessOutput();
    Log.critical('test', 'Test message not to console');
    Log.enableConsoleOutput(exclusive: true);
    Log.critical('test', 'Test message 2 ');
    Log.enableProcessOutput(exclusive: true);
    Log.critical('test', 'Test message 3 ');
  });
}
