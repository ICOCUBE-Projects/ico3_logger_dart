
## 🧪 Post-Mortem Capture with LogProbeService

`LogProbeService` can be used to implement a powerful post-mortem capture mechanism with minimal setup.

The following example captures the last 50 log entries before a fatal condition occurs, then disables all outputs and exits the application:

```dart
  Log.enableFileOutput(
    exclusive: true,
    logFileName: 'fatal.txt',
);

Log.installService(
    service: LogProbeService(
    probeName: 'PostMortem',
    onEndRepeat: (id) {
        Log.disableAllOutputs();
        LogIO.exitApplication();
    },
    probeController: FatalTrigger(),
    preSize: 50));
```

The logger host will automatically:
- Flush all pending data
- Close files cleanly
- Export logs in the desired format (TXT, CSV, or JSON)

This makes post-mortem capture effortless, especially in production or embedded environments where real-time debugging is not possible.

> Tip: You can also persist captured logs to disk or send them remotely depending on your logger configuration.
