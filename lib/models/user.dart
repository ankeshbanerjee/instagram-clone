class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String profilePicture;
  final List followers;
  final List following;
  User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.bio,
      required this.profilePicture,
      required this.followers,
      required this.following});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      uid: json['uid'],
      email: json['email'],
      bio: json['bio'],
      profilePicture: json['profilePicture'],
      followers: json['followers'],
      following: json['following'],
    );
  }

  Map<String, dynamic> toJson() {
    return ({
      'username': username,
      'uid': uid,
      'email': email,
      'bio': bio,
      'profilePicture': profilePicture,
      'followers': followers,
      'following': following
    });
  }
}
