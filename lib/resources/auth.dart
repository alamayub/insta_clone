import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/models/user.dart' as model;
import 'package:insta_clone/resources/storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // register
  Future<String> signUp({
    required String email,
    required String username,
    required String bio,
    required String password,
    required Uint8List file
  }) async {
    String res = 'Some Error Occurred';
    try {
      if(email.isEmpty || username.isEmpty || password.isEmpty || file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String imgUrl = await StorageService().uploadImage('profilePics', file, false);
        model.User user = model.User(
          email: email,
          username: username,
          bio: bio,
          uid: cred.user!.uid,
          imgUrl: imgUrl,
          followers: [],
          following: []
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch(e){
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // login
  Future<String> signIn({
    required String email,
    required String password
  }) async {
    String res = 'Some Error Occurred';
    try {
      if(email.isEmpty || password.isEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch(e){
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}