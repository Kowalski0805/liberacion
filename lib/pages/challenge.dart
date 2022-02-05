import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liberacion/utils.dart';
import 'package:liberacion/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> with TickerProviderStateMixin {
  AnimationController _controller;
  int room;
  int _user;

  static const List<IconData> icons = const [ Icons.check, Icons.priority_high ];
  fns (index) {
    if (index == 0) return () => showDateDialog(context);
    if (index == 1) return () => showReportForm(context);
    return () => {};
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    SharedPreferences.getInstance().then((prefs) => setState(() { _user = prefs.getInt('id'); }));
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    room = args['id'];
    log(args.toString());
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'.toUpperCase(),),
              Tab(text: 'Progress'.toUpperCase(),),
              Tab(text: 'Participants'.toUpperCase(),),
              Tab(text: 'Reports'.toUpperCase(),),
            ],
          ),
          title: Text('Room ${args['name']}'),
        ),
        body: TabBarView(
          children: [
            overviewTab(context),
            progressTab(context),
            participantsTab(context),
            reportsTab(context),
          ],
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
      ),
    );
  }
  
  Widget overviewTab(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final currentUser = _user;

    var place = args['participants'].where((p) => !!(score(args, p['id']) > score(args, currentUser))).length + 1;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.network(args['avatar']),
          SizedBox(height: 50,),
          Text('Ends on ${dateToString(args['expireDate'])}'),
          Text('Place: $place/${args['participants'].length}'),
          Text('Invite code: ' + (args['id'].toString())),
        ],
      ),
    );
  }

  int score(args, id) {
    return args['checks'].where((e) => e['checker']['id'] == id).length;
  }

  Widget progressTab(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final List users = args['participants'];
    final currentUser = _user;

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var item = users[index];
          var place = args['participants'].where((p) => !!(score(args, p['id']) > score(args, item['id']))).length + 1;
          return ListTile(
            title: Text((item['id'] == currentUser ? 'You' : item['username']) + " - $place place" ),
            subtitle: Text('Score: ${score(args, item['id'])}'),
          );
        }
    );
  }

  Widget participantsTab(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final List users = args['participants'];
    final currentUser = _user;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        var item = users[index];

        return ListTile(
          leading: item['avatar'] != null ? CircleAvatar(backgroundImage: NetworkImage(item['avatar']),) : Icon(Icons.account_circle),
          title: Text(item['id'] == currentUser ? 'You' : item['username']),
        );
      }
    );
  }

  Widget reportsTab(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final List reports = args['reports'];

//    return Center(
//        child: Text('Reports')
//    );
    return ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          var item = reports[index];
          var date = parseDate(item['date']);
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(4),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  child: Image.network(item['image'], width: 100, height: 100,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${item['causer']['username']}, ${date.day.toString()}.${date.month.toString()}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Text("Active: ${item['status'] == 'IN_PROGRESS' ? 'Yes' : 'No'}"),
                        Text("Creator: ${item['creator']['username']}")
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
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
            child: new Icon(_controller.isDismissed ? Icons.check : Icons.close),
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

  showReportForm(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final List users = args['participants'];
    return Navigator.pushNamed(context, '/report', arguments: {'room': room, 'participants': users});
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
      return postToApi('/rooms/$room/check', {'datetime': datetime.toIso8601String()});
    })
    .then((response) => log('check ok')).catchError((error) => {});
  }
}