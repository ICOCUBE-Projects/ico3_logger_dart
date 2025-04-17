import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

void main() {


  Log.setDecoration(); // is none => normal display
  Log.warning('core', 'warning system');
  Log.setDecoration(
      timeStamp: false,
      timeLine: false,
      loggerID: false,
      category: false); // minimal message  Log.warning('core', 'warning system');

  Log.warning('core', 'warning system');

  Log.setDecoration(mode: 'emoji'); // color panel is not necessary
  Log.info('core', 'warning system');
  Log.debug('core', 'warning system');
  Log.warning('core', 'warning system');
  Log.error('core', 'warning system');
  Log.critical('core', 'warning system');
  Log.fatal('core', 'warning system');
  Log.setDecoration(mode: 'emoji', emoji: '😛,🙂,😨,🥶,🥵,🤬');
  Log.info('core', 'warning system');
  Log.debug('core', 'warning system');
  Log.warning('core', 'warning system');
  Log.error('core', 'warning system');
  Log.critical('core', 'warning system');
  Log.fatal('core', 'warning system');
  Log.setDecoration(mode: 'emoji',emoji: 'standard');
  Log.info('core', 'warning system');
  Log.debug('core', 'warning system');
  Log.warning('core', 'warning system');
  Log.error('core', 'warning system');
  Log.critical('core', 'warning system');
  Log.fatal('core', 'warning system');
}