import 'dart:convert';

import 'package:first_app/LandingPageModule.dart';
import 'package:first_app/DataClass/LoginData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'SignUpModule.dart';


class LoginModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'ComCom';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
          primaryColor: Colors.purple,
          buttonTheme: ButtonThemeData(minWidth: 100.0, height: 40.0)),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {

  var userNameTextController = TextEditingController(text: 'jenisonleo');

  var passwordTextController = TextEditingController(text: 'simonblack');

  bool showLoader = false;

  void signingInLoader(bool value) {
    setState(() {
      showLoader = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('ComCom'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/ic_sign_in.jpg',
                  ),
                  TextField(
                    controller: userNameTextController,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    controller: passwordTextController,
                    maxLines: 1,
                    obscureText: true,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container (
                    child: !showLoader ? RaisedButton(
                      shape: StadiumBorder(),
                      textColor: Colors.white,
                      color: Colors.purple,
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      onPressed: () {
                        signingInLoader(true);
                        performLogin(userNameTextController.text,
                            passwordTextController.text);
                      },
                    ) : CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => SignUpModule()),
                      );
                    },
                    shape: StadiumBorder(),
                    textColor: Colors.purple,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void performLogin(String userName, String password) async {
    String url = 'https://ahlcomcom1.herokuapp.com/api/login?';
    Map<String, String> header = {
      "Content-type": "application/x-www-form-urlencoded"
    };

    http.Response response = await http.post(url,
        headers: header,
        body: {"username": "$userName", "password": "$password"});

    if (response.statusCode == 200) {
      var loginData = LoginData.fromJson(json.decode(response.body));
      setState(() {
        storeLoginData(loginData);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(builder: (context) => LandingPageModule()),
              (Route<dynamic> route) => false,
        );
      });
    } else {
      signingInLoader(false);
      Toast.show(response.body, context, duration: 3);
    }
  }

  void storeLoginData(LoginData loginData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.token);
    prefs.setString('name', loginData.name);
    prefs.setString('email', loginData.email);
    prefs.setBool('isAdmin', loginData.isAdmin);
    prefs.setString('message', loginData.message);
  }
}