import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String bio;
  final String uid;
  final String imgUrl;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.username,
    required this.bio,
    required this.uid,
    required this.imgUrl,
    required this.followers,
    required this.following
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "imgUrl": imgUrl,
    "bio": bio,
    "followers": followers,
    "following": following
  };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
      email: snap['email'],
      username: snap['username'],
      bio: snap['bio'],
      uid: snap['uid'],
      imgUrl: snap['imgUrl'],
      followers: snap['followers'],
      following: snap['following']
    );
  }
}