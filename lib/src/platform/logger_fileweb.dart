import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:ico3_logger/ico3_logger.dart';

class LoggerFile extends LoggerFileBase {
  LoggerFile(
      {required super.append,
      required super.logFileName,
      super.flush = true,
      super.loggerID = '',
      super.format2File = SaveFormat.text}) {
    dataBuffer.clear();
    writeHeader();
  }

  StringBuffer dataBuffer = StringBuffer();

  @override
  LogError writeStringSync(String data) {
    dataBuffer.write(data);
    first = false;
    return LogError(0);
  }

  @override
  closeFile() {
    writeFooter();

    saveLogToFile(dataBuffer.toString());

    logStatus = LogStatus.closing;

    logStatus = LogStatus.closed;
  }

  void saveLogToFile(String logContent) {
    if (logContent.isEmpty) return;
    final blob = web.Blob([logContent.toJS].toJSProxyOrRef,
        web.BlobPropertyBag(type: 'text/plain'));

    final url = web.URL.createObjectURL(blob);

    final anchor =
        web.document.createElement('a').dartify() as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.setAttribute('download', logFileName);
    anchor.click();
    web.URL.revokeObjectURL(url);
  }

  // void saveLogToFileOld(String logContent) {
  //   if (logContent.isEmpty) return; // Évite de sauvegarder un fichier vide
  //
  //   // final logContent = logs.join("\n");
  //   final blob = html.Blob([logContent], 'text/plain');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   // final anchor =
  //   html.AnchorElement(href: url)
  //     ..setAttribute('download', logFileName)
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }

  static String? readStringFile(String path) {
    return null;
  }
}
