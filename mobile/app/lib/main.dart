import 'package:flutter/material.dart';

import 'core/counter/auto_counter_engine.dart';
import 'core/counter/mock_auto_counter_engine.dart';

void main() => runApp(const MantraCounterApp());

class MantraCounterApp extends StatelessWidget {
  const MantraCounterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mantra Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const OnboardingScreen(),
      );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.self_improvement, size: 88),
                const SizedBox(height: 24),
                Text('Chant with focus', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                const Text(
                  'Count sessions locally. Voice recognition will be added behind the counter engine after the basic flow is validated.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const MantraSelectionScreen()),
                  ),
                  child: const Text('Choose a mantra'),
                ),
              ],
            ),
          ),
        ),
      );
}

class MantraSelectionScreen extends StatelessWidget {
  const MantraSelectionScreen({super.key});

  static const mantras = [
    ('om-namah-shivaya', 'Om Namah Shivaya'),
    ('hare-krishna', 'Hare Krishna Maha Mantra'),
    ('om-namo-narayanaya', 'Om Namo Narayanaya'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Select mantra')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: mantras.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final mantra = mantras[index];
            return Card(
              child: ListTile(
                title: Text(mantra.$2),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LiveCounterScreen(mantraId: mantra.$1, mantraName: mantra.$2),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class LiveCounterScreen extends StatefulWidget {
  const LiveCounterScreen({required this.mantraId, required this.mantraName, super.key});

  final String mantraId;
  final String mantraName;

  @override
  State<LiveCounterScreen> createState() => _LiveCounterScreenState();
}

class _LiveCounterScreenState extends State<LiveCounterScreen> {
  late final AutoCounterEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = MockAutoCounterEngine();
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await _engine.stop();
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SessionSummaryScreen(
          mantraName: widget.mantraName,
          count: _engine.currentCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.mantraName)),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<int>(
                stream: _engine.countStream,
                initialData: _engine.currentCount,
                builder: (_, snapshot) => Text(
                  '${snapshot.data ?? 0}',
                  key: const Key('counter-value'),
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Mock mode: increments once per second'),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: () async {
                      await _engine.start();
                      setState(() {});
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _engine.stop();
                      setState(() {});
                    },
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _engine.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton(onPressed: _finish, child: const Text('Finish session')),
            ],
          ),
        ),
      );
}

class SessionSummaryScreen extends StatelessWidget {
  const SessionSummaryScreen({required this.mantraName, required this.count, super.key});

  final String mantraName;
  final int count;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Session summary')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(mantraName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('$count chants', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const HomePlaceholderScreen()),
                  (_) => false,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      );
}

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mantra Counter')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.self_improvement),
              title: const Text('Start another session'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const MantraSelectionScreen()),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text('Leaderboard'),
              subtitle: Text('Online synchronization planned'),
            ),
            const ListTile(
              leading: Icon(Icons.groups),
              title: Text('Groups'),
              subtitle: Text('Premium family and friends groups planned'),
            ),
          ],
        ),
      );
}
