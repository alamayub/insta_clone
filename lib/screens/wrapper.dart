import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/authenticate/authenticate.dart';
import 'package:insta_clone/screens/home/index.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if(snap.connectionState == ConnectionState.active) {
          if(snap.hasData) {
            return Index();
          } else if(snap.hasError) {
            return Center(
              child: Text('${snap.error}'),
            );
          }
        }
        if(snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return Authenticate();
      }
    );
  }
}
