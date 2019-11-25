
import 'dart:convert';

import 'package:first_app/LandingPageModule.dart';
import 'package:first_app/DataClass/LoginData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


class SignUpModule extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SignUpPage();
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUpPage> {

  bool fullNameError = false, userNameError = false, emailIdError = false, passwordError = false, showLoader = false;

  var fullNameTextController = TextEditingController();

  var emailIdTextController = TextEditingController();

  var userNameController = TextEditingController();

  var passwordController = TextEditingController();


  void signingUpLoader(bool value) {
    setState(() {
      showLoader = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[

                TextField(
                  controller: fullNameTextController,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      errorText: fullNameError ? 'Field cannot be empty' : null
                  ),
                ),

                SizedBox(
                  height: 16.0,
                ),

                TextField(
                  controller: userNameController,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'User Name',
                      errorText: userNameError ? 'Filed cannot be empty' : null
                  ),
                ),

                SizedBox(
                  height: 16.0,
                ),

                TextField(
                  controller: emailIdTextController,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'Email Id',
                      errorText: emailIdError ? 'Enter valid email Id' : null
                  ),
                ),

                SizedBox(
                  height: 16.0,
                ),

                TextField(
                  controller: passwordController,
                  maxLines: 1,
                  obscureText: true,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError ? 'Password should be more than 8 characters' : null
                  ),
                ),

                SizedBox(
                  height: 60.0,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Container(
                      child: RaisedButton(
                        shape: CircleBorder(),
                        color: Colors.purple,
                        onPressed: () {
                          validateFields(
                              fullNameTextController.text,
                              userNameController.text,
                              emailIdTextController.text,
                              passwordController.text);
                        },
                        child: !showLoader ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ) : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void performSignUp(
      String fullName, String userName, String email, String password) async {
    String url = 'https://ahlcomcom1.herokuapp.com/api/register?';
    Map<String, String> header = {
      "Content-type": "application/x-www-form-urlencoded"
    };

    http.Response response = await http.post(url, headers: header, body: {
      "fullname": "$fullName",
      "username": "$userName",
      "email": "$email",
      "password": "$password"
    });

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
      signingUpLoader(false);
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

  void validateFields(String fullName, String userName, String emailId, String password) {
    const Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern);
    setState(() {
      fullNameError = fullName.isEmpty;
      userNameError = userName.isEmpty;
      emailIdError = (!regex.hasMatch(emailId)) || emailId.isEmpty;
      passwordError = password.length <= 8;

      if(!fullNameError && !userNameError && !emailIdError && !passwordError){
        signingUpLoader(true);
        performSignUp(fullName, userName, emailId, password);
      }

    });
  }

}