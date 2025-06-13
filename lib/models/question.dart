/// Modelo que representa uma questão no jogo de IPv4
///
/// Cada questão contém:
/// - Uma pergunta sobre endereços IPv4
/// - Uma lista de opções de resposta
/// - A resposta correta
/// - O nível de dificuldade (1 = fácil, 2 = médio, 3 = difícil)
class Question {
  /// A pergunta apresentada ao usuário
  final String question;

  /// Lista de opções de resposta disponíveis
  final List<String> options;

  /// A resposta correta que deve corresponder a uma das opções
  final String correctAnswer;

  /// Nível de dificuldade da questão (1-3)
  final int difficulty;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });
}
