

## Initializing iCo3_Logger with External Parameters

iCo3_Logger can be initialized dynamically using external inputs, allowing flexible and adaptive configuration across environments. There are two main options:

---

### 1. Using Command-Line Arguments

You can define logging categories at runtime by parsing command-line arguments.

#### Dart Code Example

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main(List<String> arguments) {
  for (final arg in arguments) {
    if (arg.startsWith('categories=')) {
      Log.setCategories(arg.substring('categories='.length));
    }
  }

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok');
  Log.warning('core', 'warning system'); // Processed
  Log.error('core', 'Error system failure 2'); // Processed
  Log.critical('core', 'Critical system failure');
}
```

#### Example CLI Execution

```bash
app2Log categories="<clear> core(warning), network"
```

This will configure the default logger to only include:
- `core` with level warning or higher,
- all levels from `network`.

---

### 2. Using a YAML Context File

For more advanced configurations, you can use a YAML context file to define multiple loggers, their categories, output types, and decoration styles.

The filename is fully customizable (e.g., `context.yaml`, `config_log.yaml`, `prod_logs.yaml`, etc.).

#### Example YAML File

```yaml
loggers:
  - id: "Main"
    categories: "<clear> core(warning), network"
    outputs:
      console: true
      file:
        path: "log.json"
        format: "json"
        append: true

  - id: "log1"
    categories: "<clear> all(warning), -ui(warning), -core(warning)"
    outputs:
      console: true
      storage: true
    decoration:
      mode: 'full'
      colorPanel: |
        {
          "levelColors": {
            "info": "\\u001B[97m",
            "debug": "dark",
            "warning": "standard",
            "error": "dark",
            "critical": "standard",
            "fatal": "whiteOnBlue"
          }
        }

  - id: "log2"
    categories: "<clear> all"
    outputs:
      process:
        function: "printMessage"
```

---

#### Important: Declaring `processMap` for `processOutput`

To use `outputs > process > function` in YAML, you must declare a function map in Dart that links function names (used in the YAML) to actual Dart functions.

This map is **mandatory** for `processOutput` to work.

```dart
Map<String, Function(LogMessage message)> processMap = {
  'printMessage': (message) => print('-->>$message'),
  'sendMessage': processNetwork,
  'print': print,
};
```

Each key (e.g. `"printMessage"`) corresponds to the value used in the YAML under `outputs > process > function`.

---

### Dart Code Example Using Context File

Here are two versions: a **compact one** and a **clearer, more explicit one**.

#### Option A – Compact

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main(List<String> arguments) {
  String? contextFileArgument;

  for (final arg in arguments) {
    if (arg.startsWith('context=')) {
      contextFileArgument = arg.substring('context='.length);
      Log.loadContext(contextFileArgument, processMap: {
        'printMessage': (message) => print('-->>$message'),
        'sendMessage': processNetwork,
        'print': print,
      });
    }
  }

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok');
  Log.warning('core', 'warning system');
  Log.error('core', 'Error system failure 2');
  Log.critical('core', 'Critical system failure');
}

void processNetwork(LogMessage message) {
  // Your logic here
}
```

---

#### Option B – Explicit

```dart
import 'package:ico3_logger/ico3_logger.dart';

void processNetwork(LogMessage message) {
  // Your custom logic here
}

Map<String, Function(LogMessage message)> processMap = {
  'printMessage': (message) => print('-->>$message'),
  'sendMessage': processNetwork,
  'print': print,
};

void main(List<String> arguments) {
  String? contextFileArgument;

  for (final arg in arguments) {
    if (arg.startsWith('context=')) {
      contextFileArgument = arg.substring('context='.length);
      Log.loadContext(contextFileArgument, processMap: processMap);
    }
  }

  Log.info('', 'Hello World');
  Log.debug('core', 'core is Ok');
  Log.warning('core', 'warning system');
  Log.error('core', 'Error system failure 2');
  Log.critical('core', 'Critical system failure');
}
```

---

#### Run Example

```bash
app2Log context=config.yaml
```

Replace `config.yaml` with any context file you want.

---

### Summary

| Method              | Command-Line                                | YAML Context File                      |
|---------------------|---------------------------------------------|----------------------------------------|
| Use case            | Simple category selection for 'Main' Logger | Multi-logger setup, file/process config |
| File required       | No                                          | Yes (any name: `config.yaml`, etc.)    |
| Supports decoration | ❌                                           | ✅                                     |
| Supports process    | ❌                                           | ✅ (with `processMap`)                 |

Using these initialization approaches allows you to:
- Decouple configuration from code,
- Rapidly switch between environments,
- Maintain cleaner and more flexible project setups.

---
