
## Process Output

### Made Simple

Need full control over every log message?  
**`ProcessOutput`** lets you intercept and handle logs however you like — in real time.

Enable it in one line:

```dart
Log.enableProcessOutput(onLogMessage: (log) {
  print('-->> $log');
});
```

Want it to be the only output? Add `exclusive: true` to disable all other outputs:

```dart
Log.enableProcessOutput(exclusive: true, onLogMessage: (log) {
  // Custom logic
});
```

To stop processing:

```dart
Log.disableProcessOutput();
```

---

### Why Use It?

- ✅ Capture and process logs in real time
- ✅ Route logs to your own storage, server, UI, etc.
- ✅ Completely decoupled from console or file output
- ✅ Great for unit testing, monitoring, or custom log dashboards
- ✅ **Foundation for extending the logger itself**

---

### Extend the Logger

The `ProcessOutput` feature is **the core mechanism for customizing log handling** in `ico3_logger`.

You can use it to:

- Build real-time monitoring tools
- Filter or reformat logs before storage
- Connect the logger to external systems (APIs, databases, messaging queues…)
- Or even inject logs into your in-app UI

> **Used internally**: The `postMortemExtension` module is entirely built on top of `ProcessOutput`, showing how powerful and flexible this feature is for advanced use cases.

---

### Full Example 1: External Handler Function

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableProcessOutput(exclusive: true, onLogMessage: processLog);

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system');
  Log.error('core', 'Error system failure 2');
  Log.critical('core', 'Critical system failure');

  Log.disableProcessOutput();
}

void processLog(LogMessage message) {
  print('-->> $message');
}
```

---

### Full Example 2: Inline Function

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableProcessOutput(exclusive: true, onLogMessage: (log) {
    print('-->> $log');
  });

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system');
  Log.error('core', 'Error system failure 2');
  Log.critical('core', 'Critical system failure');

  Log.disableProcessOutput();
}
```

---

### LogMessage Structure

The `LogMessage` object gives you access to the full metadata of each log:

```dart
class LogMessage {
  String category;
  String environment;
  bool isDated;
  LogLevel level;
  String message;
  int timeLine;
  TimeDate timeStamp;
}
```

You can filter, transform, send, store, or analyze logs using any of these fields.

---

### 🔌 Example: `postMortemExtension`

This real-world extension is built entirely using `ProcessOutput`.  
It buffers recent logs and saves them in a file **only if a fatal/critical log is encountered**, for post-mortem analysis. It can also **auto-exit** the app if needed.

```dart
Log.enableProcessOutput(
  exclusive: true,
  onLogMessage: LoggerPostFatalExtension(
    size: 25,
    fileName: 'fatal.csv',
    format: SaveFormat.csv,
    autoExit: true
  ).processMessage
);
```

**Features of this extension**:

- Stores last `n` log messages in memory
- Detects `fatal` or `critical` logs
- Automatically saves to file (`.csv`, `.json`, or `.txt`)
- Can exit app after saving, if `autoExit` is true

> Want to build your own extensions? Just plug into `onLogMessage` and make the logger yours.

---

