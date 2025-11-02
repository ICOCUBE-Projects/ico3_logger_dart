import 'dart:convert';
import 'dart:io';

//  dart pub global activate --source path .
//  dart pub global activate ico3_logger
//  dart run ico3_logger:cliViewer 127.0.0.1:3854
//  logViewer 192.168.1.174:4222

void main(List<String> args) async {
  // Parsing des arguments
  String host = '127.0.0.1';
  int port = 4122;

  if (args.isNotEmpty) {
    if (args.length == 1 && int.tryParse(args[0]) != null) {
      port = int.parse(args[0]);
    } else if (args.length == 1 && args[0].contains(':')) {
      var parts = args[0].split(':');
      host = parts[0];
      port = int.parse(parts[1]);
    } else if (args.length == 2) {
      host = args[0];
      port = int.tryParse(args[1]) ?? port;
    }
  }

  print('📡 LoggerPrinter listening on ws://$host:$port');

  final server = await HttpServer.bind(host, port);
  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then((WebSocket ws) {
        print(
            '✅ Client connected from ${request.connectionInfo?.remoteAddress.address}');
        ws.listen(
          (data) {
            try {
              final jsonMsg = jsonDecode(data);
              final msg = jsonMsg['message'] ?? '';
              final color = jsonMsg['color'] ?? '';
              if (color is String && color.isNotEmpty) {
                stdout.writeln('$color$msg\x1B[0m');
              } else {
                stdout.writeln(msg);
              }
            } catch (e) {
              stdout.writeln('❌ Invalid data: $data');
            }
          },
          onError: (err) {
            stderr.writeln('⚠️ Socket error: $err');
          },
          onDone: () {
            print('⏹ Client disconnected');
          },
        );
      });
    } else {
      // Si quelqu’un tente un HTTP normal
      request.response
        ..statusCode = HttpStatus.forbidden
        ..write('WebSocket only')
        ..close();
    }
  }
}
