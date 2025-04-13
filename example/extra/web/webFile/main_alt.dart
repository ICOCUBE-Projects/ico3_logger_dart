import 'dart:html' as html;
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  int count = 0;

  html.querySelector("#logButton")?.onClick.listen((_) {
    Log.info('core', 'Test Log ${count++}');
  });
}
