
## File Output

### Made Simple

Want to save your logs to a file? It’s as simple as one line:

```dart
Log.enableFileOutput(logFileName: 'log.txt');  
// Save logs in plain text (default)

Log.enableFileOutput(logFileName: 'log.csv', format: SaveFormat.csv);
// Save logs in CSV format (good for Excel)

Log.enableFileOutput(logFileName: 'log.json', format: SaveFormat.json);
// Save logs in structured JSON
```

- Use `exclusive: true` to close all other outputs automatically.
- Use `append: true` to continue writing to an existing file (only for native environments).
- Use `Log.disableFileOutput()` to close the file explicitly.
- In web (browser), closing the file will automatically trigger a download.

To inspect the current file output (and its format):

```dart
var file = Log.getOutputFileActive();
```

---

### Full Reference

```dart
static LogError enableFileOutput({
  String logger = 'Main',
  bool exclusive = false,
  String? logFileName,
  bool append = false,
  SaveFormat format = SaveFormat.text,
});
```

- `logger`: Logger ID (default is `'Main'`)
- `exclusive`: If `true`, disables all other outputs (false default)
- `logFileName`: Name of the log file (required)
- `append`: If `true`, appends to existing file (ignored in browser) (false default)
- `format`: Log file format:
    - `SaveFormat.text` (default)
    - `SaveFormat.csv`
    - `SaveFormat.json`

### File Formats

#### Text Format

```dart
Log.enableFileOutput(logFileName: 'log.txt');
```

Example content:

```
(Main) 2025-04-08 16:38:08.454 <0> [INFO] () --> Hello World
(Main) 2025-04-08 16:38:08.470 <0> [DEBUG] (core) --> core is Ok 
(Main) 2025-04-08 16:38:08.471 <0> [WARNING] (core) --> warning system
(Main) 2025-04-08 16:38:08.472 <0> [ERROR] (core) --> Error system failure 2
(Main) 2025-04-08 16:38:08.474 <0> [CRITICAL] (core) --> Critical system failure
```

#### CSV Format

```dart
Log.enableFileOutput(logFileName: 'log.csv', format: SaveFormat.csv);
```

Example content:

```
timeStamp,level,category,message,environment,timeLine
2025-04-08T17:37:19.268682,info,"","Hello World","",0
2025-04-08T17:37:19.273669,debug,"core","core is Ok ","",0
2025-04-08T17:37:19.274667,warning,"core","warning system","",0
2025-04-08T17:37:19.276692,error,"core","Error system failure 2","",0
2025-04-08T17:37:19.277658,critical,"core","Critical system failure","",0
```

#### JSON Format

```dart
Log.enableFileOutput(logFileName: 'log.json', format: SaveFormat.json);
```

Example content:

```json
{"logList": [
  {"level":"info","category":"","message":"Hello World","environment":"","timeStamp":"2025-04-08T16:43:14.405473","timeLine":0},
  {"level":"debug","category":"core","message":"core is Ok ","environment":"","timeStamp":"2025-04-08T16:43:14.412488","timeLine":0},
  {"level":"warning","category":"core","message":"warning system","environment":"","timeStamp":"2025-04-08T16:43:14.413481","timeLine":0},
  {"level":"error","category":"core","message":"Error system failure 2","environment":"","timeStamp":"2025-04-08T16:43:14.414477","timeLine":0},
  {"level":"critical","category":"core","message":"Critical system failure","environment":"","timeStamp":"2025-04-08T16:43:14.416444","timeLine":0}
]}
```

---

### File Closure

You can stop file logging using:

```dart
Log.disableFileOutput();       // Closes file output
Log.disableAllOutput();        // Closes all outputs (file, console, memory, etc.)
```

Using `enableFileOutput(..., exclusive: true)` will also close existing outputs before enabling file output.

---

### Special Note for Web (Browser)

In a browser environment, the file is virtual. Calling `disableFileOutput()` will automatically trigger the **file download** with the specified name.

---
