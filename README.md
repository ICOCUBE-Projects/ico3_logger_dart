
<h1 align="center">iCo3_Logger</h1>
<h2 align="center">Dive in the Debug</h2>

# iCo3_Logger
**By [iCoCube](https://icocube.com)**

**Fast. Simple. Powerful.**  
Logging for Dart/Flutter devs who want **zero hassle** and **total control**: live filters, crash tracing, multi-loggers, and exportable logs.


[![pub package](https://img.shields.io/pub/v/ico3logger.svg?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/ico3logger)
![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)
![perf](https://img.shields.io/badge/speed-%3C0.1µs-green)
![Ultra-Fast Logger](https://img.shields.io/badge/ultra_fast_logger-%3C0.1µs-orange)
[![Website](https://img.shields.io/badge/Site-officiel-blue?logo=googlechrome)](https://icocube.com)


---

## ▶️ Get Started

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.info('', 'Hello World');
  Log.setDecoration(mode: 'emoji', timeLine: true, category: true);
  Log.debug('network', 'Connected 🚀');
  Log.installService(service: SnifferLogService(trigger: LogTrigger(level: 'critical')));
  Log.critical('core', 'Critical alert 🚨');
}
```

**Output:**
```text
[info] Hello World
<0> [🛠️debug] (network) --> Connected 🚀
<1> [🚨critical] (core) --> Critical alert
```

🧪 Install:
```bash
dart pub add ico3logger
```

---

## 📌  Why iCo3_Logger?

**iCo3_Logger** is built for real apps—**ultrafast**, **lightweight**, and **extensible**. Log effortlessly or dive deep with advanced features.

- As simple as `print()`, but smarter
- <0.1µs performance, minimal footprint
- Live filter by category/level
- Multi-loggers for parallel streams
- Export to **CSV** or **JSON**
- Custom services: sniffers, post-mortem, and more
- Emojis, timestamps, colors—your way
- Extensible for any project
- Optional remote CLI LogViewer for debugging. 

Find complete documentation and examples [here](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/README.md).


---



## ✴ Key Features

### ▶️ Log Instantly
```dart
Log.info('', 'Hello World');
```

### ➕ Add Context
```dart
Log.setDecoration(category: true, timeStamp: true);
Log.debug('network', 'Start connection');
```
```text
2025-04-16 10:30:45.123 [debug] (network) --> Start connection
```

### ✅ Filter Logs
```dart
Log.setCategories('<clear> core, ui(critical)');
Log.warning('ui', 'Minor issue'); // Skipped
Log.critical('ui', 'Major failure'); // Shown
```

### 🚀 Ultrafast Critical Mode
```dart
Log.enterCriticalMode(size: 50);
Log.critical('core', 'System down');
Log.exitCriticalMode();
```
*Runs with minimal footprint in timing-critical zones.*

### 📤 Export Logs
```dart
Log.enableFileOutput(logFileName: "log.csv", format: SaveFormat.csv);
```
```csv
timeStamp,level,category,message
2025-04-16T10:30:45.123,info,core,Running
```

### 🛠️ Custom Services
#### Log Probe
```dart
Log.installService(
  service: LogProbeService(
    probeController: probeController,
    preSize: 100,
    postSize: 25,
    triggerCount: 1));
```
*Analyze logs around trigger events (e.g., critical errors).*

#### Post-Mortem Logs
```dart
Log.installService(
    service: LogProbeService(
    onEndRepeat: (id) {
        Log.disableAllOutputs();
        LogIO.exitApplication();
        },
    probeController: FatalTrigger(),
    preSize: 25));

```
*Capture logs after fatal events for debugging.*

### ⏱️ Timeline (µs)
```dart
Log.startTimeLine();
Log.info('core', 'Processing');
Log.stopTimeLine();
```
*Track execution time in microseconds.*

### 🎨 Customize Output
```dart
Log.setDecoration(mode: 'emoji', timeStamp: true);
```
*Emojis: 🛠️ (debug), 🚀 (info), 🚨 (critical), ⚠️ (warning), 🔴 (error).*

### 🔗 Multi-Loggers
```dart
Log.createLogger('AppLogger', categories: '<clear> app, core');
```

### 🔋 In-Memory Logs
```dart
Log.enableStorageOutput();
Log.printMessageList();
```

### 🔧 YAML Setup
```dart
Log.loadContext('path');
```
```yaml
loggers:
  - id: "Main"
    categories: "<clear> core(warning), network"
    outputs:
      console: true
      file:
        path: "log.json"
        format: "json"
```

---

## 🧩 Extend It

Add custom services, outputs, or filters. **iCo3_Logger** adapts to your app’s needs.

---

---

## 🧰 Tools & Utilities

### 🖥️ CLIViewer — Real-time Log Monitor
`CLIViewer` is a lightweight command-line tool that lets you **watch your logs live** from any machine.

```bash
dart pub global activate ico3_logger
dart run ico3_logger:cliViewer <host:port>
```
Once connected, you’ll see your logs in real time:

```text
📡 LoggerPrinter listening on ws://192.168.1.174:4222
✅ Client connected from 192.168.1.174
[info] (test) --> message info
[warning] (test) --> message warning
```
Use case:
Connect your app remotely with:

```dart
Log.connectViewer(address: 'ws://192.168.1.174:4222');
```

No setup, no dashboard — just pure live feedback.


!📘[Learn more about CLIViewer](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/cliViewer.md)




## 📈 Support the Project

⭐ Star us on [GitHub](https://github.com/ICOCUBE-Projects/ico3_logger_dart)  
📥 Grab it on [pub.dev](https://pub.dev/packages/ico3logger)  
🧑‍💻 Contact us for advanced features

---

## 📚 Docs & Examples

📘 [Full Docs](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation)  
🧪 [Example Code](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/example/main.dart)

---

**Log smarter. Build faster.**  
— The iCo3 Team

