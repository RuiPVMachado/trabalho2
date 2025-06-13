/// Modelo que representa uma pontuação obtida no jogo
///
/// Cada Score contém:
/// - O valor da pontuação
/// - A data e hora em que foi obtida
class Score {
  /// Pontuação obtida pelo jogador
  final int value;

  /// Data e hora em que a pontuação foi registrada
  final DateTime timestamp;

  Score({
    required this.value,
    required this.timestamp,
  });

  /// Converte o Score para um Map que pode ser salvo no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Cria um Score a partir de um Map vindo do banco de dados
  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      value: map['value'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
