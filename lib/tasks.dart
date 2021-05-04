import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String loggedinUserEmail;

class Tasks extends StatefulWidget {
  final id;
  Tasks({Key key, this.id}) : super(key: key);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(
            title: new Text("${doc['title']}"),
            subtitle: new Text("${doc['time']}"),
            trailing: new Text('Update / Delete')))
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
        body: Center(
            child: SingleChildScrollView(
          child: Container(
              height: 25000,
              child: Column(
                children: [

                  _showDrivers()
                ],
              )),
        )));
  }
}
