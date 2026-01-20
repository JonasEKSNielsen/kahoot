
class JoinSessionDto {

  JoinSessionDto({required this.pin, required this.nickname});

  final String? pin; 
  final String? nickname;

  Map<String, dynamic> toJson() => 
  {
    'sessionPin': pin,
    'nickname': nickname,
  };  
}