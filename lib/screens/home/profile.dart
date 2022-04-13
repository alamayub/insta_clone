import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('username'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // Padding(padding: padding)
        ],
      ),
    );
  }
}
