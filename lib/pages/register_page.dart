import 'package:flutter/material.dart';
import 'package:quote_character/models/user.dart';
import 'package:quote_character/providers/rest_provider.dart';
import 'package:quote_character/utils/my_colors.dart';
import 'package:quote_character/widgets/background.dart';

class RegisterPage extends StatefulWidget {
  final PageController controller;

  RegisterPage({this.controller});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _provider = RestProvider();

  bool _hidePass = true;
  bool _activateBtn = true;

  final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.colorGreen1,
      width: 1.7,
    ),
    borderRadius: BorderRadius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            BackgroundLogin(type: Type.register),
            Positioned(
              top: 30,
              right: 25,
              left: 25,
              child: _loginForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12),
          child: _nameTextEditing(),
        ),
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

  Widget _nameTextEditing() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        enabledBorder: _inputBorder,
        focusedBorder: _inputBorder,
        labelText: 'Name',
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
        onPressed: _activateBtn
            ? () async {
                _statusBtn(false);
                if (_emailController.text.isEmpty ||
                    _passController.text.isEmpty ||
                    _nameController.text.isEmpty)
                  _statusBtn(true);
                else {
                  await _doRegister()
                      ? widget.controller.animateToPage(
                          0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn,
                        )
                      : _statusBtn(true);
                }
              }
            : null,
        child: Text('SIGN UP'),
      ),
    );
  }

  Widget _textCreateAccount() {
    return GestureDetector(
      onTap: () {
        widget.controller.animateToPage(
          0,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 35),
        padding: EdgeInsets.all(12),
        child: Text('I have an account'),
      ),
    );
  }

  void _statusBtn(bool status) {
    setState(() {
      _activateBtn = status;
    });
  }

  Future<bool> _doRegister() async {
    User user = User(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
    );
    _nameController.clear();
    _emailController.clear();
    _passController.clear();
    return await _provider.registerUser(user);
  }
}
