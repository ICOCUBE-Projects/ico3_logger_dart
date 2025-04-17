import 'dart:convert';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  final log = UserLogMessage(
    message: "User logged in",
    userId: "54321",
    userName: "Jane Doe",
    level: LogLevel.info,
    category: "Auth",
    environment: "Production",
  );
  Log.processLogMessage(log);

  Log.processLogMessage(UserLogMessage(
    message: "User logged in",
    userId: "12345",
    userName: "John Doe",
    level: LogLevel.info,
    category: "Auth",
    environment: "Production",
  ));
}

class UserLogMessage extends LogMessage {
  UserLogMessage({
    required super.message,
    required this.userId,
    required this.userName,
    super.level = LogLevel.none,
    super.environment = '',
    super.category = '',
  });

  final String userId; // User identifier
  final String userName; // User name

  // Override getJsonString to include the new properties
  @override
  String getJsonString(bool first) {
    final Map<String, dynamic> data = {
      'level': level.toString().split('.').last,
      'category': category,
      'message': message,
      'environment': environment,
      'timeStamp':
          timeStamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'timeLine': timeLine,
      'userId': userId, // Add custom field
      'userName': userName, // Add custom field
    };
    if (!first) {
      return ',\n${jsonEncode(data)}';
    }
    return jsonEncode(data);
  }

  @override
  String getStringMessageForLogger(
      bool withCategory, bool envActive, bool withTimeLine) {
    isDated = true;
    return [
      if (isDated) LogUtilities.getTimeStampedString(),
      if (withTimeLine) '<$timeLine>',
      if (level != LogLevel.none) '[${level.name.toUpperCase()}]',
      if (envActive && environment.isNotEmpty) '$environment ##',
      if (withCategory) '($category)',
      '--> $message',
      '(User: $userName, ID: $userId)'
    ].join(' ');
  }

  // Override toString to display user info
  @override
  String toString() {
    return '${timeStamp?.toIso8601String() ?? DateTime.now().toIso8601String()} <$timeLine> [${level.name}] ($category) $environment --> $message (User: $userName, ID: $userId)';
  }

  // Override clone to copy custom fields
  @override
  UserLogMessage clone() {
    return UserLogMessage(
      message: message,
      userId: userId,
      userName: userName,
      level: level,
      environment: environment,
      category: category,
    )
      ..serviceTag = serviceTag
      ..timeStamp = timeStamp
      ..timeLine = timeLine;
  }
}
