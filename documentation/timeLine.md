
## TimeLine Support

The `timeLine` system in **ico3_logger.dart** allows you to measure and track relative time for each log message in microseconds, based on a starting reference point. This is extremely useful when benchmarking log performance or analyzing time-sensitive sequences.

---

### What it does

- `Log.startTimeLine()` captures the reference start time.
- Each log message stores its own relative timestamp (in microseconds) in the `timeLine` field.
- `Log.stopTimeLine()` stops time tracking and prevents further updates to `timeLine`.
- These values are included in log storage and can be printed, saved, or processed later.

---

### Example Usage

```dart
import 'dart:developer';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.enableStorageOutput(exclusive: true);

  // Start the timeline reference point
  Log.startTimeLine();

  var start = Timeline.now;
  for (int j = 0; j < 10; j++) {
    start = Timeline.now;
    for (int i = 0; i < 100; i++) {
      Log.critical('core', 'Critical system failure');
    }
  }
  var stop = Timeline.now;

  // Stop measuring relative log times
  Log.stopTimeLine();

  var totalTimeUs = stop - start;
  var averageTimeUs = totalTimeUs / 100;

  // Print all logs with their relative timeLine values
  Log.printMessageList();

  // Log benchmark results
  Log.enableConsoleOutput(exclusive: true);
  Log.info('', 'Test storage speed time for 100 logs: ${totalTimeUs} µs, '
      'average time per log = ${averageTimeUs.toStringAsFixed(2)} µs');
}
```

---

### Key Points

- `timeLine` values are automatically included in `LogMessage`.
- The timeline is measured in **microseconds** for precision.
- Perfect for identifying performance bottlenecks, microbenchmarking, or verifying logger overhead.

---

### API Summary

```dart
// Starts a relative timeline. All following logs store time offset from now.
Log.startTimeLine();

// Stops the timeline. Further logs will no longer update the timeLine field.
Log.stopTimeLine();

// The timeLine value is part of the LogMessage object:
LogMessage.timeLine
```
---
