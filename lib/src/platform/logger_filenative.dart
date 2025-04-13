import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ico3_logger/ico3_logger.dart';

class LoggerFile extends LoggerFileBase {
  File? _logFile;
  RandomAccessFile? _fileSync;

  LoggerFile(
      {required super.append,
      required super.logFileName,
      super.flush = true,
      super.loggerID = '',
      super.format2File = SaveFormat.text}) {
    logStatus = LogStatus.running;
    _initLoggerFile();
  }

  void _initLoggerFile() {
    // bool append = false, required String logFilePath}
    try {
      String fullPath = path.isAbsolute(logFileName)
          ? logFileName
          : path.join(Directory.current.path, logFileName);
      _logFile = File(fullPath);
      if (_logFile!.existsSync()) {
        if (!append) {
          _logFile!.writeAsStringSync('');
        }
      }
      first = true;
      _fileSync =
          _logFile!.openSync(mode: append ? FileMode.append : FileMode.write);
      writeHeader();
    } catch (e) {
      LogUtilities.printDebug('Error on open Logger File: $e');
      logStatus = LogStatus.error;
    }
  }

  @override
  String getLoggerFullPath() {
    return _logFile?.path ?? '';
  }

  @override
  LogError writeStringSync(String data) {
    _fileSync?.writeStringSync(data);
    if (flush) {
      _fileSync?.flushSync();
    }
    first = false;
    return LogError(0);
  }

  @override
  closeFile() {
    writeFooter();
    logStatus = LogStatus.closing;
    _fileSync?.closeSync();
    logStatus = LogStatus.closed;
  }

  static String? readStringFile(String path) {
    final file = File(path);
    try {
      return file.readAsStringSync();
    } catch (ex) {
      return null;
    }
  }
}
