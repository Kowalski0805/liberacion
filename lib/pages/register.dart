import 'package:flutter/material.dart';
import 'package:liberacion/forms/register.dart';
import 'package:liberacion/pages/auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return AuthPage(title: 'Register', form: RegisterForm());
  }
}
