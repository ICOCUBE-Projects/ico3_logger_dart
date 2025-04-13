[![pub package](https://img.shields.io/pub/v/logger.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/ico3logger)
![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)
![perf](https://img.shields.io/badge/speed-ultra--fast-green)
![dart](https://img.shields.io/badge/platform-Dart-blue)
# iCo3_Logger

**iCo3_Logger** is a powerful, flexible logging library designed for Dart and Flutter developers. It provides advanced features such as **category-based filtering**, **multi-output logging**, **post-mortem debugging**, **in-memory storage**, and **timeline tracking**. Whether you're debugging during development or monitoring logs in production, **iCo3_Logger** has you covered.

## Why iCo3_Logger Exists
- Clear logs to see what’s important.
- Fast logging with no effort.
- Grows with your code, helps you understand.

When projects get bigger, logs become hard to control. Every time, debugging takes too long without the right tools at the start.

We faced this problem many times. As our projects grew, logs made work difficult. We added and removed print() statements for hours to find errors. Basic loggers were too simple, gave too many details, or did not work for big codebases.

We built iCo3_Logger to fix this. It makes logging clear, exact, and organized, with no extra effort.

Start logging with one line:

```dart
void main() {
  Log.warning("network", "Network initialization phase 1");
}
```

No setup. Logs show levels like warning or error. iCo3_Logger is as easy as print(). Need more control? Use one line to choose or group logs:

```dart
  Log.setCategories("clear, core(warning), network, core(error)");
```

From one line to advanced log systems, iCo3_Logger stays simple and works for big applications.

---

## Features

- **Easy to Start**: iCo3_Logger is as simple as `print()`. No setup required — just start logging with a single line of code. See [quickStart.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/quickStart.md#-quick-start).
- **Category-Based Logging**: Organize logs into categories (e.g., `network`, `database`) with customizable levels (`info`, `warning`, `critical`, etc.). Filter logs dynamically and configure externally at startup to focus on what matters. Learn more in [category.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/category.md#category-based-filtering-in-ico3logger) and [startup.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/startup.md#initializing-ico3logger-with-external-parameters).
- **Multi-loggers System**: Supports multiple loggers with unique processing strategies based on categories and levels. Explore this in [loggers.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/loggers.md#-multi-logger-support-in-ico3logger).
- **Multi-Output Support**: Send logs to multiple destinations with flexible control — console ([consoleOutput.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/consoleOutput.md#-console-output)), files (`.txt`, `.csv`, `.json`, with append/overwrite options) ([fileOutput.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/fileOutput.md#-file-output)), in-memory storage ([storageOutput.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/storageOutput.md#-storage-mode)), or custom callbacks ([processOutput.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/processOutput.md#-process-output)). Details in [outputs.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/outputs.md#-output-system--general-overview).
- **Post-Mortem Debugging**: Capture the last `N` logs before a fatal error and save them for analysis. Learn how in [postFatalExtension.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/postFatalExtension.md#-extension-loggerpostfatalextension).
- **Timeline Tracking**: Track log events with high precision, even in multithreaded or asynchronous environments. See [timeLine.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/timeLine.md#timeline-support).
- **Critical Mode**: Enable ultra-fast logging for performance-sensitive scenarios with minimal overhead. Details in [criticalMode.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/criticalMode.md#critical-mode).
- **Custom Log Messages**: Extend log message structures with enriched, user-defined fields for advanced processing. See [customLogMessage.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/customLogMessage.md#custom-log-messages--advanced-use-case).
- **Fully Synchronous Execution**: iCo3_Logger is 100% synchronous, ensuring stable and predictable execution, and is compatible with both synchronous and asynchronous applications without unnecessary overhead.

---

## Why Choose iCo3_Logger?

| Feature                    | Benefit                                  |
|---------------------------|------------------------------------------|
| No setup                  | Start logging instantly                  |
| Category filtering        | Focus on what matters                    |
| Multi-output              | Log to console, file, memory, callback   |
| High performance          | Logging in microseconds                  |

Whether you're working on a solo project or part of a team, **iCo3_Logger** scales with your needs — without the bloat or complexity of traditional logging systems.

---

## Getting Started

### Installation

To use **iCo3_Logger**, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  ico3logger: ^1.0.0
```

Then, run `pub get` to install the package.

### Basic Usage

Starting with **iCo3_Logger** is easy — no configuration is needed.  
To log messages, use the following syntax:

```dart
Log.info('core', 'Information message');
Log.warning('network', 'Warning: Network issue');
Log.error('core', 'Error: Something went wrong');
```

To filter logs by category and level:

```dart
Log.setCategories("<clear>, core(warning), network, core(error)");
```

This will display only warnings and errors from the `core` category, and all logs from the `network` category. For more, see [quickStart.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/quickStart.md#getting-started-with-ico3logger).

---

### Benchmarking iCo3_Logger

**iCo3_Logger** excels in performance: CriticalMode logs in ~0.08 µs (AOT), in-memory storage averages ~0.28 µs, and file output (no flush) achieves ~30 µs. Redirected console output in AOT reaches ~17 µs for efficient logging. See the full report and test code in [benchMark.md](https://github.com/ICOCUBE-Projects/ico3_logger_dart/blob/master/documentation/benchMark.md#-performance-benchmarks).

### About iCoCube

**iCo3_Logger** is developed by **iCoCube**, an initiative focused on **interoperability**, **cybersecurity**, and the **Internet of Things (IoT)**.

This logger is part of a series of standalone tools built to support robust development workflows. It will soon be available for other languages including:

- **Python** (`ico3Logger_python`)
- **JavaScript** (`ico3Logger_js`)
- **Java** (`ico3Logger_java`)
- **C#** (`ico3Logger_csharp`)

Learn more at [**icocube.com**](https://icocube.com)

---

### Contributing

We’re grateful for your interest in contributing! Here’s how you can help:

- **Use & Test**: Try iCo3_Logger, share feedback, and report bugs with a reproducible test case for quick fixes.
- **Create Extensions**: Build extensions to enhance functionality. We’ll support you as needed.
- **Core Contributions**: Want to improve the core? Please contact us first to discuss and align with our goals for consistency across Python, JavaScript, Java, and C#. We want to ensure collaboration before any changes are made. Pull requests require prior approval.

---

## License

This project is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for details.

---

