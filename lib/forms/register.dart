import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:liberacion/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String name;
  String email;
  String password;

  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            obscureText: false,
//            autovalidate: true,
            onChanged: (v) => name = v,
            onFieldSubmitted: (v) => emailFocusNode.requestFocus(),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'Name'),
//            validator: (v) => v.isNotEmpty && v.length < 3 ? 'Name too short' : null,
          ),
          SizedBox(height: 20,),
          TextFormField(
            obscureText: false,
//            autovalidate: true,
            onChanged: (v) => email = v,
            onFieldSubmitted: (v) => passwordFocusNode.requestFocus(),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Login'),
//            validator: (v) => v.isNotEmpty && !v.contains('@') ? 'Email is not valid' : null,
          ),
          SizedBox(height: 20,),
          TextFormField(
            obscureText: true,
//            autovalidate: true,
            focusNode: passwordFocusNode,
            onChanged: (v) => password = v,
            onFieldSubmitted: (v) => passwordFocusNode.unfocus(),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(labelText: 'Password'),
//            validator: (v) => v.isNotEmpty && v.length < 6 ? 'Password too short' : null,
          ),
          SizedBox(height: 20,),
          MaterialButton(
            elevation: 2,
            color: Theme.of(context).accentColor,
            child: Text('REGISTER'),
            onPressed: () => postToApi('/register', {'username': name, 'login': email, 'password': password, 'avatar': 'https://cdn.iconscout.com/icon/free/png-512/avatar-372-456324.png'})
              .then((response) {
                return SharedPreferences.getInstance()
                .then((prefs) => prefs.setString('token', response['token']))
                .then((ok) => ok ? Navigator.pushNamed(
                  context,
                  '/challenges',
                ) : null);
              }
            ),
          ),
        ],
      ),
    );
  }
}
