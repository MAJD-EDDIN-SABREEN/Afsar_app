import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:asfar/ui/BookingInfo.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class Booking extends StatefulWidget {
  int tripId;
  int userId;
  Booking(this.tripId,this.userId);

  @override
  State<StatefulWidget> createState() {
    return BookingState(tripId,userId);
  }
}

class BookingState extends State<Booking> {
  TextEditingController adultPassengers = new TextEditingController();
  TextEditingController childPassengers = new TextEditingController();
  int tripId;
  int userId;
  BookingState(this.tripId,this.userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Text("Booking"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/booking.jpg'),
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
                                      image: AssetImage('images/light-1.png'))),
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
                                      image: AssetImage('images/light-2.png'))),
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
                                  "Booking",
                                  style: TextStyle(
                                      color: Colors.black,
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
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "please select number of passengers",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 30),
                                ),
                                Text(
                                  "Adult",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: NumberInputWithIncrementDecrement(
                                      controller: adultPassengers,
                                      min: 1,
                                      max: 3,
                                      initialValue: 1,
                                    )),
                                Text("Children",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: NumberInputWithIncrementDecrement(
                                      controller: childPassengers,
                                      min: 0,
                                      max: 4,
                                    ))
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2.5,
                          Container(
                              height: 50,
                              child: Center(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue.shade900)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BookingInfo(
                                                      int.parse(adultPassengers.text.toString()),
                                                      int.parse( childPassengers.text.toString()),
                                                      "Civil", 0, 0,tripId,userId.toString())));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) =>
                                      //             BookingInfo(
                                      //                 int.parse(adultPassengers.text
                                      //                     .toString()),
                                      //                 int.parse(childPassengers.text
                                      //                     .toString()),
                                      //                 "Civil",0,0)));
                                      // print(adultPassengers.text.toString());
                                    },
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40),
                                    ),
                                  )))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
