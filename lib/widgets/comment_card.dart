import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/models/user.dart';

class CommentCard extends StatefulWidget {
  final postId;
  final snap;
  const CommentCard({Key? key, required this.postId, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.snap['profileImg'])),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${widget.snap['username']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextSpan(text: '  ${widget.snap['comment']}', style: TextStyle(color: Colors.black87))
                      ]
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), style: TextStyle(fontSize: 12, color: Colors.black45),),
                  )
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await FirestoreService().likeComment(widget.postId, widget.snap['commentId'], user!.uid, widget.snap['likes']);
            },
            icon: widget.snap['likes'].contains(user!.uid) ? Icon(Icons.favorite, color: Colors.red, size: 16) : Icon(Icons.favorite_outline, size: 16)
          )
        ],
      ),
    );
  }
}
