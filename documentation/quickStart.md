

## Getting Started with iCo3_Logger

iCo3_Logger is designed to be as simple as possible to integrate and use — just like a `print()`, but with **real logging power**.

### Quick Start

Add the import in your Dart or Flutter application:

```dart
import 'package:ico3_logger/ico3_logger.dart';
```

Then log messages right away — no setup required:

```dart
void main() {
  Log.info('', 'Hello World'); 
  Log.critical('core', 'Critical system failure', level: 'warning');
  Log.debug('core', 'core is Ok');
}
```

#### Console Output

Here's the output you’ll see in your console:

```
(Main) 2025-04-07 18:22:25.865717 <0> [info] Hello World
(Main) 2025-04-07 18:22:25.887659 <0> [critical] (core) --> Critical system failure
(Main) 2025-04-07 18:22:25.887659 <0> [debug] (core) --> core is Ok
```

At startup, the logger named **"Main"** is automatically created.  
It accepts all log messages and displays them on the console **without any configuration**.

---

### Default Behavior at Startup

By default, iCo3_Logger automatically executes the following configuration for the main logger:

```dart
Log.setCategories('all');
Log.enableConsole(true);
```

You can customize this behavior at any time to suit your needs.

---
