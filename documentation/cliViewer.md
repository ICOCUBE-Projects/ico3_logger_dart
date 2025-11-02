# CLIViewer — Documentation (ico3_logger)

The **CLIViewer** is a command-line log viewer for **ico3_logger**. It connects to a WebSocket server and displays live log events with level, category, and message. Ideal for quick debugging, demos, or following log streams directly from a dev terminal.

---

## TL;DR

* **Activate** the package globally: `dart pub global activate ico3_logger`
* **Run** the viewer: `dart run ico3_logger:cliViewer <host:port>`
* **In your app**: `Log.connectViewer(address: 'ws://<host>:<port>', ...)`

---

## Requirements

* **Dart SDK** installed and available in your `PATH`.
* Network access to the **WebSocket server** (port open, no firewall blocking).

---

## Installation / Activation

Activate the global CLI command:

```bash
dart pub global activate ico3_logger
```

> This command installs and builds the `cliViewer` executable provided by the package.

---

## Quick Start

Run the viewer by providing the host and port of the WebSocket server:

```bash
dart run ico3_logger:cliViewer 192.168.1.174:4222
```

### Example Output

```text
Building package executable...
Built ico3_logger:cliViewer.
📡 LoggerPrinter listening on ws://192.168.1.174:4222
✅ Client connected from 192.168.1.174
[info] (onConnect) -->
[info] (test) --> test message info
[warning] (test) --> test message warning
[info] (test) --> test message info again
⏹ Client disconnected
✅ Client connected from 192.168.1.174
[info] (test) --> test message info
[warning] (test) --> test message warning
[info] (test) --> test message info 1
[info] (test) --> test message info 2
[info] (test) --> test message info 3
[info] (test) --> test message info 4
[info] (test) --> test message info 5
[info] (test) --> test message info 6
[info] (test) --> test message info 7
[info] (test) --> test message info 8
```

> The viewer displays the **level** (`info`, `warning`, etc.), the **category** (in parentheses), and the **message**. Connection and disconnection events are also displayed.

---

## Application-Side Integration

Add **ico3_logger** to your project and connect to the viewer from your app code:

```dart
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  Log.connectViewer(address: 'ws://192.168.1.174:4222', onConnect: (logError){
    Log.info('test', 'test message info');
    Log.warning('test', 'test message warning');
    Log.info('test', 'test message info 1');
    Log.info('test', 'test message info 2');
    Log.info('test', 'test message info 3');
    Log.info('test', 'test message info 4');
    Log.info('test', 'test message info 5');
    Log.info('test', 'test message info 6');
    Log.info('test', 'test message info 7');
    Log.info('test', 'test message info 8');
  });
}
```

### Key Points

* **`address`** must be a valid **WebSocket** URL (`ws://host:port`).
* **`onConnect`** is triggered once the connection is established — great for sending initial test logs.
* **Categories** (e.g., `test`) help organize and filter logs easily.

---

## Syntax & Parameters

```bash
dart run ico3_logger:cliViewer <host:port>
```

* `<host:port>`: WebSocket server address (e.g., `192.168.1.174:4222`).
* The `ws://` scheme is automatically displayed in the startup banner.

> Tip: Use a **local IP** or **resolvable hostname** within your dev network. Avoid `localhost` if the viewer and app run on different machines.

---

## Best Practices

* **Use a dedicated port** (e.g., `4222`) for the CLIViewer to avoid conflicts.
* **Categorize** your logs (`core`, `network`, `db`, `test`, etc.) for readability.
* **Use consistent log levels** (`info`, `warning`, `error`) for easier visual parsing.

---

## Troubleshooting

* **Cannot connect**: Check IP/port, firewall settings, and ensure the WebSocket server is running.
* **No messages displayed**: Confirm your app calls `Log.connectViewer(...)` and is actively sending logs.
* **Frequent disconnections**: May indicate unstable network or restarted server; restart both viewer and emitter and test with simple `Log.info(...)` calls.

---

## License & Contributors

Refer to the **ico3_logger** repository for license information, issue tracking, and contribution guidelines.

