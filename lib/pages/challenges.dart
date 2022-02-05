import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:liberacion/api.dart';
import 'package:liberacion/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> with TickerProviderStateMixin {
  AnimationController _controller;

  final _text = TextEditingController();
  bool _validate = false;
  String invite = '';

  var future = SharedPreferences.getInstance().then((prefs) =>
    getFromApi('/user')
    .then((user) => prefs.setInt('id', user['id']))
    .then((_) => getFromApi('/rooms'))
  );

  static const List<IconData> icons = const [ Icons.add_box, Icons.input ];
  fns (index) {
    if (index == 0) return () => showDateDialog(context);
    if (index == 1) return () => showAlertDialog(context);
    return () => {};
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('My challenges'),
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = buildMiniFab(index);
          return child;
        }).toList()..add(
          buildMainFab()
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data.toString());
            var items = snapshot.data;
            return buildRoomList(items);
          } else if (snapshot.hasError) {
            return buildError(snapshot.error);
          } else {
            return buildLoader();
          }
        },
      ),
    );
  }

  Center buildError(error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: $error'),
            )
          ],
        )
    );
  }

  Center buildLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Awaiting result...'),
          )
        ],
      ),
    );
  }

  ListView buildRoomList(items) {
    SharedPreferences.getInstance().then((prefs) => prefs.getString('token')).then((token) => log('Token: $token'));
    return ListView.builder(
      padding: EdgeInsets.all(4),
      itemCount: items.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = items[index];
        log(item.toString());

        return Card(
          elevation: 4,
          margin: EdgeInsets.all(4),
          child: InkWell(
            onTap: () {
              return getFromApi('/rooms/${item['id']}')
              .then((response) => Navigator.pushNamed(
                context,
                '/challenge',
                arguments: response,
              ));
            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  child: Image.network(item['avatar'], width: 100, height: 100,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Room ${item['name']}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
//                        Text("${item['points'].toString()} points"),
                        Text("Left: ${daysLeft(item['expireDate'])} days"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  buildMiniFab(index) {
    return new Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: new ScaleTransition(
        scale: new CurvedAnimation(
          parent: _controller,
          curve: new Interval(
              0.0,
              1.0 - index / icons.length / 2.0,
              curve: Curves.easeOut
          ),
        ),
        child: new FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          mini: true,
          child: new Icon(icons[index]),
          onPressed: fns(index),
        ),
      ),
    );
  }

  buildMainFab() {
    return new FloatingActionButton(
      heroTag: null,
      child: new AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
            alignment: FractionalOffset.center,
            child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
          );
        },
      ),
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget input = TextField(
      controller: _text,
      onChanged: (v) => invite = v,
      decoration: InputDecoration(
        labelText: 'Code',
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        border: UnderlineInputBorder(),
      ),
    );
//    Widget input = Row(
//      children: <Widget>[
//        CalendarDatePicker(),
//        TimeIn
//      ],
//    );
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        if (invite.isEmpty) return;
        log(invite);
        try {
          postToApi('/rooms/$invite', {'a': 'b'})
//          .then(() => log('hooray'))
//          .then((_) => getFromApi('/rooms/$invite'))
          .then((response) => Navigator.pushNamed(
            context,
            '/challenge',
            arguments: response,
          ));
        } catch(e) {

        }

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enter invitation code"),
      content: input,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDateDialog(BuildContext context) {
    DateTime datetime = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      fieldLabelText: 'Select date',
    ).then((date) {
      if (date == null) return null;
      datetime = date;
      return showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }).then((time) {
      if (time == null) return null;
      datetime = DateTime(datetime.year, datetime.month, datetime.day, time.hour, time.minute);
      log(datetime.toIso8601String());
      return postToApi('/rooms', {'end': datetime.toIso8601String(), 'challenge': 3, 'name': math.Random().nextInt(100000), 'avatar': 'https://picsum.photos/500'});
    })
    .then((response) {
      log(response.toString());
      return getFromApi('/rooms/${response['id']}');
    })
    .then((response) => Navigator.pushNamed(
      context,
      '/challenge',
      arguments: response,
    )).catchError((error) => {});
  }
}
