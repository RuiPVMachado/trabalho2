import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/score.dart';
import '../widgets/score_widget.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final DatabaseService _dbService = DatabaseService();
  Score? _currentScore;

  @override
  void initState() {
    super.initState();
    _loadCurrentScore();
  }

  Future<void> _loadCurrentScore() async {
    final score = await _dbService.getCurrentScore();
    setState(() {
      _currentScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Atual'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreWidget(
              score: _currentScore?.value ?? 0,
              fontSize: 48,
            ),
            const SizedBox(height: 10),
            if (_currentScore != null)
              Text(
                'Última atualização: ${_formatDate(_currentScore!.timestamp)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                await _dbService.resetCurrentScore();
                await _loadCurrentScore();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Resetar Score',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
