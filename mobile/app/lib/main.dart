import 'package:flutter/material.dart';

void main() {
  runApp(const CounterApp());
}

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(useMaterial3: true),
      home: const CounterHomePage(),
    );
  }
}

class CounterHomePage extends StatefulWidget {
  const CounterHomePage({super.key});

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  int count = 0;
  bool running = false;

  void start() {
    setState(() {
      running = true;
    });
  }

  void stop() {
    setState(() {
      running = false;
    });
  }

  void mockIncrement() {
    if (!running) return;
    setState(() {
      count += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mock Auto Counter'),
            Text('$count', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(onPressed: start, child: const Text('Start')),
                ElevatedButton(onPressed: stop, child: const Text('Stop')),
                ElevatedButton(onPressed: mockIncrement, child: const Text('Mock +1')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
