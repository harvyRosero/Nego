class Posts {
  String userId;
  String userName;
  String photoProfile;
  String content;
  String imgUrl;
  String category;
  String createdAt;

  Posts({
    required this.userId,
    required this.userName,
    required this.photoProfile,
    required this.content,
    required this.imgUrl,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'photoProfile': photoProfile,
      'content': content,
      'imgUrl': imgUrl,
      'category': category,
      'createdAt': createdAt,
    };
  }
}
