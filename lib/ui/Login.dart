import 'dart:convert';

import 'package:asfar/Localization/setLocalization.dart';
import 'package:asfar/ui/SignUp.dart';
import 'package:flutter/material.dart';
import 'BookingInfo.dart';
import 'First.dart';
import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'Trips.dart';
import 'UserHome.dart';

class Login extends StatefulWidget {
  String from ;
  List data;
  int numAdult;
  int numChild;
  int tripId;
  Login(this.from,this.data,this.numAdult,this.numChild,this.tripId);
  @override
  State<StatefulWidget> createState() {
    return LoginState(from,data,numAdult,numChild,tripId);
  }
}

class LoginState extends State<Login> {
  String from ;
  List data;
  int numAdult;
  int numChild;
  int tripId;
  List dataUserId;
  List dataTripsStory;
  DateTime selectedDate = DateTime.now();
  LoginState(this.from,this.data,this.numAdult,this.numChild,this.tripId);
  FirstState firstPage = new FirstState();
  GlobalKey<FormState>formStateLogin=new GlobalKey<FormState>();
  TextEditingController phoneNumber=new TextEditingController();
  TextEditingController password=new TextEditingController();
  String phoneNumberValidator(String val){
    if (val.trim().isEmpty)
      return SetLocalization.of(context)
          .getTranslateValue("phone number can't empty");
    if (val.trim().length<10)
      return SetLocalization.of(context)
          .getTranslateValue("phone number can't less than 10");
    if(val.trim().length>10)
      return SetLocalization.of(context)
          .getTranslateValue("phone number can't more than 10");
    if(val.trim().trim().substring(0,2)!="09")
      return SetLocalization.of(context)
        .getTranslateValue("phone number should start with 09");
  }
  String passwordValidator(String val){
    if (val.trim().isEmpty)
      return SetLocalization.of(context)
          .getTranslateValue("password can't empty");
    if (val.trim().length<8)
      return SetLocalization.of(context)
          .getTranslateValue("password can't less than 8");
    if(val.trim().length>12)
      return SetLocalization.of(context)
          .getTranslateValue( "password can't more than 12");
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
  Future getDataTripsStory() async {
    var url = 'http://localhost/Asfar/tripsStory.php';
    var data2 = {

      "dateTrip": selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          (selectedDate.day+1).toString()
    };
try{
    var responce = await http.post(url, body: json.encode(data2));
    var responcebody = jsonDecode(responce.body);
    return responcebody;
}
    catch(e){
      noInternetAlert("No internet connection");
    }
  }
  Widget loginAlert(){
    String msg=SetLocalization.of(context)
        .getTranslateValue("invalid phone number or password Please Try Again .. ?");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text(SetLocalization.of(context)
            .getTranslateValue("ok")),
              onPressed: () {
                Navigator.of(context).pop();


              },
            ),
          ],
        );
      },
    );
  }
  void login() async{
    var formData=formStateLogin.currentState;

    if(formData.validate()) {
      formData.save();
      try {
        var data1 = {
          "mobile": phoneNumber.text,
          "password": password.text.hashCode
        };

        var url = 'http://localhost/Asfar/login.php';
        var response = await http.post(url, body: json.encode(data1));

        var responsebody = jsonDecode(response.body);

        if (responsebody == "yes") {
          if (from == "Trips") {
            dataUserId = await getUserId();

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    BookingInfo(
                        numAdult,
                        numChild,
                        "Civil",
                        0,
                        0,
                        tripId,
                        dataUserId[0]["id"].toString())), (route) => false);
          }
          else {
            dataUserId = await getUserId();

            dataTripsStory = await getDataTripsStory();

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    UserHome(dataUserId[0]['id'].toString(), dataTripsStory)), (
                route) => false);
          }
        }
        else
          loginAlert();
      }

catch(e)
    {
      noInternetAlert("no Intenet connection");
    }
    }

  }
  Future  getUserId() async {
    var url = 'http://localhost/Asfar/userAppId.php';
    var data2 = {
      'mobile':phoneNumber.text,
    };
    try{
    var responce = await http.post(url,body: json.encode(data2));
    var responcebody = jsonDecode(responce.body);
    return responcebody;}
    catch(e){
      noInternetAlert("No Internet Connection");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: Text(SetLocalization.of(context)
        .getTranslateValue('login')),
            backgroundColor: Colors.indigo,
          ),
          body:Form(
              key:formStateLogin ,
              child:SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/background.png'),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 30,
                              width: 80,
                              height: 200,
                              child: FadeAnimation(
                                  1,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                            AssetImage('images/light-1.png'))),
                                  )),
                            ),
                            Positioned(
                              left: 140,
                              width: 80,
                              height: 150,
                              child: FadeAnimation(
                                  1.3,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                            AssetImage('images/light-2.png'))),
                                  )),
                            ),
                            Positioned(
                              right: 40,
                              top: 40,
                              width: 80,
                              height: 150,
                              child: FadeAnimation(
                                  1.5,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage('images/clock.png'))),
                                  )),
                            ),
                            Positioned(
                              child: FadeAnimation(
                                  1.6,
                                  Container(
                                    margin: EdgeInsets.only(top: 50),
                                    child: Center(
                                      child: Text(
                                        SetLocalization.of(context)
                                            .getTranslateValue("login"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.8,
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.shade100))),
                                        child: TextFormField(
                                          validator:phoneNumberValidator ,
                                          controller: phoneNumber,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: SetLocalization.of(context)
                                                .getTranslateValue("phone number"),
                                            hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                            icon: Icon(Icons.account_box),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          validator:passwordValidator,
                                          controller: password,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: SetLocalization.of(context)
                                                  .getTranslateValue("password"),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              icon: Icon(Icons.lock)),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            FadeAnimation(
                                2,
                                Container(
                                    height: 50,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     gradient: LinearGradient(
                                    //         colors: [
                                    //           Color.fromRGBO(143, 148, 251, 1),
                                    //           Color.fromRGBO(143, 148, 251, .6),
                                    //         ]
                                    //     )
                                    // ),
                                    child: Center(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(
                                                  Colors.blue.shade900)),

                                          //edit
                                          onPressed:

                                         login
                                          ,


                                          child: Text(
                                            SetLocalization.of(context)
                                                .getTranslateValue('login'),
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),

                                          //shape: StadiumBorder()
                                          //color: Colors.indigoAccent
                                        ))
                                )
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            FadeAnimation(
                                1.5,
                                Text(
                                    SetLocalization.of(context)
                                        .getTranslateValue("forgot Password?"),
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                )),
                            SizedBox(
                              height:25,
                            ),
                            FadeAnimation(
                                2.5,
                                InkWell(
                                  child:Text(
                                    SetLocalization.of(context)
                                        .getTranslateValue("don't have an account"),
                                    style: TextStyle(
                                        color: Color.fromRGBO(143, 148, 251, 1)),
                                  ),
                                  onTap:(){ Navigator.pushNamed(context, "/CreateAccount");},
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          )

      ),
    );
  }
}
