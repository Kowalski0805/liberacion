import 'package:flutter/material.dart';
import 'package:liberacion/forms/report.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('Create report'),),
      body: SingleChildScrollView(
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
                      'Create report',
                      textScaleFactor: 3,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ReportForm(list: args['participants'], room: args['room']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
