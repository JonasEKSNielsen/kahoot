
class AnswerObject {
  int? id; 
  String? text;  
  bool? isCorrect;  
  int? orderIndex;  
  DateTime? createdAt;

  AnswerObject({
    required this.id, 
    required this.text, 
    required this.isCorrect, 
    required this.orderIndex, 
    required this.createdAt,
  });

  static AnswerObject? getAnswerFromJsonMap(Map<String, dynamic> response) {
    try {
      return AnswerObject(
        id: response['id'],
        text: response['text'],
        isCorrect: response['isCorrect'],
        orderIndex: response['orderIndex'],
        createdAt: response['createdAt'] != null ? DateTime.parse(response['createdAt']) : null,
      );
    } catch (_) {}
    return null;
  }
}