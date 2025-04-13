
## Storage Mode

### Overview

`StorageMode` allows you to **temporarily store all log messages in memory** for later processing.

This is useful when:
- You want to delay output until after a critical process completes.
- You need to inspect logs programmatically.
- You plan to export logs conditionally (e.g., only on error).

It works in **two phases**:  
**1. Acquisition → 2. Processing**

---

### Quick Example

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  // Start capturing logs into memory
  Log.enableStorageOutput(exclusive: true);

  // Generate logs
  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok ');
  Log.warning('core', 'warning system');
  Log.error('core', 'Error system failure 2');
  Log.critical('core', 'Critical system failure');

  // Stop capturing
  Log.disableStorageOutput();

  // Option 1: Print stored logs to console
  Log.printMessageList();

  // Option 2: Save logs to a file
  Log.saveMessageList(logFileName: 'mem.csv', format: SaveFormat.csv);

  // Option 3: Custom processing
  Log.processMessageList(onLogMessage: (msg) {
    print('--> $msg');
  });
}
```

---

### Starting and Stopping

#### Start acquisition

```dart
Log.enableStorageOutput(exclusive: true);
```

- The `exclusive` flag is optional and disables other outputs while active.

### Stop acquisition

```dart
Log.disableStorageOutput();
```

---

###  Processing Stored Logs

You can process the stored log messages in **three ways**:

#### 1. Print to Console

```dart
Log.printMessageList(clear: true);
```

- `clear: true` will **clear memory after printing**.

#### 2. Save to File

```dart
Log.saveMessageList(
  logFileName: 'mem.csv',
  format: SaveFormat.csv,
  clear: true
);
```

- Supported formats: `.text`, `.csv`, `.json`

#### 3. Process with Custom Function

```dart
Log.processMessageList(
  onLogMessage: (msg) => print('Custom: $msg'),
  clear: true
);
```

---

### Accessing Stored Logs Directly

If needed, you can get the raw list and manipulate it yourself:

```dart
var logList = Log.getMessageList(); // Returns List<LogMessage>
logList.clear(); // Manually clears stored logs
```
Or clear MessageList

```dart
Log.clearMessageList(); // Returns List<LogMessage>
```

---

### API Reference

```dart
static LogError printMessageList({String logger = 'Main', bool clear = false});

static LogError saveMessageList({
  required String logFileName,
  String logger = 'Main',
  bool append = false,
  SaveFormat format = SaveFormat.text,
  bool clear = false
});

static LogError processMessageList({
  String logger = 'Main',
  Function(LogMessage message)? onLogMessage,
  bool clear = false
});

static List<LogMessage> getMessageList({String logger = 'Main'});

static LogError clearMessageList({String logger = 'Main'}) 

```

---

### Ideal For

- Capturing logs during a test or setup phase
- Exporting logs only when a specific condition is met
- Logging for offline or embedded systems where output is deferred
- Batch processing or analysis tools
