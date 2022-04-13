import 'package:flutter/material.dart';
import 'package:insta_clone/resources/auth.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_input_field.dart';
class Login extends StatefulWidget {

  final Function toggleView;
  const Login({Key? key, required this.toggleView}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void logMe() async {
    setState(() => _isLoading = true);
    String res = await AuthService().signIn(email: _emailController.text, password: _passwordController.text);
    if(res == "success") {
      //
    } else {
      showSnackbar(res, context);
    }
    setState(() => _isLoading = false);
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
              TextInputField(
                textEditingController: _emailController,
                hint: 'Enter your email',
                textInputType: TextInputType.emailAddress
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
                onTap: logMe,
                child: Container(
                  child: _isLoading ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ) : Text('Log In'),
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
              SizedBox(height: 12),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Text('Don\'n have an account?'),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Container(
                      child: Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
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
