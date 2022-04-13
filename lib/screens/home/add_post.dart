import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/resources/firestore.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _captionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  _selectimage(BuildContext context) async {
    return showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(16),
            child: Text('Take a Photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() => _file = file);
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(16),
            child: Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() => _file = file);
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(16),
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    });
  }

  void post(String uid, String username, String profileImg) async {
    setState(() => _isLoading = true);
    try {
      String res = await FirestoreService().uploadPost(_captionController.text, _file!, uid, username, profileImg);
      setState(() => _captionController.clear());
      if(res == "success") {
        setState(() => _isLoading = false);
        showSnackbar("Posted!", context);
        setState(() => _file = null);
      } else {
        setState(() => _isLoading = false);
        showSnackbar(res, context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showSnackbar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    User? user = Provider.of<UserProvider>(context).getUser;
    print(user);
    return _file == null ? Container(
      child: IconButton(
        icon: Icon(Icons.upload_rounded),
        onPressed: () => _selectimage(context),
      ),
    ) : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => _file = null);
          },
        ),
        title: Text('Create Post')
      ),
      body: Column(
        children: [
          _isLoading ? LinearProgressIndicator() : Container(padding: EdgeInsets.only(bottom: 8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user!.imgUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 160,
                child: TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Write a caption...',
                    border: InputBorder.none
                  ),
                  maxLines: 5,
                ),
              ),
              SizedBox(
                height: 48,
                width: 48,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => post(user.uid, user.username, user.imgUrl),
            child: Text('Post'),
          )
        ],
      ),
    );
  }
}
