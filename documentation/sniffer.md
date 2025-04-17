# 🧪 SnifferLogService

The `SnifferLogService` allows you to **capture log messages** around a specific event or pattern, using memory buffers that collect logs **before** and **after** the trigger.

Inspired by protocol analyzers and logic sniffers, this is ideal for debugging or monitoring **critical sequences**.

---

## 🚀 Usage

```dart
Log.installService(
  service: SnifferLogService(
    trigger: LogMessageTrigger(
      level: LogLevel.critical,
      category: 'testLog',
      message: 'log F',
    ),
    preSize: 10,
    postSize: 5,
    triggerCount: 1,
  ),
);
```

This configuration will:

- Monitor logs until a fatal message containing `"log F"` appears in the `"testLog"` category.
- Buffer **10 messages before** and **5 messages after** the trigger.
- Activate once (`triggerCount: 1`).

---

## 📦 Constructor

```dart
SnifferLogService({
  required this.trigger,
  this.preSize = 0,
  this.postSize = 0,
  this.triggerCount = 1,
});
```

| Parameter       | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `trigger`       | A class extending `SnifferTrigger` that defines the capture condition.     |
| `preSize`       | Number of log messages to buffer **before** the trigger.                   |
| `postSize`      | Number of log messages to capture **after** the trigger.                   |
| `triggerCount`  | Number of times the trigger must occur before activation.                  |

---

## 🔍 Example Output

```
            [warning] (testLog) -->  log n°: 49 test
            [warning] (testLog) -->  log n°: 50 test
            [warning] (testLog) -->  log n°: 51 test
            [warning] (testLog) -->  log n°: 52 test
            [warning] (testLog) -->  log n°: 53 test
            [warning] (testLog) -->  log n°: 54 test
            [warning] (testLog) -->  log n°: 55 test
-TRIGGER-🔥 [fatal] (testLog) -->  log Fatal test
            [warning] (testLog) -->  log bis n°: 0 test
            [warning] (testLog) -->  log bis n°: 1 test
            [warning] (testLog) -->  log bis n°: 2 test
            [warning] (testLog) -->  log bis n°: 3 test
            [warning] (testLog) -->  log bis n°: 4 test
```

---

## 🎯 Built-in Trigger: `LogMessageTrigger`

The default trigger provided is `LogMessageTrigger`, which reacts to matching log messages.

```dart
LogMessageTrigger({
  this.message = '',
  this.level = LogLevel.none,
  this.environment = '',
  this.category = '',
});
```

| Field         | Match Type                                           |
|---------------|------------------------------------------------------|
| `level`        | Triggers if `message.level >= level`                |
| `category`     | Triggers if `message.category == category`          |
| `environment`  | Triggers if `message.environment == environment`    |
| `message`      | Triggers if `message.text.contains(message)`        |

> ✅ All active (non-default) fields must match for the trigger to activate.  
> Inactive fields (left as default) are ignored.

---

## 🧩 Create Your Own Trigger

You can define your own triggering condition by extending the abstract class `SnifferTrigger`:

```dart
abstract class SnifferTrigger {
  bool trigMessage(LogMessage message);
}
```

If `trigMessage()` returns `true`, the sniffer activates.

### Example:

```dart
class ErrorAndUserTrigger extends SnifferTrigger {
  final String userId;
  ErrorAndUserTrigger(this.userId);

  @override
  bool trigMessage(LogMessage message) {
    return message.level == LogLevel.error &&
           message.text.contains(userId);
  }
}
```

---

## ⚡️ PostMortem Service: `LoggerPostFatalService`

If you only want to **capture logs before a fatal error**, use the simplified version:  
`LoggerPostFatalService`. It doesn't require an external trigger.

```dart
Log.installService(service: LoggerPostFatalService(size: 25));
```

This will automatically capture the last 25 log messages **before any fatal log**.  
It's the easiest way to get context around a crash.

---

## 🔗 See Also

- [LogService](./service.md)
- [processOutput](./processOutput.md)
- [Custom Log Messages](./customLogMessage.md)

---

The sniffer captures critical context in complex flows, empowering you to analyze and resolve issues effectively.

