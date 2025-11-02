import 'dart:async';
import 'dart:io';
import 'dart:convert';

class ViewerCommunication {
  final String address;
  final WebSocket socket;
  String status = 'isRunning';
  void Function(dynamic)? onReceive;
  void Function(String)? onError;

  bool get isRunning => status == 'isRunning';
  bool get isDone => status == 'isDone';
  bool get isClosing => status == 'isClosing';

  ViewerCommunication._(this.address, this.socket) {
    socket.listen(receiveData, onError: handleError, onDone: handleDone);
  }

  static Future<ViewerCommunication?> create(String address) async {
    try {
      var socket = await WebSocket.connect(address); // 'ws://localhost:8080');
      return ViewerCommunication._(address, socket);
    } catch (e) {
      return null;
    }
  }

  void print(Object? obj, String? color) {
    if (isRunning) {
      sendData(jsonEncode({'message': '$obj', 'color': color}));
    }
  }

  void receiveData(dynamic data) {
    onReceive?.call(data);
  }

  void sendData(String data) {
    if (isRunning) {
      socket.add(data);
    }
  }

  void handleError(dynamic err) {
    onError?.call('error on listen $err');
  }

  void handleDone() {
    status = 'isDone';
  }

  void close() {
    status = 'isClosing';
    socket.close().then((_) {
      status = 'isDone';
    });
  }
}
