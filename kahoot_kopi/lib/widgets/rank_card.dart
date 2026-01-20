import 'package:flutter/material.dart';

class rankCard extends StatelessWidget {
  const rankCard({
    super.key,
    required this.currentPlayerRank,
    required this.nickname,
  });

  final int? currentPlayerRank;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[400],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple[600]!, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'Your Rank',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '#$currentPlayerRank',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            nickname,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}