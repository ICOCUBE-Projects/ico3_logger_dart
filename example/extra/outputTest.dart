import 'package:ico3_logger/ico3_logger.dart';

void main() {
  LogPrint.print(Log.getOutputsEnabled());
  Log.disableConsoleOutput();
  LogPrint.print(Log.getOutputsEnabled());
  Log.enableConsoleOutput();
  LogPrint.print(Log.getOutputsEnabled());
  Log.enableStorageOutput();
  LogPrint.print(Log.getOutputsEnabled());
  Log.warning('test', 'test message');
  Log.warning('test', 'test message1');
  LogPrint.print(Log.printMessageList());
  Log.warning('test', 'test message2');
  Log.warning('test', 'test message3');
  LogPrint.print(Log.printMessageList(clear: true));
  Log.error('test', 'test messageA');
  Log.error('test', 'test messageA1');
  LogPrint.print(Log.printMessageList());
  Log.disableConsoleOutput();
  Log.error('test', 'test message<A>');
  Log.error('test', 'test message<A1>');
  LogPrint.print(Log.printMessageList());
  LogPrint.print(Log.getOutputsEnabled());
  Log.setOnLogMessage((message) {
    LogPrint.print('xxx-->> $message');
  });
  Log.enableProcessOutput(exclusive: true);
  Log.warning('test', 'test message');
  Log.warning('test', 'test message1');
  Log.enableFileOutput(
      logFileName: 'testAAA.json', exclusive: true, format: SaveFormat.json);
  Log.warning('test', 'test message20');
  Log.warning('test', 'test message30');
  Log.warning('test', 'test message21');
  Log.warning('test', 'test message31');
  Log.warning('test', 'test message22');
  Log.warning('test', 'test message32');
  Log.disableFileOutput();
  Log.enableFileOutput(logFileName: 'testAAA.csv', format: SaveFormat.csv);
  Log.warning('test', 'test message20x');
  Log.warning('test', 'test message30x');
  Log.warning('test', 'test message21x');
  Log.warning('test', 'test message31x');
  Log.warning('test', 'test message22x');
  Log.warning('test', 'test message32x');
  Log.disableFileOutput();
  Log.enableFileOutput(logFileName: 'testAAA.txt', format: SaveFormat.text);
  Log.warning('test', 'test message20x');
  Log.warning('test', 'test message30x');
  Log.warning('test', 'test message21x');
  Log.warning('test', 'test message31x');
  Log.warning('test', 'test message22x');
  Log.warning('test', 'test message32x');
  Log.disableFileOutput();

  LogPrint.print(Log.getOutputsEnabled());

  Log.enableStorageOutput(exclusive: true);
  Log.warning('test', 'test message20x');
  Log.warning('test', 'test message30x');
  Log.warning('test', 'test message21x');
  Log.warning('test', 'test message31x');
  Log.warning('test', 'test message22x');
  Log.warning('test', 'test message32x');

  Log.printMessageList();

  Log.getMessageList().clear();
  Log.warning('test', 'test message20x');
  Log.warning('test', 'test message30x');
  Log.warning('test', 'test message21x');
  Log.warning('test', 'test message31x');
  Log.warning('test', 'test message22x');
  Log.warning('test', 'test message32x');
  Log.saveMessageList(logFileName: 'testBBB.json', format: SaveFormat.json);
  Log.saveMessageList(logFileName: 'testBBB.csv', format: SaveFormat.csv);
  Log.saveMessageList(logFileName: 'testBBB.txt', format: SaveFormat.text);
}
