import 'package:ico3_logger/ico3_logger.dart';

import 'package:test/test.dart';

void main() {
  test('Test base ICO3Log', () {
    List<LogSelector> lsl = [];
    var testCat = 'test(warning), -core, -rest(critical), tata';
    var tst = testCat.split(',');
    for (var sel in tst) {
      lsl.add(LogSelector.fromString(sel));
    }
    String result = lsl.map((e) => e.toString()).join(",");
    print(result);
    var lv1 = LogSelector.upperLogLevel(LogLevel.critical);
    var lv2 = LogSelector.upperLogLevel(LogLevel.fatal);
    var lv3 = LogSelector.upperLogLevel(LogLevel.info);

    var lv1l = LogSelector.lowerLogLevel(LogLevel.critical);
    var lv2l = LogSelector.lowerLogLevel(LogLevel.fatal);
    var lv3l = LogSelector.lowerLogLevel(LogLevel.info);
    print('end');
  });
}
