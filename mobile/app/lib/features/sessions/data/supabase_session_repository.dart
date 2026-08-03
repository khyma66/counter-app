import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/chant_session.dart';

class LeaderboardEntry {
  const LeaderboardEntry({required this.userId, required this.totalCount});

  final String userId;
  final int totalCount;
}

class SupabaseSessionRepository {
  SupabaseSessionRepository(this._client);

  final SupabaseClient _client;

  Future<String> ensureSignedIn() async {
    final existing = _client.auth.currentUser;
    if (existing != null) return existing.id;

    final response = await _client.auth.signInAnonymously();
    final user = response.user;
    if (user == null) throw StateError('Anonymous Supabase sign-in failed.');
    return user.id;
  }

  Future<void> save(ChantSession session) async {
    final userId = await ensureSignedIn();
    await _client.from('chant_sessions').upsert({
      'id': session.id,
      'user_id': userId,
      'mantra_id': session.mantraId,
      'started_at': session.startedAt.toUtc().toIso8601String(),
      'ended_at': session.endedAt?.toUtc().toIso8601String(),
      'chant_count': session.count,
      'duration_seconds': session.duration.inSeconds,
    });
  }

  Future<List<ChantSession>> listMine({int limit = 100}) async {
    final userId = await ensureSignedIn();
    final rows = await _client
        .from('chant_sessions')
        .select()
        .eq('user_id', userId)
        .order('started_at', ascending: false)
        .limit(limit);

    return (rows as List<dynamic>)
        .map((row) => row as Map<String, dynamic>)
        .map(
          (row) => ChantSession(
            id: row['id'] as String,
            mantraId: row['mantra_id'] as String,
            startedAt: DateTime.parse(row['started_at'] as String),
            endedAt: row['ended_at'] == null
                ? null
                : DateTime.parse(row['ended_at'] as String),
            count: (row['chant_count'] as num).toInt(),
          ),
        )
        .toList(growable: false);
  }

  Future<List<LeaderboardEntry>> leaderboard({int limit = 50}) async {
    final rows = await _client
        .from('leaderboard_totals')
        .select('user_id,total_count')
        .order('total_count', ascending: false)
        .limit(limit);

    return (rows as List<dynamic>)
        .map((row) => row as Map<String, dynamic>)
        .map(
          (row) => LeaderboardEntry(
            userId: row['user_id'] as String,
            totalCount: (row['total_count'] as num).toInt(),
          ),
        )
        .toList(growable: false);
  }
}
