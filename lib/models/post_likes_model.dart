class PostLikes {
  String postLikesId;
  String userId;
  String postId;
  String createdAt;

  PostLikes({
    required this.postLikesId,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'PostLikesId': postLikesId,
      'userId': userId,
      'postId': postId,
      'createdAt': createdAt,
    };
  }
}
