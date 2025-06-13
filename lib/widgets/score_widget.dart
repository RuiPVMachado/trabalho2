import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final int score;
  final double? fontSize;
  final bool showIcon;
  final bool showLabel;

  const ScoreWidget({
    super.key,
    required this.score,
    this.fontSize,
    this.showIcon = true,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(
            Icons.stars,
            color: Colors.amber,
            size: (fontSize ?? 24) + 4,
          ),
          const SizedBox(width: 8),
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel)
              Text(
                'Score',
                style: TextStyle(
                  fontSize: (fontSize ?? 24) * 0.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            Text(
              score.toString(),
              style: TextStyle(
                fontSize: fontSize ?? 24,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 0) return Colors.red;
    if (score < 50) return Colors.orange;
    if (score < 100) return Colors.blue;
    return Colors.green;
  }
}
