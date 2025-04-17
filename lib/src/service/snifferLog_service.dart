import 'package:ico3_logger/ico3_logger.dart';

class SnifferLogService extends LogService{

  SnifferLogService({required this.trigger, this.preSize = 0, this.postSize = 0, this.triggerCount = 1}){
    preLogList = List<LogMessage?>.filled(preSize, null);
    postLogList = List<LogMessage?>.filled(postSize, null);
  }
  late final List<LogMessage?> preLogList;
  late final List<LogMessage?> postLogList;

  SnifferTrigger trigger;
  int preSize;
  int postSize;
  int triggerCount;

  int preLogPointer = 0;
  int postLogPointer = 0;
  int triggerIndex = 0;

  bool completed = false;

  @override
  LogError receiveLog(LogMessage message) {
    if(completed){
      return LogError(-1, message:  'Sniffer Completed');
    }
    if(triggerIndex < triggerCount) {
      _addPreLoadMessage(message);
      message.serviceTag = '            ';
      if(trigger.trigMessage(message)){
        message.serviceTag = '-TRIGGER-🔥 ';
        triggerIndex++;
      }
    } else {
      _addPostLoadMessage(message);
      message.serviceTag = '            ';
      if(postLogPointer == 0){
        completed = true;
        _processSnifferMessage();
      }
    }
    return LogError(0);
  }

  _addPreLoadMessage(LogMessage message) {
    preLogList[preLogPointer] = message;
    preLogPointer = (preLogPointer + 1) % preSize;
  }
  _addPostLoadMessage(LogMessage message) {
    postLogList[postLogPointer] = message;
    postLogPointer = (postLogPointer + 1) % postSize;
  }

  _processSnifferMessage() {
    if (masterLogger != null) {
      for (var msg in _getPreMessageList()) {
        masterLogger!.postProcessServiceLogMessage(msg);
      }
      for (var msg in _getPostMessageList()) {
        masterLogger!.postProcessServiceLogMessage(msg);
      }
    }
  }


  List<LogMessage> _getPreMessageList() {
    List<LogMessage> listMessage = [];
    var ptrLog = preLogPointer;
    do {
      var lg = preLogList[ptrLog];
      if (lg != null) {
        listMessage.add(lg);
      }
      ptrLog = (ptrLog + 1) % preSize;
    } while (ptrLog != preLogPointer);
    return listMessage;
  }

  List<LogMessage> _getPostMessageList() {
    List<LogMessage> listMessage = [];
    var ptrLog = postLogPointer;
    do {
      var lg = postLogList[ptrLog];
      if (lg != null) {
        listMessage.add(lg);
      }
      ptrLog = (ptrLog + 1) % postSize;
    } while (ptrLog != postLogPointer);
    return listMessage;
  }


}

abstract class SnifferTrigger {
  bool trigMessage(LogMessage message);
}

class FatalTrigger extends SnifferTrigger{
  @override
  bool trigMessage(LogMessage message){
    return message.level == LogLevel.fatal;
  }
}

class LogMessageTrigger extends SnifferTrigger {
  final String message;
  final LogLevel level;
  final String environment;
  final String category;

  LogMessageTrigger({
    this.message = '',
    this.level = LogLevel.none,
    this.environment = '',
    this.category = '',
  });

  @override
  bool trigMessage(LogMessage msg) {

    if (level != LogLevel.none && msg.level.index < level.index) {
      return false;
    }

    // Vérifie environment si défini
    if (environment.isNotEmpty && msg.environment != environment) {
      return false;
    }

    // Vérifie category si défini
    if (category.isNotEmpty && msg.category != category) {
      return false;
    }

    // Vérifie message si défini (doit être contenu dans le message log)
    if (message.isNotEmpty && !msg.message.contains(message)) {
      return false;
    }

    return true;
  }

  @override
  String toString() {
    return 'MessageTrigger('
        'message: "$message", '
        'level: $level, '
        'environment: "$environment", '
        'category: "$category"'
        ')';
  }
}




