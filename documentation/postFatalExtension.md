
##  Extension: `LoggerPostFatalExtension`

### Overview

`LoggerPostFatalExtension` is a plug-and-play log handler that **automatically captures recent logs and saves them to a file when a fatal error occurs**.

It’s the perfect tool for **post-mortem debugging**, especially when your app crashes or must shut down.

> Built on top of [`Log.enableProcessOutput`](#⚙️-process-output), this extension shows how easily you can extend the logger with custom logic.

---

### Features

- **Circular log buffer** to store the last N messages
- Automatically saves logs on `fatal` events
- Supports saving in `.txt`, `.csv`, or `.json`
- Can auto-exit the app after saving
- Easily integrated with `onLogMessage`

---

### How to Use

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableProcessOutput(
    exclusive: true,
    onLogMessage: LoggerPostFatalExtension(
      size: 25,                        // Buffer size
      fileName: 'fatal.csv',          // Output file name
      format: SaveFormat.csv,         // File format
      autoExit: true                  // Auto-exit app after fatal
    ).processMessage
  );

  // Generate sample logs
  for (int i = 0; i < 56; i++) {
    Log.log('testLog', ' log n°: $i test', level: 'warning');
  }

  // Trigger fatal error
  Log.log('testLog', ' log Fatal test', level: 'fatal');
}
```

---

### How It Works

- Every log message is stored in a **fixed-size circular buffer**.
- When a log with level `fatal` is detected:
    1. The buffer is flushed to a file.
    2. The app exits immediately (if `autoExit` is enabled).

---

### Parameters

| Parameter   | Type         | Description                                                                 |
|-------------|--------------|-----------------------------------------------------------------------------|
| `size`      | `int`        | Number of messages to retain in memory (default: `10`)                      |
| `fileName`  | `String`     | Name of the file to save logs into (default: `'fatal.txt'`)                 |
| `format`    | `SaveFormat` | Output format: `.text`, `.csv`, `.json`                                     |
| `autoExit`  | `bool`       | Exit app after saving the logs (default: `true`) not available on navigator |

---

### Output Example (CSV)

```csv
timestamp,level,category,message
2025-04-08T14:33:22.173Z,warning,testLog,log n°: 53 test
2025-04-08T14:33:22.174Z,fatal,testLog,log Fatal test
```

---

### Perfect For

- Production systems where crashes must leave a trace
- Debugging rare or intermittent issues
- Headless apps where console logs are not persisted
- Flutter apps in release mode where visibility is limited

---

### Note

This extension **replaces the default output** when `exclusive: true` is used.  
You are free to combine this with other logging mechanisms, or chain multiple loggers through your own logic if needed.

---

