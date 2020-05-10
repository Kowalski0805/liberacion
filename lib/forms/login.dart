import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email;
  String password;

  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
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
            autovalidate: true,
            onChanged: (v) => email = v,
            onFieldSubmitted: (v) => passwordFocusNode.requestFocus(),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (v) => v.isNotEmpty && !v.contains('@') ? 'Email is not valid' : null,
          ),
          SizedBox(height: 20,),
          TextFormField(
            obscureText: true,
            autovalidate: true,
            focusNode: passwordFocusNode,
            onChanged: (v) => password = v,
            onFieldSubmitted: (v) => passwordFocusNode.unfocus(),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (v) => v.isNotEmpty && v.length < 6 ? 'Password too short' : null,
          ),
          SizedBox(height: 20,),
          MaterialButton(
            elevation: 2,
            color: Theme.of(context).accentColor,
            child: Text('LOGIN'),
            onPressed: () => Navigator.pushNamed(
                context,
                '/challenges',
                arguments: {
                  'email': email,
                  'password': password,
                },
            ),
          ),
        ],
      ),
    );
  }
}
