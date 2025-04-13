import 'package:ico3_logger/ico3_logger.dart';

void main(List<String> arguments) {
  for (final arg in arguments) {
    if (arg.startsWith('categories=')) {
      Log.setCategories(arg.substring('categories='.length));
    }
  }

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
}
