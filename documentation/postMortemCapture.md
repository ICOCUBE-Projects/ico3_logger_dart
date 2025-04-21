
## 🧪 Post-Mortem Capture with LogProbeService

`LogProbeService` can be used to implement a powerful post-mortem capture mechanism with minimal setup.

The following example captures the last 50 log entries before a fatal condition occurs, then disables all outputs and exits the application:

```dart
Log.installService(
  service: LogProbeService(
    probeName: 'postmortem',
    onEndRepeat: (id) {
      Log.disableAllOutputs();
      LogPrint.print('Post-mortem capture triggered. ID: $id');
      exit(0);
    },
    probeController: FatalTrigger(), // triggers on critical conditions
    preSize: 50,    // logs before the event
    postSize: 0,    // no logs after
    repeat: 1,      // single trigger
    triggerCount: 1 // only one event needed to activate
  )
);
```

The logger host will automatically:
- Flush all pending data
- Close files cleanly
- Export logs in the desired format (TXT, CSV, or JSON)

This makes post-mortem capture effortless, especially in production or embedded environments where real-time debugging is not possible.

> Tip: You can also persist captured logs to disk or send them remotely depending on your logger configuration.
