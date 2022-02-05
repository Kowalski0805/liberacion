import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liberacion/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportForm extends StatefulWidget {
  List list;
  int room;

  ReportForm({this.list, this.room}): super();

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  int reportee;
  DateTime datetime;
  String comment;
  File imageFile;
  int _user;

  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    passwordFocusNode = FocusNode();
    SharedPreferences.getInstance().then((prefs) => setState(() { _user = prefs.getInt('id'); }));
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
          DropdownButtonFormField(
            onSaved: (v) => reportee = v,
            value: widget.list[0]['id'],
            items: widget.list.where((e) => e['id'] != _user).map((e) =>
              DropdownMenuItem(
                value: e['id'],
                child: Row(
                  children: <Widget>[
                    e['avatar'] != null ? CircleAvatar(backgroundImage: NetworkImage(e['avatar']),) : Icon(Icons.account_circle),
                    SizedBox(width: 20,),
                    Text(e['username']),
                  ],
                ),
              )
            ).toList(),
            onChanged: (v) => reportee = v,
          ),
          SizedBox(height: 20,),
          InputDatePickerFormField(
            firstDate: DateTime.now().subtract(Duration(days: 30)),
            lastDate: DateTime.now(),
            onDateSaved: (v) => datetime = v,
            onDateSubmitted: (v) => datetime = v,
          ),
          SizedBox(height: 20,),
          TextFormField(
            onSaved: (v) => comment = v,
            onChanged: (v) => comment = v,
            decoration: InputDecoration(
              labelText: 'Comment',
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              _setImageView(),
              MaterialButton(
                color: Theme.of(context).backgroundColor,
                child: Text('Upload photo'),
                onPressed: () => _showSelectionDialog(context),
              ),
            ],
          ),
          SizedBox(height: 20,),
          MaterialButton(
            elevation: 2,
            color: Theme.of(context).accentColor,
            child: Text('SUBMIT'),
            onPressed: () => postToApi('/rooms/${widget.room}/report', {'reportee': reportee, 'datetime': datetime, 'comment': comment, 'image': 'https://picsum.photos/500'}).then(
                    (response) {
                  log(response.toString());
                  return Navigator.pushNamed(
                    context,
                    '/challenges',
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _getPhoto(context, ImageSource.gallery);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _getPhoto(context, ImageSource.camera);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _getPhoto(BuildContext context, ImageSource source) async {
    var picture = await ImagePicker().getImage(source: source);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 100, height: 100);
    } else {
      return Text("Please select an image");
    }
  }


}
