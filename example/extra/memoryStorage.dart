import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.setCategories('network(warning), process, core(critical)');
  Log.enableStorageOutput(); // All message stored inside memory

  Log.log('process', 'Process running 1/3', level: 'info'); // Processed
  Log.log('network', 'Network initialization phase 1',
      level: 'warning'); // Processed
  Log.log('network', 'Network initialization phase 2',
      level: 'critical'); // Processed
  Log.log('process', 'Process running 2/3'); // Processed
  Log.saveMessageList(logFileName: 'logs.csv', format: SaveFormat.csv);

  Log.getMessageList().clear(); // clear message list stored

  Log.log('network', 'Network running phase 1', level: 'warning'); // Processed
  Log.log('network', 'Network running phase 2', level: 'critical'); // Processed
  Log.log('process', 'Process running 3.3'); // Processed

  for (var lg in Log.getMessageList()) {
    // process all Log in storage
    print(lg);
  }
}
