import 'package:ico3_logger/ico3_logger.dart';

void main() {

 //  Log.setDecoration(timeStamp: true, category: true);
  Log.installService(service: LoggerPostFatalService(size:25));
  // test it...
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log n°: $i test');
  }
  // do a fatal error
  Log.fatal('testLog', ' log Fatal test');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log bis n°: $i test');
  }
}
