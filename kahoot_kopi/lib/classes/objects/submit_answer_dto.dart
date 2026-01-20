
class SubmitAnswerDto {

  SubmitAnswerDto({required this.participantId, required this.questionId, required this.answerId, required this.responseTimeMs});

  final int? participantId; 
  final int? questionId;  
  final int? answerId;  
  final int? responseTimeMs;  

  Map<String, dynamic> toJson() => 
  {
    'participantId': participantId,
    'questionId': questionId,
    'answerId': answerId,
    'responseTimeMs': responseTimeMs,
  };
}