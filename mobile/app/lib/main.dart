import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'core/config/supabase_config.dart';
import 'core/counter/auto_counter_engine.dart';
import 'core/counter/mock_auto_counter_engine.dart';
import 'features/sessions/data/supabase_session_repository.dart';
import 'features/sessions/domain/chant_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SupabaseSessionRepository? cloudRepository;
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    cloudRepository = SupabaseSessionRepository(Supabase.instance.client);
  }

  runApp(MantraCounterApp(cloudRepository: cloudRepository));
}

class MantraCounterApp extends StatelessWidget {
  const MantraCounterApp({this.cloudRepository, super.key});

  final SupabaseSessionRepository? cloudRepository;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Mantra Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: OnboardingScreen(cloudRepository: cloudRepository),
      );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({this.cloudRepository, super.key});

  final SupabaseSessionRepository? cloudRepository;

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
                Text(
                  cloudRepository == null
                      ? 'Offline mode is active. Add Supabase build variables to enable secure cloud sync.'
                      : 'Cloud sync is active. A private anonymous account will be created automatically.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => MantraSelectionScreen(cloudRepository: cloudRepository),
                    ),
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
  const MantraSelectionScreen({this.cloudRepository, super.key});

  final SupabaseSessionRepository? cloudRepository;

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
                    builder: (_) => LiveCounterScreen(
                      mantraId: mantra.$1,
                      mantraName: mantra.$2,
                      cloudRepository: cloudRepository,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class LiveCounterScreen extends StatefulWidget {
  const LiveCounterScreen({
    required this.mantraId,
    required this.mantraName,
    this.cloudRepository,
    super.key,
  });

  final String mantraId;
  final String mantraName;
  final SupabaseSessionRepository? cloudRepository;

  @override
  State<LiveCounterScreen> createState() => _LiveCounterScreenState();
}

class _LiveCounterScreenState extends State<LiveCounterScreen> {
  late final AutoCounterEngine _engine;
  late final DateTime _startedAt;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _engine = MockAutoCounterEngine();
    _startedAt = DateTime.now();
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    await _engine.stop();

    final endedAt = DateTime.now();
    final session = ChantSession(
      id: const Uuid().v4(),
      mantraId: widget.mantraId,
      startedAt: _startedAt,
      endedAt: endedAt,
      count: _engine.currentCount,
    );

    String syncMessage = 'Saved locally for this session.';
    final cloudRepository = widget.cloudRepository;
    if (cloudRepository != null) {
      try {
        await cloudRepository.save(session);
        syncMessage = 'Synced securely to Supabase.';
      } catch (_) {
        syncMessage = 'Cloud sync failed. The result remains visible locally.';
      }
    }

    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SessionSummaryScreen(
          mantraName: widget.mantraName,
          count: session.count,
          syncMessage: syncMessage,
          cloudRepository: cloudRepository,
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
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await _engine.stop();
                      if (mounted) setState(() {});
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
              TextButton(
                onPressed: _saving ? null : _finish,
                child: Text(_saving ? 'Saving…' : 'Finish session'),
              ),
            ],
          ),
        ),
      );
}

class SessionSummaryScreen extends StatelessWidget {
  const SessionSummaryScreen({
    required this.mantraName,
    required this.count,
    required this.syncMessage,
    this.cloudRepository,
    super.key,
  });

  final String mantraName;
  final int count;
  final String syncMessage;
  final SupabaseSessionRepository? cloudRepository;

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
              const SizedBox(height: 12),
              Text(syncMessage),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => HomeScreen(cloudRepository: cloudRepository),
                  ),
                  (_) => false,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({this.cloudRepository, super.key});

  final SupabaseSessionRepository? cloudRepository;

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
                MaterialPageRoute<void>(
                  builder: (_) => MantraSelectionScreen(cloudRepository: cloudRepository),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_done),
              title: Text(cloudRepository == null ? 'Offline mode' : 'Supabase connected'),
              subtitle: Text(
                cloudRepository == null
                    ? 'No cloud credentials were provided at build time.'
                    : 'Sessions are protected by per-user row-level security.',
              ),
            ),
            const ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text('Leaderboard API ready'),
              subtitle: Text('UI ranking and public display names are the next product step.'),
            ),
            const ListTile(
              leading: Icon(Icons.groups),
              title: Text('Groups'),
              subtitle: Text('Requires group membership and subscription schema.'),
            ),
          ],
        ),
      );
}
