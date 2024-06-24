class Comment {
  final String username;
  final String uid;
  final String profilePic;
  final String content;
  final String commentId;
  final DateTime datePublished;

  const Comment(
      {required this.username,
      required this.uid,
      required this.profilePic,
      required this.content,
      required this.commentId,
      required this.datePublished});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        username: json['username'],
        uid: json['uid'],
        profilePic: json['profilePic'],
        content: json['content'],
        commentId: json['commentId'],
        datePublished: json['datePublished']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'uid': uid,
      'profilePic': profilePic,
      'content': content,
      'commentId': commentId,
      'datePublished': datePublished
    };
  }
}
