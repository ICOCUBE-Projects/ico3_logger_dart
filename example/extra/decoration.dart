import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.info('', 'Hello World');
  Log.setDecoration(mode: 'emoji');
  Log.debug('', 'Start the job 🚀');
  Log.setDecoration(mode: 'emoji', emoji: '😛,🙂,😨,🥶,🥵,🤬');
  Log.info('core', 'warning system');
  Log.critical('core', 'warning system');
  Log.setDecoration(category: true, timeStamp: true,loggerID: true, environment: true);
  Log.critical('core', 'warning system', environment: 'i9-14900K');
  Log.setDecoration(category: true, timeStamp: true,loggerID: true, environment: true ,mode: 'level', colorPanel: 'dark');
  Log.critical('core', 'warning system', environment: 'i9-14900K');
  Log.setDecoration(category: true, timeStamp: true,loggerID: true, environment: true ,mode: 'simple', colorPanel: 'dark');
  Log.critical('core', 'warning system', environment: 'i9-14900K');
  Log.setDecoration(category: true, timeStamp: true,loggerID: true, environment: true ,mode: 'full', colorPanel: 'dark');
  Log.critical('core', 'warning system', environment: 'i9-14900K');


}