class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int difficulty;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });
}
