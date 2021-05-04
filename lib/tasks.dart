import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User loggedinUser;
String loggedinUserEmail;
String task;
DateTime dueDate;

CollectionReference _collectionRef = FirebaseFirestore.instance
    .collection('users')
    .doc(loggedinUser.uid)
    .collection('tasks');
var newDate = dueDate.toString();

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  getDriversList() async {
    return await _collectionRef.get();
  }

  QuerySnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tasks Page'),
        ),
        body: Center(child: _showDrivers()),
      );
    }

    Widget _showDrivers() {
      //check if querysnapshot is null
      if (querySnapshot != null) {
        return ListView.builder(
          primary: false,
          itemCount: querySnapshot.docs.length,
          padding: EdgeInsets.all(12),
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
//load data into widgets
                Text("${querySnapshot.docs[i]['title']}"),
                Text("${querySnapshot.docs[i]['dueDate']}"),
                Text("${querySnapshot.docs[i]['id']}")
              ],
            );
          },
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }
  }
}
