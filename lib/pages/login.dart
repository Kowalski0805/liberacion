import 'package:flutter/material.dart';
import 'package:liberacion/forms/login.dart';
import 'package:liberacion/pages/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return AuthPage(title: 'Login', form: LoginForm());
  }
}
