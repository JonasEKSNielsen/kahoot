class LeaderboardItem {
  final int participantId;
  final String nickname;
  final int totalPoints;
  final int rank;

  LeaderboardItem({
    required this.participantId,
    required this.nickname,
    required this.totalPoints,
    required this.rank,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      participantId: json['participantId'] as int,
      nickname: json['nickname'] as String,
      totalPoints: json['totalPoints'] as int,
      rank: json['rank'] as int,
    );
  }

  static List<LeaderboardItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => LeaderboardItem.fromJson(item as Map<String, dynamic>)).toList();
  }
}
