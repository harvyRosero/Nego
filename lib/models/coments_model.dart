class Coments {
  String comentsId;
  String userId;
  String postId;
  String content;
  String createdAt;

  Coments({
    required this.comentsId,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'comentsId': comentsId,
      'userId': userId,
      'postId': postId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
