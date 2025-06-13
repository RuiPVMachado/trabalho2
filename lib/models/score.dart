class Score {
  final int value;
  final DateTime timestamp;

  Score({required this.value, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {'value': value, 'timestamp': timestamp.toIso8601String()};
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      value: map['value'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
