import 'dart:convert';
import 'dart:core';
import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:asfar/Localization/setLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import '../main.dart';
import 'Login.dart';
import 'Trips.dart';
import 'package:http/http.dart' as http;

class First extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FirstState();
  }
}

class FirstState extends State<First> {
  String fromCity = "";
  String toCity = "";
  TextEditingController fromCityCon = new TextEditingController();
  TextEditingController toCityCon = new TextEditingController();
  TextEditingController adultPassengers = new TextEditingController();
  TextEditingController childPassengers = new TextEditingController();
  int numPage = 0;
  DateTime selectedDate = DateTime.now();
  List data;
  void languageDialog() {
    Locale _temp;
    // MyApp.setLocale(context, _temp);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title:
            Text(SetLocalization.of(context).getTranslateValue('language')),
            children: [
              SimpleDialogOption(
                child: Text("العربية"),
                onPressed: () {
                  _temp = Locale('ar', 'SY');
                  Navigator.pop(context);
                  MyApp.setLocale(context, _temp);
                },
              ),
              SimpleDialogOption(
                child: Text("English"),
                onPressed: () {
                  _temp = Locale('en', 'US');
                  Navigator.pop(context);
                  MyApp.setLocale(context, _temp);
                },
              ),
            ],
          );
        });
  }
  Future<Widget>noInternetAlert(String response) async {
    String msg=response;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text(SetLocalization.of(context)
                  .getTranslateValue("ok")),
              onPressed: () async {
                Navigator.of(context).pop();


              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+5),

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void navigationBottom(int value) {
    //_temp=Locale('en','US');
    setState(() {
      switch (value) {
        case 0:
          Navigator.pushNamed(context, '/CreateAccount');
          break;
        case 1:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Login("", data,0,0,0)));
          break;
        case 2:
          languageDialog();
          break;
        case 3:
          break;
      }
    });
  }



  Future getDataTrips() async {
    var url = 'http://localhost//Asfar/test%201.php';
    var data1 = {
      "from": fromCityCon.text,
      "to": toCityCon.text,
      "date": selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString()
    };
    try{
    var responce = await http.post(url, body: data1);
    var responcebody = jsonDecode(responce.body);
    return responcebody;}
    catch(e){
      noInternetAlert("No internet connection");

    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> cities = [
      SetLocalization.of(context).getTranslateValue('damascus').toString(),
      SetLocalization.of(context).getTranslateValue('aleppo').toString(),
      SetLocalization.of(context).getTranslateValue('homs').toString(),
      SetLocalization.of(context).getTranslateValue('daraa').toString(),
      SetLocalization.of(context).getTranslateValue('latakia').toString(),
      SetLocalization.of(context).getTranslateValue('tartous').toString(),
      SetLocalization.of(context).getTranslateValue('suwayda').toString(),
    ];
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            SetLocalization.of(context).getTranslateValue('asfar'),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/tickets.png'),
                        fit: BoxFit.fill)),
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: Column(children: [
                  DropDownField(

                      controller: fromCityCon,
                      value: fromCity,
                      //required: true,
                      itemsVisibleInDropdown: 2,
                      strict: true,
                      hintText: SetLocalization.of(context)
                          .getTranslateValue('selectCity'),
                      labelText: SetLocalization.of(context)
                          .getTranslateValue('from :'),
                      icon: Icon(Icons.add_location_alt),
                      items: cities,
                      setter: (dynamic newValue) {
                        fromCity = newValue;
                      }),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  DropDownField(
                      controller: toCityCon,
                      value: toCity,
                      // required: true,
                      strict: true,
                      hintText: SetLocalization.of(context)
                          .getTranslateValue('selectCity'),
                      labelText: SetLocalization.of(context)
                          .getTranslateValue('to :'),
                      icon: Icon(Icons.add_location_alt),
                      items: cities,
                      setter: (dynamic newValue) {
                        toCity = newValue;
                      }),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Container(
                    //padding: EdgeInsets.all(15),
                      child: Column(
                          children: <Widget>[
                            Text(
                      SetLocalization.of(context)
                          .getTranslateValue("please select number of passengers :"),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                            ),

                            //Text("5d5d")
                            Container(
                              padding: EdgeInsets.only(left: 70, right: 70),
                              // padding: EdgeInsets.all(15),

                              child: NumberInputWithIncrementDecrement(
                                controller: adultPassengers,
                                min: 1,
                                max: 3,
                                numberFieldDecoration: InputDecoration(
                                    counterText: SetLocalization.of(context)
                                        .getTranslateValue("adult"),
                                    counterStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                initialValue: 1,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(top: 25, left: 70, right: 70),
                                child: NumberInputWithIncrementDecrement(
                                  controller: childPassengers,
                                  min: 0,
                                  max: 3,
                                  numberFieldDecoration: InputDecoration(
                                      counterText: SetLocalization.of(context)
                                          .getTranslateValue("children"),
                                      counterStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  initialValue: 0,
                                )),
                            Padding(padding: EdgeInsets.only(top: 25)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                                Text(
                                    SetLocalization.of(context)
                                        .getTranslateValue('date'),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text(
                                  '${selectedDate.year}' +
                                      '/' +
                                      '${selectedDate.month}' +
                                      '/' +
                                      '${selectedDate.day}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.blue.shade900)),
                                  child: Text(
                                    SetLocalization.of(context)
                                        .getTranslateValue('selectDate'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    _selectedDate(context);
                                  },
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 20)),
                          ])),

                  //]),
                  Padding(padding: EdgeInsets.only(top: 15)),

                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade900)),
                      child: Text(
                        SetLocalization.of(context)
                            .getTranslateValue('search'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        data = await getDataTrips();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Trips("", data,int.parse(adultPassengers.text.toString()),int.parse(childPassengers.text.toString()),"-1")));
                      },
                    ),
                  ),
                  //       Text("Children",
                  //           style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold)),
                  //       Container(
                  //         width: 300,
                  //
                  //
                  //           child: NumberInputWithIncrementDecrement(
                  //             //controller: childPassengers,
                  //             min: 0,
                  //             max: 4,
                  //           ))
                ],
                ),
              ),
              Container(
                  color: Colors.black38,
                  padding: EdgeInsets.all(15),
                  child: Column(children: [
                    Text(
                      SetLocalization.of(context)
                          .getTranslateValue('contactUs'),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                              SetLocalization.of(context)
                                  .getTranslateValue('facebook'),
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                              SetLocalization.of(context)
                                  .getTranslateValue('whatsapp'),
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                              SetLocalization.of(context)
                                  .getTranslateValue('telegram'),
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                              SetLocalization.of(context)
                                  .getTranslateValue('email'),
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(top: 20)),
                        ]),
                  ]))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text(
                  SetLocalization.of(context).getTranslateValue('sign up')),
              icon: Icon(Icons.account_box),
            ),
            BottomNavigationBarItem(
                title: Text(
                    SetLocalization.of(context).getTranslateValue('login')),
                icon: Icon(Icons.person)),
            BottomNavigationBarItem(
                title: Text(
                    SetLocalization.of(context).getTranslateValue('language')),
                icon: Icon(Icons.language)),
            BottomNavigationBarItem(
                title:
                Text(SetLocalization.of(context).getTranslateValue('more')),
                icon: Icon(Icons.announcement)),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.indigo.shade400,
          onTap: navigationBottom,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
