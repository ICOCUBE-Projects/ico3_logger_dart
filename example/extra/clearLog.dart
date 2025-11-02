import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.log('network', 'Network initialization phase 1'); // Processed
  Log.log('process', 'Process running 1/3', level: 'info'); // Processed
  Log.log('core', 'Critical system failure 1', level: 'warning'); // Processed
  Log.enableStorageOutput();
  Log.log('network', 'Network initialization phase 2'); // Processed
  Log.log('process', 'Process running 2/3', level: 'info'); // Processed
  Log.log('core', 'Critical system failure 2', level: 'warning'); // Processed
  Log.printMessageList(tag:'*');
  Log.log('network', 'Network initialization phase 3'); // Processed
  Log.log('process', 'Process running 3/3', level: 'info'); // Processed
  Log.log('core', 'Critical system failure 3', level: 'warning'); // Processed
  Log.printMessageList(clear: true, tag: '>');
  Log.log('network', 'Network initialization phase 4'); // Processed
  Log.log('process', 'Process running 4/3', level: 'info'); // Processed
  Log.log('core', 'Critical system failure 4', level: 'warning'); // Processed
  Log.log('core', 'End of Test', level: 'warning'); // Processed
  Log.printMessageList(clear: true);
}
