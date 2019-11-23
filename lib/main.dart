import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:first_app/Events.dart';
import 'package:first_app/Infos.dart';
import 'package:first_app/LoginData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


void main() {
  runApp(SplashModule());
}

class SplashModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.purple,
          buttonTheme: ButtonThemeData(minWidth: 100.0, height: 40.0)),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.purple,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text('Warming up..')
        ],
      )),
    );
  }
}

void checkLoginStatus(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token');
  if (token == null || token.isEmpty) {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => LoginModule()),
      (Route<dynamic> route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => MyApp()),
      (Route<dynamic> route) => false,
    );
  }
}

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
          MaterialPageRoute<dynamic>(builder: (context) => MyApp()),
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
          MaterialPageRoute<dynamic>(builder: (context) => MyApp()),
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'ComCom';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State<MyHomePage> {
  var currentBottomNavIndex = 0;

  var events = List<Events>();

  String token, fullName, emailId;

  Future<List<Events>> fetchEvents(String token) async {
    final response = await http.get(
      "https://ahlcomcom1.herokuapp.com/api/events",
      headers: {"Authorization": token},
    );

    return parseEvents(response.body);
  }

  List<Events> parseEvents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Events>((json) => Events.fromJson(json)).toList();
  }

  Future<List<Infos>> fetchInfos(String token) async {
    final response = await http.get(
      "https://ahlcomcom1.herokuapp.com/api/infos",
      headers: {"Authorization": token},
    );

    return parseInfos(response.body);
  }

  List<Infos> parseInfos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Infos>((json) => Infos.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    readLoginData();
  }

  void readLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      fullName = prefs.getString('name');
      emailId = prefs.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget;

    if (currentBottomNavIndex == 1) {
      screenWidget = FutureBuilder<List<Events>>(
        future: fetchEvents(token),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return EventsCard(snapshot.data[index]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    } else if (currentBottomNavIndex == 0) {
      screenWidget = FutureBuilder<List<Infos>>(
        future: fetchInfos(token),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return InfosCard(snapshot.data[index]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    } else {
      screenWidget = SettingsPage(fullName, emailId);
    }

    return Scaffold(
      appBar: AppBar(title: Text(() {
        if (currentBottomNavIndex == 0) {
          return 'Feeds';
        } else if (currentBottomNavIndex == 1) {
          return 'Events';
        } else {
          return 'Profile';
        }
      }())),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNavIndex,
        onTap: onBottomNavTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.description,
              ),
              title: Text('Feeds')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.event,
              ),
              title: Text('Events')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text('Profile'))
        ],
      ),
      body: screenWidget,
    );
  }

  void onBottomNavTapped(int index) {
    setState(() {
      currentBottomNavIndex = index;
    });
  }
}

class SettingsPage extends StatelessWidget {
  String fullName, emailId;

  SettingsPage(String fullName, String emailId) {
    this.fullName = fullName;
    this.emailId = emailId;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.account_circle,
                  size: 55.0,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Center(
                child: Text(
                  fullName,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Center(
                child: Text(
                  emailId,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                color: Colors.black26,
              ),
              InkWell(
                onTap: () {
                  url.launch('https://comcom.flycricket.io/privacy.html');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black26,
              ),
              InkWell(
                onTap: () {
                  showDialog<dynamic>(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          titlePadding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          title: const Text('About us'),
                          children: <Widget>[
                            const Text(
                                'ComCom enables users to get the recent updates about the Anna Hockey Team\'s news, events and also helps make decisions easily using polls based functionalities.'),
                            Align(
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ),
                              alignment: Alignment.centerRight,
                            )
                          ],
                        );
                      });
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'About',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black26,
              ),
              InkWell(
                onTap: () {
                  showDialog<dynamic>(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Developed using Flutter by,',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Perugu Goutham',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.title,
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'perugugoutham@gmail.com',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    url.launch(
                                        "https://www.facebook.com/peru.goutham");
                                  },
                                  child: SvgPicture.asset(
                                    'assets/fb.svg',
                                    height: 40.0,
                                    width: 40.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    url.launch(
                                        "https://www.linkedin.com/in/goutham-perugu-bb73bbb8");
                                  },
                                  child: SvgPicture.asset(
                                    'assets/linked.svg',
                                    height: 40.0,
                                    width: 40.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Align(
                              child: RaisedButton(
                                onPressed: () {
                                  var urlString =
                                      'mailto:perugugoutham@gmail.com?subject=Feedback on ComCom - ' +
                                          Platform.operatingSystem;
                                  url.launch(urlString);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Send Feedback'),
                                shape: StadiumBorder(),
                                textColor: Colors.white,
                                color: Colors.purple,
                              ),
                            )
                          ],
                        );
                      });
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Feedback',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black26,
              ),
              InkWell(
                onTap: () {
                  clearLoginData();
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (context) => SplashModule()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black26,
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  'Developed using Flutter \u00AE',
                  style: TextStyle(color: Colors.black12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void clearLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove('name');
  prefs.remove('email');
  prefs.remove('isAdmin');
  prefs.remove('message');
}

class InfosCard extends StatelessWidget {
  Infos data;

  InfosCard(Infos data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, hh:mm');

    String date =
        formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.id.time));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Text(date, style: Theme.of(context).textTheme.caption)
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              data.description,
              style: Theme.of(context).textTheme.body1,
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}

class EventsCard extends StatelessWidget {
  Events data;

  EventsCard(Events data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, hh:mm');

    String fromDateReadable =
        formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.fromDate));

    String toDateReadable =
        formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.toDate));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data.title,
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              data.description,
              style: Theme.of(context).textTheme.body1,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.purple,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  data.place,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: Colors.purple,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  fromDateReadable,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
