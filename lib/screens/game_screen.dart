import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../services/question_generator.dart';
import '../models/question.dart';
import '../widgets/question_widget.dart';
import '../widgets/score_widget.dart';
import '../models/score.dart';

class GameScreen extends StatefulWidget {
  final int level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final DatabaseService _dbService = DatabaseService();
  late Question _currentQuestion;
  int _currentScore = 0;
  bool? _isCorrect;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    setState(() {
      _currentQuestion = _questionGenerator.generateQuestion(widget.level);
      _isCorrect = null;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(String answer) async {
    if (_selectedAnswer != null) return; // Previne múltiplas respostas

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == _currentQuestion.correctAnswer;
    });

    // Atualiza o score
    final points = _isCorrect!
        ? widget.level * 10 // 10, 20 ou 30 pontos por acerto
        : -(widget.level * 5); // -5, -10 ou -15 pontos por erro

    _currentScore += points;
    await _dbService.updateCurrentScore(_currentScore);

    // Aguarda 2 segundos antes de carregar a próxima pergunta
    Future.delayed(const Duration(seconds: 2), _loadNextQuestion);
  }

  Future<void> _endGame() async {
    // Adiciona o score atual ao ranking
    final score = Score(
      value: _currentScore,
      timestamp: DateTime.now(),
    );
    await _dbService.addToRanking(score);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nível ${widget.level}'),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScoreWidget(
                score: _currentScore,
                fontSize: 20,
                showLabel: false,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: QuestionWidget(
                question: _currentQuestion,
                selectedAnswer: _selectedAnswer,
                isCorrect: _isCorrect,
                onAnswerSelected: _checkAnswer,
              ),
            ),
            // Botão para sair do jogo
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _endGame,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Terminar Jogo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
