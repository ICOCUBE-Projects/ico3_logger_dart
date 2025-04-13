
## Custom Log Messages – Advanced Use Case

iCo3_Logger allows you to extend the default logging behavior by subclassing the `LogMessage` class. This approach provides a flexible and powerful way to include additional contextual information (such as user data, session IDs, device info, etc.) directly within the log stream — without needing to create custom logger implementations.

> ⚠️ **Note**: Creating custom logger types is not supported in iCo3_Logger. Instead, customizing log messages via `LogMessage` subclasses is the recommended and safe approach.

---

### Why use custom log messages?

Imagine you want to include user-related metadata like user ID or username in every log. With a custom class extending `LogMessage`, you can enrich your logs and even tailor your output logic when using `enableProcessOutput`.

---

### Example: `UserLogMessage` with additional fields

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  // Custom output logic using enableProcessOutput
  Log.enableProcessOutput(
    logger: 'Main',
    onLogMessage: (log) {
      if (log is UserLogMessage) {
        LogIO.print("User Activity Log -> ${log.userName} (${log.userId}): ${log.message}");
      } else {
        LogIO.print(log.toString());
      }
    },
  );

  // Processing custom messages
  Log.processLogMessage(UserLogMessage(
    message: "User logged in",
    userId: "12345",
    userName: "John Doe",
    level: LogLevel.info,
    category: "Auth",
    environment: "Production",
  ));
}
```

---

### Implementation of `UserLogMessage`

```dart
class UserLogMessage extends LogMessage {
  UserLogMessage({
    required super.message,
    required this.userId,
    required this.userName,
    super.level = LogLevel.none,
    super.environment = '',
    super.category = '',
  });

  final String userId;
  final String userName;

  @override
  String getJsonString(bool first) {
    final Map<String, dynamic> data = {
      'level': level.toString().split('.').last,
      'category': category,
      'message': message,
      'environment': environment,
      'timeStamp': timeStamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'timeLine': timeLine,
      'userId': userId,
      'userName': userName,
    };
    return first ? jsonEncode(data) : ',\n${jsonEncode(data)}';
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

  @override
  String toString() {
    return '${timeStamp?.toIso8601String() ?? DateTime.now().toIso8601String()} <$timeLine> '
           '[${level.name}] ($category) $environment --> $message '
           '(User: $userName, ID: $userId)';
  }

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
      ..timeStamp = timeStamp
      ..timeLine = timeLine;
  }
}
```

---

### Summary

- ✅ Custom log messages let you inject structured and meaningful data into your logs.
- ✅ They fully integrate with the logging pipeline, including filters and process outputs.
- ✅ This is the preferred way to extend logging capabilities without altering the logger system.

---
