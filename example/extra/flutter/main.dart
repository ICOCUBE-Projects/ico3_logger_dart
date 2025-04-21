import 'package:flutter/material.dart';
import 'package:ico3_logger/ico3_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Log.setDecoration(category: true, timeStamp: true);
    Log.enableFileOutput(logFileName: 'testWeb.txt', exclusive: true);
    Log.createLogger('ConsoleLog', categories: '<clear> console');
    Log.setDecoration(
        logger: 'ConsoleLog', timeStamp: true, loggerID: true, category: true);
    Log.setCategories('<clear> file');
  }

  void _consoleLog() {
    Log.info('console', 'hello world $_counter');
    _incrementCounter();
  }

  void _fileLog() {
    Log.info('file', 'hello world $_counter');
    _incrementCounter();
  }

  void _saveLogFile() {
    Log.disableFileOutput();
    Log.enableFileOutput(logFileName: 'testWeb$_counter.txt');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _consoleLog, child: const Text('Log to Console')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _fileLog, child: const Text('Log to File')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _saveLogFile, child: const Text('Save File')),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
