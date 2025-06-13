import '../models/score.dart';

class ScoreService {
  static const Map<int, Map<String, int>> _scoringRules = {
    1: {'correct': 10, 'incorrect': -5},
    2: {'correct': 20, 'incorrect': -10},
    3: {'correct': 30, 'incorrect': -15},
  };

  /// Calcula a pontuação baseada no nível de dificuldade e se a resposta está correta
  ///
  /// [difficulty] - Nível de dificuldade (1, 2 ou 3)
  /// [isCorrect] - Se a resposta está correta
  ///
  /// Retorna a pontuação a ser adicionada (positiva) ou subtraída (negativa)
  int calculateScore(int difficulty, bool isCorrect) {
    if (!_scoringRules.containsKey(difficulty)) {
      throw Exception('Invalid difficulty level');
    }

    return isCorrect
        ? _scoringRules[difficulty]!['correct']!
        : _scoringRules[difficulty]!['incorrect']!;
  }

  /// Cria um novo objeto Score com a pontuação atual
  Score createScore(int currentScore) {
    return Score(value: currentScore, timestamp: DateTime.now());
  }
}
