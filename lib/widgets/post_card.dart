import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore.dart';
import 'package:insta_clone/screens/home/comments.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImg']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.snap['username']}', style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => Dialog(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: ['Delete'].map((e) => InkWell(
                          onTap: () async {
                            await FirestoreService().deletePost(widget.snap['postId']);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Text('$e'),
                          ),
                        )).toList(),
                      ),
                    ));
                  },
                  icon: Icon(Icons.more_vert)
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreService().likePost(widget.snap['postId'], user!.uid, widget.snap['likes']);
              setState(() => isLikeAnimating = true);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: Icon(Icons.favorite, size: 80, color: Colors.red),
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() => isLikeAnimating = false);
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreService().likePost(widget.snap['postId'], user!.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid) ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_outline)
                )
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Comments(snap: widget.snap))),
                icon: Icon(Icons.comment_outlined)
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_outline)),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes', style: Theme.of(context).textTheme.bodyText2),
                Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: '${widget.snap['username']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextSpan(text: ' ${widget.snap['description']}', style: TextStyle(color: Colors.black87)),
                      ]
                    )
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Comments(snap: widget.snap))),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Text('View All ${widget.snap['totalComments']} Comments', style: TextStyle(fontSize: 16, color: Colors.black54),),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), style: TextStyle(fontSize: 16, color: Colors.black54),),
          )
        ],
      ),
    );
  }
}
