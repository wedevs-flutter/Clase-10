import 'package:flutter/material.dart';
import 'package:quote_character/models/user.dart';
import 'package:quote_character/pages/register_page.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/my_colors.dart';
import 'package:quote_character/widgets/background.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PageController _controller = PageController(initialPage: 0);
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _restProvider = RestProvider();

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                BackgroundLogin(type: Type.login),
                Positioned(
                  bottom: viewInsets.bottom == 0 ? 10 : -70,
                  right: 25,
                  left: 25,
                  child: _loginForm(),
                ),
              ],
            ),
          ),
          RegisterPage(controller: _controller),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12),
          child: _emailTextEditing(),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: _passwordTextEditing(),
        ),
        _btnLogin(),
        _textCreateAccount(),
      ],
    );
  }

  Widget _emailTextEditing() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'Email',
      ),
    );
  }

  Widget _passwordTextEditing() {
    return TextField(
      controller: _passController,
      obscureText: _hidePass,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'Password',
        suffixIcon: GestureDetector(
          child:
              _hidePass ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          onTap: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
      ),
    );
  }

  Widget _btnLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: RaisedButton(
        shape: StadiumBorder(),
        textColor: Colors.white,
        color: MyColors.colorGreen2,
        onPressed: () async {
          if (_emailController.text.isNotEmpty &&
              _passController.text.isNotEmpty) {
            bool resp = await _login();
            if (resp)
              Navigator.of(context).pushNamedAndRemoveUntil(
                'home',
                (route) => false,
              );
            else {
              _emailController.clear();
              _passController.clear();
            }
            //  Navigator.pushNamed(context, 'home');

          }
        },
        child: Text('LOG IN'),
      ),
    );
  }

  Widget _textCreateAccount() {
    return GestureDetector(
      onTap: () {
        _controller.animateToPage(
          1,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 35),
        padding: EdgeInsets.all(12),
        child: Text('Create account'),
      ),
    );
  }

  Future<bool> _login() async {
    User user = User(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    );
    return await _restProvider.loginUser(user);
  }
}
