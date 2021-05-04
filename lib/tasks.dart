import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User loggedinUser;
String loggedinUserEmail;
String task;
DateTime dueDate;

var newDate = dueDate.toString();

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  getDriversList() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedinUser.uid)
        .collection('tasks')
        .get();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => new ListTile(
            title: new Text("${doc['title']}"),
            subtitle: new Text("${doc['dueDate']}"),
            leading: new Text("${doc['id']}"),
            trailing: new Text('Update / Delete')))
        .toList();
  }

  Widget _showDrivers() {
    //check if querysnapshot is null

    return new StreamBuilder<QuerySnapshot>(
        stream: getDriversList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text("There is no tasks");
          if (snapshot.hasError) return Text(snapshot.error);
          return new ListView(children: getExpenseItems(snapshot));
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
          child: Container(
              child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'home');
                  },
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.green),
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      alignment: Alignment.center,
                      width: 200,
                      height: 50,
                      child: Text('Add Task / Home',
                          style: TextStyle(color: Colors.black)))),
              _showDrivers()
            ],
          )),
        ));
  }
}
