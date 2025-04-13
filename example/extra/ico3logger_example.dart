import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.setCategories('network(warning), process, core(critical)');
  // ICO3Log.openFileSaver(logFileName: 'TestCSV.csv', format: SaveFormat.csv);
  Log.log('network', 'test message', level: 'fatal');
  Log.setOnLogMessage((message) {
    print('onLogMessage(Main) --> $message');
  });
  Log.enableFileOutput(
      logger: 'LogTech', logFileName: 'log.txt', format: SaveFormat.text);
  Log.enableStorageOutput();
  Log.enableProcessOutput();
  Log.createLogger('LogTech');
  Log.setCategories(
      logger: 'LogTech', 'network(warning), process, core(warning)');
  Log.log('network', 'test message V2', level: 'fatal');
  Log.log('core', 'test message V2 Core 1/2 ', level: 'warning');
  Log.log('core', 'test message V2 Core 2/2', level: 'warning');
  var mlist = Log.getMessageList();
  mlist.clear();
  Log.log('core', 'test message V2 Core 1/1', level: 'warning');
  Log.log('core', 'test message V2 Core 2/7', level: 'warning');
  Log.startTimeLine();
  Log.log('core', 'test message V2 Core 3/7', level: 'warning');
  Log.log('core', 'test message V2 Core 4/7', level: 'warning');
  Log.log('core', 'test message V2 Core 5/7', level: 'warning');
  Log.log('core', 'test message V2 Core 6/7', level: 'warning');
  Log.stopTimeLine();

  Log.saveMessageList(
      logger: 'LogTech', logFileName: 'TestLog.csv', format: SaveFormat.csv);
  Log.log('core', 'test message V2 Core 7/7', level: 'critical');
  //  ICO3Log.closeFileSaver();
  var rres = Log.setCategories(
      logger: 'ALogTech', 'network(warning), process, core(warning)');

  var mlist1 = Log.getMessageList();
  Log.enableStorageOutput(logger: 'LogTech');
  var res = Log.saveMessageList(logFileName: 'TestLog.txt');
  var res1 =
      Log.saveMessageList(logFileName: 'TestLog.csv', format: SaveFormat.csv);
  var res2 =
      Log.saveMessageList(logFileName: 'TestLog.json', format: SaveFormat.json);
}
