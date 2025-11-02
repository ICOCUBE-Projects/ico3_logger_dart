import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.connectViewer(
      address: 'ws://192.168.1.174:4222',
      onConnect: (logError) {
        Log.info('test', 'test message info');
        Log.warning('test', 'test message warning');
        Log.info('test', 'test message info 1');
        Log.info('test', 'test message info 2');
        Log.info('test', 'test message info 3');
        Log.info('test', 'test message info 4');
        Log.info('test', 'test message info 5');
        Log.info('test', 'test message info 6');
        Log.info('test', 'test message info 7');
        Log.info('test', 'test message info 8');
      });
}
