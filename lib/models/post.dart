import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImg;
  final List likes;
  final int totalLikes;
  final int totalComments;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImg,
    required this.likes,
    required this.totalLikes,
    required this.totalComments
  });

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    "postUrl": postUrl,
    "profileImg": profileImg,
    "likes": likes,
    "totalLikes": totalLikes,
    "totalComments": totalComments
  };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      description: snap['description'],
      username: snap['username'],
      uid: snap['uid'],
      postId: snap['postId'],
      datePublished: snap['datePublished'],
      postUrl: snap['postUrl'],
      profileImg: snap['profileImg'],
      likes: snap['likes'],
      totalLikes: snap['totalLikes'],
      totalComments: snap['totalComments']
    );
  }
}