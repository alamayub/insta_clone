import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_input_field.dart';
class Register extends StatefulWidget {

  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List _im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _im;
    });
  }

  void registerMe() async {
    setState(() => _isLoading = true );
    String res = await AuthService().signUp(
      email: _emailController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      password: _passwordController.text,
      file: _image!
    );
    setState(() => _isLoading = false);
    if(res != "success") {
      showSnackbar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              SizedBox(height: 30),
              Stack(
                children: [
                  _image != null ? CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(_image!),
                  ) : CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://static.vecteezy.com/packs/media/components/global/search-explore-nav/img/vectors/term-bg-1-666de2d941529c25aa511dc18d727160.jpg'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 56,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo)
                    )
                  )
                ],
              ),
              SizedBox(height: 16),
              TextInputField(
                  textEditingController: _usernameController,
                  hint: 'Enter your username',
                  textInputType: TextInputType.text
              ),
              SizedBox(height: 16),
              TextInputField(
                  textEditingController: _emailController,
                  hint: 'Enter your email',
                  textInputType: TextInputType.emailAddress
              ),
              SizedBox(height: 16),
              TextInputField(
                  textEditingController: _bioController,
                  hint: 'Enter your bio',
                  textInputType: TextInputType.text
              ),
              SizedBox(height: 16),
              TextInputField(
                textEditingController: _passwordController,
                hint: '******',
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: registerMe,
                child: Container(
                  child: _isLoading ? Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ) : Text('Register'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      color: Colors.blue
                  ),
                ),
              ),
              SizedBox(height: 16),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Text('Already have an account?'),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Container(
                      child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
