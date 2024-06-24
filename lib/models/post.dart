class Post {
  final String description;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String photoUrl;
  final String profileImage;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.photoUrl,
    required this.profileImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        description: json["description"],
        uid: json["uid"],
        likes: json["likes"],
        postId: json["postId"],
        datePublished: json["datePublished"].toDate(),
        username: json["username"],
        photoUrl: json['photoUrl'],
        profileImage: json['profileImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'photoUrl': photoUrl,
        'profileImage': profileImage
      };
}
