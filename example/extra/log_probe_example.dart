import 'package:ico3_logger/ico3_logger.dart';

void main() {
  var probeController = LogProbeController(
      level: LogLevel.critical, category: 'testLog', message: 'log F');

  Log.installService(
      service: LogProbeService(
          probeName: 'testA',
          onEndRepeat: (id) {
            Log.disableAllOutputs();
            LogIO.exitApplication();
          },
          probeController: FatalTrigger(),
          preSize: 50,
          postSize: 0,
          repeat: 1,
          triggerCount: 1));


  Log.installService(
      service: LogProbeService(
          probeName: 'testA',
          onAcquisitionComplete: (id) =>
              LogPrint.print('onAcquisitionComplete $id'),
          onTriggerValidation: (id, msg) {
            LogPrint.print('onTriggerValidation $id');
            return true;
          },
          onEndRepeat: (id) => LogPrint.print('onEndRepeat $id'),
          probeController: probeController,
          preSize: 10,
          postSize: 5,
          repeat: 2,
          triggerCount: 1));
  // test it...
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log n°: $i test');
  }

  // do a fatal error
  probeController.forceTrigger(message: 'do trigger manually');
  //  trigger.stopSniffer();
  // Log.fatal('testLog', ' log Fatal test');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log bis n°: $i test');
  }
  probeController.restartProbe(preSize: 5, repeat: 5, triggerCount: 2);
  Log.fatal('testLog', ' log Fatal test2');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }
  Log.fatal('testLog', ' log Fatal test3');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test4');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test5');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test6');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test7');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test8');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test9');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test10');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test11');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }

  Log.fatal('testLog', ' log Fatal test12');
  for (int i = 0; i < 56; i++) {
    Log.warning('testLog', ' log ter n°: $i test');
  }
}
