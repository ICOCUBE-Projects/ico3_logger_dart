
## Critical Mode

`criticalMode` is a high-performance logging mode designed to handle bursts of logs with minimal overhead. It is particularly useful in performance-critical sections where only logging is needed and no other operations should interfere.

---

### What It Does

- Creates a **dedicated log buffer** for fast, isolated logging.
- Avoids any output processing (file, console, etc.) until the buffer is flushed.
- Allows fixed-size or growable buffer allocation.
- When exiting, the logs are dispatched for processing and optionally summarized.

---

### Example Usage

```dart
Log.log('test', 'Start critical mode ', level: 'info');

// Enter critical mode with a buffer size of 50
Log.enterCriticalMode(size: 50);

Log.log('network', 'Request sent 1', level: 'info');
Log.log('database', 'Query executed 1', level: 'warning');
// ...
Log.log('network', 'Request sent B3', level: 'info');
Log.log('database', 'Query executed B3', level: 'warning');

// Exit critical mode and log metrics
Log.exitCriticalMode();
```

---

### What Happens Under the Hood

- During `criticalMode`, logs are written directly to a pre-allocated buffer.
- No log output or formatting is performed.
- Once `exitCriticalMode()` is called:
    - Logs are flushed to the active loggers (console, file, etc.).
    - If `report` is set, a summary is logged, including:
        - Duration
        - Number of logs
        - Average time between logs

---

### API Reference

```dart
// Start critical mode with optional size and growable flag
Log.enterCriticalMode({int size = 10, bool growable = true});

// Exit and optionally report stats as a log
Log.exitCriticalMode();
```

---

### Example Output

```
(Main) ... [info] (test) --> Start critical mode 
(Main) ... [info] (network) --> Request sent 1
(Main) ... [warning] (database) --> Query executed 1
(Main) ... [info] (network) --> Request sent 2
...
(Main) ... [critical] (test) --> end of critical mode 
duration: 5 µs  Logs: 18  average time between log: 0.28 µs 
```

---

### Rules During Critical Mode

- Only logging operations are allowed.
- No output is performed until `exitCriticalMode()`.
- Avoid starting other outputs while in this mode.

