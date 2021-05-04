import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';

final db = FirebaseFirestore.instance;
final _formKey = GlobalKey<FormState>();
final taskController = TextEditingController();

User loggedinUser;
String loggedinUserEmail;
String task;
DateTime dueDate;
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.black),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        loggedinUserEmail = user.email;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);

                //Implement logout functionality
              }),
        ],
        title: Text('Home Page'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
            width: 500,
            height: 1000,
            color: Colors.black,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 500,
                    height: 50,
                    child: Text(
                      "Welcome $loggedinUserEmail",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Container(
                    width: 500,
                    height: 150,
                    color: Colors.grey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Form(
                              key: _formKey,
                              child: Container(
                                  width: 500,
                                  height: 150,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: taskController,
                                          obscureText: false,
                                          textAlign: TextAlign.left,
                                          onChanged: (value) {
                                            task = value;
                                          },
                                          style: TextStyle(color: Colors.black),
                                          decoration:
                                              kTextFieldDecoration.copyWith(
                                                  hintText: 'Enter your Task')),
                                      DateTimeFormField(
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                                hintText: 'Enter Due Date'),
                                        mode:
                                            DateTimeFieldPickerMode.dateAndTime,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: (e) => (e?.day ?? 0) == 1
                                            ? 'Please not the first day'
                                            : null,
                                        onDateSelected: (DateTime value) {
                                          dueDate = value;
                                        },
                                      )
                                    ],
                                  )))
                        ])),
                GestureDetector(
                    onTap: () {
                      db
                          .collection('users')
                          .doc(loggedinUser.uid)
                          .collection('tasks')
                          .doc(task)
                          .set({
                        'title': task,
                        'time': new DateTime.now(),
                        'due date': dueDate
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Successfully Added')));
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                        taskController.clear();
                      });
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
                        child: Text('Add New Task',
                            style: TextStyle(color: Colors.white)))),
                Column(
                  children: [],
                )
              ],
            )),
      ),
    );
  }
}
