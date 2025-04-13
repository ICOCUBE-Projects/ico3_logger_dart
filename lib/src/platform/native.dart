import 'dart:io';
import 'dart:core' as core;

class LogIO {
  static print(core.Object? data) {
    core.print(data);
    // if (Platform.isAndroid || Platform.isIOS) {
    //   core.print('$data');
    // } else {
    //   stdout.writeln('$data');
    // }
  }

  static coloredPrint(core.Object? data, core.String color) {
    LogIO.print('$color$data\x1B[0m');
  }

  static core.String get endOfColor => '\x1B[0m';
  static core.String get highLight => '\x1B[97m';

  static exitApplication() {
    exit(-1);
  }
}
