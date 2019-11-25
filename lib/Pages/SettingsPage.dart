import 'dart:io';

import 'package:first_app/Pages/SplashModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'dart:io' show Platform;


class SettingsPage extends StatelessWidget {
  String fullName, emailId;

  SettingsPage(String fullName, String emailId) {
    this.fullName = fullName;
    this.emailId = emailId;
  }

  void clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('isAdmin');
    prefs.remove('message');
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