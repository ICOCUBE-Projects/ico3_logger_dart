# iCo3Logger – Documentation Index

This folder contains the technical documentation for **iCo3_Logger**.  
It describes the main features, available output modes, configuration options, and performance characteristics of the logger.  
Each file focuses on a specific aspect and can be read independently.

---

## 🟢 Getting Started
- [Quick Start](quickStart.md) — Minimal setup example.
- [Startup Options](startup.md) — Initialization via code and YAML.

---

## ⚙️ Core Concepts
- [Loggers](loggers.md) — Logger creation and management.
- [Categories](category.md) — How to filter logs by category.
- [Outputs Overview](outputs.md) — Summary of supported outputs.

---

## 🧩 Output Types
- [Console Output](consoleOutput.md)
- [Process Output](processOutput.md)
- [File Output](fileOutput.md)
- [Storage Output](storageOutput.md)

---

## ⚡ Performance & Modes
- [criticalMode](criticalMode.md) — Ultra-minimal mode for high performance.
- [Benchmark Results](benchMark.md) — Logging performance in various modes.
- [TimeLine](timeLine.md) — Logging timeline events and durations.

---

## 🛠 Extensions & Customization
- [Process Output](processOutput.md) — Create your own process.
- [Logger Service](service.md) — Create a logger Service.
- [Custom Log Messages](customLogMessage.md) — Define your own message structure.

---

## 🔍 Debug & Diagnostics
- [Log Sniffer](sniffer.md#-snifferlogservice) — Capture events around critical activity using triggers.
- [Post-Mortem Log](sniffer.md#-postmortem-service-loggerpostfatalservice) — Retrieve logs after a failure or unexpected termination.

---

## 📘 About this Documentation

All files in this folder are part of the internal documentation for `iCo3_Logger`.  
Use this index to navigate by topic. If you are contributing or integrating the logger, this is the recommended starting point.
