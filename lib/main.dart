import 'package:asfar/Localization/setLocalization.dart';
import 'package:asfar/ui/AboutUs.dart';
import 'package:asfar/ui/Booking.dart';
import 'package:asfar/ui/BookingInfo.dart';
import 'package:asfar/ui/MyAccount.dart';
import 'package:asfar/ui/Tickets.dart';
import 'package:asfar/ui/bookingRequest.dart';
import 'package:asfar/ui/SignUp.dart';
import 'package:asfar/ui/CreateAccount2.dart';
import 'package:asfar/ui/First.dart';
import 'package:asfar/ui/Login.dart';
import 'package:asfar/ui/Trips.dart';
import 'package:asfar/ui/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>();
    state.setLocale(locale);
  }

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  //MyApp.setLocale(context, _temp);
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Asfar Internationl",
        routes: <String, WidgetBuilder>{
          '/First': (BuildContext context) => First(),
          '/Login': (BuildContext context) => Login("",[],0,0,0),
          '/CreateAccount': (BuildContext context) => SignUp(),
          '/CreateAccount2': (BuildContext context) => CreateAccount2(),
          '/UserHome': (BuildContext context) => UserHome("-1",[]),
          '/Trip': (BuildContext context) => Trips("",[],0,0,"-1"),
          '/Booking': (BuildContext context) => Booking(-1,-1),
          '/BookingInfo': (BuildContext context) => BookingInfo(0, 0, "",0,0,0,"-1"),
          '/BookingRequest': (BuildContext context) => BookingRequest("-1",[]),
          '/Tickets': (BuildContext context) => Tickets([],"-1"),
          '/MyAccount': (BuildContext context) => MyAccount([]),
          '/AboutUs': (BuildContext context) =>AboutUs(),
        },
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'SY'),
        ],
        locale: _locale,
        localizationsDelegates: [
          SetLocalization.localizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: First(),
        localeResolutionCallback: (deviceLocal, supportedLocales) {
          for (var local in supportedLocales) {
            if (local.languageCode == deviceLocal.languageCode &&
                local.countryCode == deviceLocal.countryCode) {
              return deviceLocal;
            }
          }
          return supportedLocales.first;
        });
  }
}
