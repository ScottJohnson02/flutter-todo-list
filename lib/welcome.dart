import 'package:flutter/material.dart';
import 'rounded_button.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    width: 550,
                    height: 100,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Container(
                        alignment: Alignment.center,
                        child: Text('Welcome to Todo List!',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)))),
                RoundedButton(
                  colour: Colors.green,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
                RoundedButton(
                    colour: Colors.grey,
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, 'registration_screen');
                    }),
              ]),
        ));
  }
}
