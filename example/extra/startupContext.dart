import 'package:ico3_logger/ico3_logger.dart';

processNetwork(LogMessage message) {
  //...........
}

Map<String, Function(LogMessage message)> processMap = {
  'printMessage': (message) => print('-->>$message'),
  'sendMessage': processNetwork,
  'print': print,
};

void main(List<String> arguments) {
  String? contextFileArgument;

  for (final arg in arguments) {
    if (arg.startsWith('context=')) {
      contextFileArgument = arg.substring('context='.length);
      Log.loadContext(contextFileArgument, processMap: processMap);
    }
  }
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
}
