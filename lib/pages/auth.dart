import 'package:flutter/material.dart';
import 'package:liberacion/forms/login.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key, this.title, this.form}) : super(key: key);

  final String title;
  final StatefulWidget form;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset("images/liberacion_big.png"),
                ),
                Container(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 2,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Center(
                              child: Text(
                                widget.title,
                                textScaleFactor: 3,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
  //                          Icon(
  //                            Icons.person,
  //                            size: 128,
  //                            color: Theme.of(context).primaryColor,
  //                          ),
                            SizedBox(
                              height: 20,
                            ),
                            widget.form,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
