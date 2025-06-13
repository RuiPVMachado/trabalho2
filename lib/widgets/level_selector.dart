import 'package:flutter/material.dart';

class LevelSelector extends StatelessWidget {
  final Function(int) onLevelSelected;

  const LevelSelector({
    super.key,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLevelCard(
          context,
          level: 1,
          title: 'Network ID e Broadcast',
          subtitle: 'Máscaras /8, /16 e /24',
          difficulty: 'Fácil',
          color: Colors.green,
          icon: Icons.network_wifi,
        ),
        const SizedBox(height: 16),
        _buildLevelCard(
          context,
          level: 2,
          title: 'Sub-redes',
          subtitle: 'Máscaras como 255.255.255.192',
          difficulty: 'Médio',
          color: Colors.orange,
          icon: Icons.hub,
        ),
        const SizedBox(height: 16),
        _buildLevelCard(
          context,
          level: 3,
          title: 'Super-redes',
          subtitle: 'Máscaras como 255.255.248.0',
          difficulty: 'Difícil',
          color: Colors.red,
          icon: Icons.cloud,
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required int level,
    required String title,
    required String subtitle,
    required String difficulty,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => onLevelSelected(level),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  difficulty,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
