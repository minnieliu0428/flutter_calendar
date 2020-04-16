import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/LoginPage.dart';

import 'pages/CalendarPage.dart';
import 'pages/HomePage.dart';
import 'common/Constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    loginPageTag: (context) => LoginPage(),
    homePageTag: (context) => HomePage(),
    calendarPageTag: (context) => CalendarPage(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primaryColor: appLightYellowColor,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
