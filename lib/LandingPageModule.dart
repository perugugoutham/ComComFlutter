import 'dart:async';
import 'dart:convert';

import 'package:first_app/DataClass/Events.dart';
import 'package:first_app/UI/EventsCard.dart';
import 'package:first_app/DataClass/Infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/InfoCard.dart';
import 'DataClass/Events.dart';
import 'Pages/SettingsPage.dart';


class LandingPageModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'ComCom';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LandingPageState();
  }
}

class LandingPageState extends State<LandingPage> {
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