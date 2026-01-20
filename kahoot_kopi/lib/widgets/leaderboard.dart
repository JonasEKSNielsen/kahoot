
import 'package:flutter/material.dart';

import '../classes/objects/leaderboard_item.dart';
import '../colors.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({
    super.key,
    required this.leaderboardItems,
  });

  final List<LeaderboardItem> leaderboardItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboardItems.length,
      itemBuilder: (context, index) {
        final item = leaderboardItems[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(8),
            border: null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: getRankColor(item.rank),
                    child: Text(
                      '${item.rank}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nickname,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${item.totalPoints}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
