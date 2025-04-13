import 'dart:html' as html;
import 'dart:async';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  int count = 0;
  Timer? timer;

  Log.enableFileOutput(
      logFileName: 'testWeb.csv', format: SaveFormat.csv, exclusive: true);

  html.querySelector("#logButton")?.onClick.listen((_) {
    Log.info('core', 'Test Log ${count++}');
    timer?.cancel();
    timer = Timer(Duration(seconds: 5), () {
      saveLogToFile("logs.txt");
    });
  });
}

void saveLogToFile(String fileName) {
  Log.disableFileOutput();
  Log.enableFileOutput(
      logFileName: 'testWeb.json', format: SaveFormat.json, exclusive: true);
}
