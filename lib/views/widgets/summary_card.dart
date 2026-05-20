import 'package:flutter/material.dart';
import 'app_card.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final bool filled;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.color = Colors.black,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = filled ? Colors.white : const Color(0xFF102447);
    final mutedColor = filled ? Colors.white70 : const Color(0xFF5E6C84);

    return AppCard(
      color: filled ? color : Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: filled ? Colors.white : color, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: mutedColor, fontSize: 14)),
        ],
      ),
    );
  }
}
