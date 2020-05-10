import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Image.asset("images/liberacion_big.png"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MaterialButton(
                    elevation: 2,
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                    color: Theme.of(context).accentColor,
                    child: Text("LOGIN"),
                  ),
                  SizedBox(height: 10,),
                  MaterialButton(
                    elevation: 2,
                    onPressed: () => Navigator.pushNamed(context, "/register"),
                    color: Theme.of(context).accentColor,
                    child: Text("REGISTER"),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
