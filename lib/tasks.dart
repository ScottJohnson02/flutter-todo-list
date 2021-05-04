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

  QuerySnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  Widget _showDrivers() {
    //check if querysnapshot is null
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.docs.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Column(children: <Widget>[
            ListTile(
                title: Text("${querySnapshot.docs[i]['title']}"),
                subtitle: Text("${querySnapshot.docs[i]['dueDate']}"),
                leading: Text("${querySnapshot.docs[i]['id']}"),
                trailing: Text('Update / Delete'))
          ]
//load data into widgets

              );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Tasks Page'),
      ),
      body: Center(child: Container(
        child: Column(children: [
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
                            style: TextStyle(color: Colors.white)))),
          _showDrivers()
        ],)
),
    );
  }
}
