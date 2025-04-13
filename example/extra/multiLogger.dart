import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.setCategories('<clear> network(warning), process, core(critical)');
  Log.createLogger('LogTech', categories: '<clear> core');
  Log.createLogger('ATech',
      categories: '<clear> core', enableConsoleOutput: false);
  Log.enableProcessOutput(
      logger: 'ATech',
      exclusive: true,
      onLogMessage: (log) {
        LogPrint.print('ATech ==> $log');
      });
  Log.fatal('network', 'test fatal network V2');
  Log.critical('core', 'test critical core V2');
  Log.info('core', 'test info core V2');
  Log.closeLogger(logger: 'ATech');
  Log.fatal('network', 'test fatal network V2');
  Log.critical('core', 'test critical core V2');
  Log.info('core', 'test info core V2');
  Log.closeLogger(logger: 'LogTech');
  Log.fatal('network', 'test fatal network V2');
  Log.critical('core', 'test critical core V2');
  Log.info('core', 'test info core V2');
}
