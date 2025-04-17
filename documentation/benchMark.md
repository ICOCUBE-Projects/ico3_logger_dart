
## Performance Benchmarks

iCo3_Logger is designed for **speed**, **predictability**, and **flexibility**.  
The following benchmarks provide average logging times across different output modes.

> **Test Platform**  
> CPU: Intel Core i9-9900K  
> RAM: 64 GB  
> STORAGE: 2× NVMe SSDs in RAID 1 (mirrored setup)  
> OS: Windows 10  
> Dart SDK: ^3.6.1  
> IDE: IntelliJ IDEA  
> Modes: **JIT (Debug)** and **AOT (Production)**

---

### Benchmark Results

| Output Mode                         | JIT Avg. Time per Log (µs) | AOT Avg. Time per Log (µs) | Notes                                                                                                                       |
|-------------------------------------|:--------------------------:|:--------------------------:|-----------------------------------------------------------------------------------------------------------------------------|
| `criticalMode` (ultra-fast)         |           ~0.14            |           ~0.08            | Minimal checks and overhead. Fastest mode available.                                                                        |
| Process output (function call only) |           ~0.90            |           ~0.37            | Pure function call pipeline, no formatting or I/O.                                                                          |
| In-memory storage                   |           ~0.70            |           ~0.28            | Excellent for deferred or internal analysis.                                                                                |
| File output (without flush)         |            ~35             |            ~30             | Buffered writes. Suitable for high-throughput logging.                                                                      |
| File output (with flush)            |            ~60             |            ~30             | Ensures log persistence after each write. Slightly higher cost.                                                             |
| Console output                      |            ~50             |            ~80             | High variability due to terminal I/O and runtime environment. See details below.                                            |
| Console redirected to file          |            N/A             |            ~30             | Significantly faster: bypasses terminal rendering.                                                                          |

> The benchmark results provided here are for **indicative purposes only**. During testing, we observed that performance could **vary unpredictably due to external runtime factors beyond our control** — such as console behavior, window size, terminal buffering, IDE-specific handling, etc.
>
> JIT averages measured after short warmup period.
> 
> **iCo3_Logger is fully synchronous**, providing stable and predictable execution. It is compatible with both synchronous and asynchronous applications.
>
> If you are developing a **performance-critical application**, we recommend benchmarking it directly in your target environment.
---

### About Console Output

Console output timings can vary significantly depending on **window state and environment context** at startup.

- In **JIT mode**, output seems to be routed via a **socket** to the **IntelliJ console**, which handles rendering separately. This can result in surprisingly fast logging times.
- In **AOT mode**, output goes directly to a native terminal such as **Windows PowerShell**, where the application bears the cost of rendering and scrolling—especially with **thousands of lines**. This leads to higher and more variable latencies (observed between **50 µs and 500 µs**).
- When the console output is **redirected to a file**, the AOT performance improves drastically (down to ~30 µs), suggesting that **terminal rendering is the main bottleneck**.

> **Important**: These variations generally **do not affect normal application usage**.  
> They are **only relevant in performance-critical environments**, such as real-time systems or intensive logging loops.

---

### About Flush Mode

Using `flush: true` on a file output forces logs to be written **immediately** to disk, bypassing OS buffering.

Recommended when:
- The system may **crash or shut down unexpectedly**,
- You need **instantaneous log persistence**,
- You're investigating **intermittent or critical failures**.

---

### Benchmark Source Code

Benchmarking is reproducible. Source code is available at:

```txt
/example/benchmark.dart
```

To run the tests:
1. Open the project in **IntelliJ IDEA** (or any Dart-compatible IDE),
2. Navigate to `example/benchmark.dart`,
3. Run or debug the script as a Dart application.

Results are written to `benchmark.txt`.

---

### Final Note

These benchmarks are **indicative only** and reflect the performance on the given setup.  
Actual results may vary depending on:

- Hardware performance (especially disk I/O),
- Operating system behavior,
- Terminal capabilities and window size,
- Dart runtime mode (JIT vs AOT),
- Log formatting complexity.

> For most developers, iCo3_Logger’s performance will exceed expectations in real-world conditions.

---
