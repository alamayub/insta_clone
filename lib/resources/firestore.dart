import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone/models/post.dart';
import 'package:insta_clone/resources/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImg
  ) async {
    String res = "Some error occurred";
    try {
      String postUrl = await StorageService().uploadImage('posts', file, true);
      String postId = Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profileImg: profileImg,
        likes: [],
        totalLikes: 0,
        totalComments: 0
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // like post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
          'totalLikes': FieldValue.increment(likes.length > 0 ? -1 : 0)
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
          'totalLikes': FieldValue.increment(1)
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // post comment
  Future<void> postComment(String postId, String text, String uid, String username, String profileImg) async {
    try {
      if(text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore.collection('posts').doc(postId).update({ "totalComments": FieldValue.increment(1) });
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profileImg': profileImg,
          'username': username,
          'uid': uid,
          'comment': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // like comment
  Future<void> likeComment(String postId, String commentId, String uid, List likes) async {
    try {
      if(likes.contains(uid)){
        // await _firestore.doc(docRef.toString()).update({ 'likes': FieldValue.arrayRemove([uid]) });
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // await _firestore.doc(docRef.toString()).update({ 'likes': FieldValue.arrayUnion([uid]) });
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}