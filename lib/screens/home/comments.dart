import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/firestore.dart';
import 'package:insta_clone/widgets/comment_card.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user.dart';

class Comments extends StatefulWidget {
  final snap;
  const Comments({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => CommentCard(postId: widget.snap['postId'], snap: snapshot.data!.docs[index].data())
          );
        }
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Write comment...',
              border: InputBorder.none,
              suffix: IconButton(
                onPressed: () async {
                  await FirestoreService().postComment(widget.snap['postId'], _textController.text, user!.uid, user.username, user.imgUrl);
                  setState(() => _textController.clear());
                },
                icon: Icon(Icons.send)
              )
            ),
          ),
        ),
      ),
    );
  }
}
