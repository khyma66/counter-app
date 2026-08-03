class ChantSession {
  const ChantSession({
    required this.id,
    required this.mantraId,
    required this.startedAt,
    required this.count,
    this.endedAt,
  });

  final String id;
  final String mantraId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int count;

  Duration get duration => (endedAt ?? DateTime.now()).difference(startedAt);

  ChantSession copyWith({DateTime? endedAt, int? count}) => ChantSession(
        id: id,
        mantraId: mantraId,
        startedAt: startedAt,
        endedAt: endedAt ?? this.endedAt,
        count: count ?? this.count,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'mantraId': mantraId,
        'startedAt': startedAt.toUtc().toIso8601String(),
        'endedAt': endedAt?.toUtc().toIso8601String(),
        'count': count,
      };

  factory ChantSession.fromJson(Map<String, Object?> json) => ChantSession(
        id: json['id']! as String,
        mantraId: json['mantraId']! as String,
        startedAt: DateTime.parse(json['startedAt']! as String),
        endedAt: json['endedAt'] == null ? null : DateTime.parse(json['endedAt']! as String),
        count: json['count']! as int,
      );
}
