import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;
  final bool? isCorrect;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pergunta
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              question.question,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Opções de resposta
        ...question.options.map((option) {
          final bool isSelected = selectedAnswer == option;
          final bool showCorrect =
              selectedAnswer != null && option == question.correctAnswer;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: selectedAnswer == null
                  ? () => onAnswerSelected(option)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _getButtonColor(option, isSelected, showCorrect),
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),

        // Feedback
        if (isCorrect != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isCorrect! ? 'Correto! 🎉' : 'Incorreto! 😕',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isCorrect! ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Color _getButtonColor(String option, bool isSelected, bool showCorrect) {
    if (selectedAnswer == null) {
      return Colors.blue;
    }
    if (showCorrect) {
      return Colors.green;
    }
    if (isSelected) {
      return Colors.red;
    }
    return Colors.blue.withOpacity(0.7);
  }
}
