// import 'dart:html' as html;
import 'package:web/web.dart' as web;
import 'dart:async';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  int count = 0;
  Timer? timer;
  Log.createLogger('ConsoleLog', categories: 'console');
  Log.setDecoration(
      logger: 'ConsoleLog', timeStamp: true, loggerID: true, category: true);

  Log.setCategories('<clear> file');
  Log.enableFileOutput(
      logFileName: 'testWeb.csv', format: SaveFormat.csv, exclusive: true);

  Log.setDecoration(category: true, timeStamp: true);
  web.document.querySelector("#logFileButton")?.onClick.listen((_) {
    Log.info('file', 'Test Log ${count++}');
    timer?.cancel();
    timer = Timer(Duration(seconds: 5), () {
      saveLogToFile("logs.txt");
    });
  });
  web.document.querySelector("#logConsoleButton")?.onClick.listen((_) {
    Log.info('console', 'Test Log ${count++}');
  });
}

void saveLogToFile(String fileName) {
  Log.disableFileOutput();
  Log.enableFileOutput(
      logFileName: 'testWeb.json', format: SaveFormat.json, exclusive: true);
}
