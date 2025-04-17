import 'package:ico3_logger/ico3_logger.dart';

import 'LogTrigger.dart';


void main() {

  //  Log.setDecoration(timeStamp: true, category: true);
  Log.installService(service: SnifferLogService(trigger: LogTrigger(level:'critical'),preSize: 100, postSize: 25, triggerCount: 1));
  // test it...
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log n°: $i test');
  }
  // do a fatal error
  Log.fatal('testLog', ' log Fatal test');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log bis n°: $i test');
  }
  Log.fatal('testLog', ' log Fatal test2');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }
}
