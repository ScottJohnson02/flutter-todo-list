import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
final db = FirebaseFirestore.instance;
String loggedinUserEmail;

class Tasks extends StatefulWidget {
  final id;
  Tasks({Key key, this.id}) : super(key: key);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  bool isEditable=false;
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {

    return snapshot.data.docs
        .map((doc) => new ListTile(
            leading: new IconButton(
                icon: Icon(CupertinoIcons.pencil),
                onPressed: () {
                  setState(() => {
                    isEditable = true,
                  });


                }),
            title: new Expanded(
                child: !isEditable
                    ? Text(doc['title'])
                    : TextFormField(
                    initialValue: doc['title'],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      //TODO: change doc[title] property or get data from db and use that as initial value
                      print("${doc["title"]}");
                      db
                      .collection('users')
                          .doc(widget.id)
                          .collection('tasks')
                          .doc(doc['title'])
                      .update({"title":value});
                      print("${doc["title"]}");
                      setState(() => {isEditable = false});
                    })),
            trailing: new IconButton(
              icon: new Icon(CupertinoIcons.trash),
              onPressed: (){
                db
                    .collection('users')
                    .doc(widget.id)
                    .collection('tasks')
                    .doc(doc['title'])
                    .delete().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully Deleted')));
                }).catchError((onError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(onError)));
                  taskController.clear();
                });

              },
            ))) //add icon that removes from db
        .toList();
  }

  Widget _showDrivers() {
    return new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .collection('tasks')
            .snapshots(includeMetadataChanges: false),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) return new Text("There is no tasks");
            if (snapshot.hasError) return Text(snapshot.error);
            return new SizedBox(
                height: 100,
                child: ListView(children: getExpenseItems(snapshot)));
          } else {
            return Text('Error');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Tasks Page'),
        ),
        body: Container(
          child: Container(
              child: Column(
                children: [

                  _showDrivers()
                ],
              ),
          ),
        ),
    );
  }
}
