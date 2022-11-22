import 'dart:convert';

import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:asfar/Localization/setLocalization.dart';
import 'package:asfar/ui/bookingRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'UserHome.dart';

class BookingInfo extends StatefulWidget {
  int numAdult;
  int numChild;
  int personNumber;
  int childNumber;
  int tripId;
  String type;
  String userId;

  BookingInfo(this.numAdult, this.numChild, this.type, this.personNumber,
      this.childNumber, this.tripId, this.userId);
  @override
  State<StatefulWidget> createState() {
    return BookingInfoState(
        numAdult, numChild, type, personNumber, childNumber, tripId, userId);
  }
}

class BookingInfoState extends State<BookingInfo> {
  int numAdult;
  int numChild;
  int personNumber;
  int childNumber;
  int tripId;
  String type;
  String personType  ;
  static String dropdownValue = 'Civil';
  String nationalNum;
  String passportNum;
  String numSeat = "";
  String userId;
  List passengerId;
  GlobalKey<FormState> formStateBooking = new GlobalKey<FormState>();

  BookingInfoState(this.numAdult, this.numChild, this.type, this.personNumber,
      this.childNumber, this.tripId, this.userId);

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController fatherName = new TextEditingController();
  TextEditingController motherName = new TextEditingController();
  TextEditingController nationalNumber = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  TextEditingController placeOfEnrollment = new TextEditingController();
  TextEditingController registrationNumber = new TextEditingController();
  TextEditingController passportNumber = new TextEditingController();
  List dataTicket1;
  List dataTicket2;
  List dataSeats;
  List tripsStory;
  TextEditingController bags = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateToBooking = DateTime.now();
  List<Widget> seats = new List(52);
  List<Widget> rowSeats = new List(13);

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1910),
      lastDate: DateTime(DateTime
          .now()
          .year + 1),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;

      });
  }

  String firstNameValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue( "first name can't empty  ");
  }

  String lastNameValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("last name can't empty");
  }

  String fatherNameValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("father name can't empty");
  }

  String motherNameValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("mother name can't empty  ");
  }

  String nationalNumberValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("national number can't empty");
    if (val
        .trim()
        .length < 11) return  SetLocalization.of(context)
        .getTranslateValue( "national number can't less than 11");
    if (val
        .trim()
        .length > 11) return  SetLocalization.of(context)
        .getTranslateValue("national number can't more than 11");
  }

  String placeOfEnrollmentValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("place of enrollment can't empty");
  }

  String registrationnumberValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("registration number can't empty  ");
  }

  String passportNumberrValidator(String val) {
    if (val
        .trim()
        .isEmpty) return  SetLocalization.of(context)
        .getTranslateValue("passport number can't empty  ");
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
  Future getDataSeatAvlaible() async {
    var url = 'http://localhost/Asfar/seats.php';
    var data3 = {
      'trip_id': tripId,
    };
    try {
      var responce = await http.post(url, body: json.encode(data3));
      var responcebody = jsonDecode(responce.body);

      if (responcebody != "no")
        return responcebody;
      else
        return [{'no': "no"}];
    }
    catch(e){
      noInternetAlert("No internet connection");
    }
  }
  Future<List> seatNotAvailable( ) async {

    dataSeats = await getDataSeatAvlaible();

    if (dataSeats[0]['no'] != "no") {
      for (int s = 0; s < dataSeats.length; s++) {

        seats[(dataSeats[s]['seatNumber'])-1] =
            TextButton.icon(
                icon: Icon(
                  Icons.event_seat_rounded,
                  color: Colors.red,
                  size: 13,
                ),
                label: Text("${dataSeats[s]['seatNumber']}",style: TextStyle(fontSize: 12),));
      }

    }
    return seats;
  }

  List<Widget> setSeats(int index) {
    //seats = new List(52);

    for (int i = index; i < index + 4; i++) {
      seats[i] = TextButton.icon(

          onPressed: () {
            setState(() {
              numSeat = (i + 1).toString();
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.event_seat_rounded,size: 13,),
          label: Text("${i + 1}",style: TextStyle(fontSize: 12)));
    }
  }

  Future<List> initSeats() async {
    int count = 0;
    for (int j = 0; j < rowSeats.length; j++) {
      setSeats(count);
      count += 4;
    }

    seats=await seatNotAvailable();
    return seats;
  }


  Future<List> drawSeats() async {
    List seats1=await initSeats();

    // seatAvalible();
    int count = 0;

    for (int j = 0; j < rowSeats.length; j++) {
      rowSeats[j] = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      //    Expanded(child: Padding(padding: EdgeInsets.only(top: 30))),
          seats1[count],
          seats1[count + 1],
    //Expanded(child: Padding(padding: EdgeInsets.only(left: 15))),
    Expanded(child:seats1[count + 2]),
    Expanded(child:   seats1[count + 3])

        ],
      );
      count += 4;
    }
    return rowSeats;


  }

  Future selectSeat(BuildContext context) async {
    // seats= setSeats();
    //setSeats(0);

    List seats2;
    seats2=await drawSeats();


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          scrollable: true,
            title: Text(
              'Select seat',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            content:
            SingleChildScrollView(child: ListBody(children: rowSeats)));
      },
    );
  }

  Widget TypeOfPerson(String type) {
    if (type == "Civil") {
      return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(children: [
                TextFormField(
                    validator: firstNameValidator,
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText:  SetLocalization.of(context)
                          .getTranslateValue( 'first name'),
                      hintText:  SetLocalization.of(context)
                          .getTranslateValue('enter your first name'),
                      icon: Icon(Icons.perm_contact_calendar),
                    )),
                TextFormField(
                    validator: lastNameValidator,
                    controller: lastName,
                    decoration: InputDecoration(
                      labelText:  SetLocalization.of(context)
                          .getTranslateValue('last name'),
                      hintText:  SetLocalization.of(context)
                          .getTranslateValue('enter your Last name'),
                      icon: Icon(Icons.perm_contact_calendar),
                      //hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.black,
                      //    labelStyle: TextStyle(color: Colors.black)
                    )),
                TextFormField(
                    validator: fatherNameValidator,
                    controller: fatherName,
                    decoration: InputDecoration(
                      labelText:  SetLocalization.of(context)
                          .getTranslateValue('father name'),
                      hintText:  SetLocalization.of(context)
                          .getTranslateValue('enter your father name'),
                      icon: Icon(Icons.person),
                    )),
                TextFormField(
                    validator: motherNameValidator,
                    controller: motherName,
                    decoration: InputDecoration(
                      labelText:  SetLocalization.of(context)
                          .getTranslateValue('mother name'),
                      hintText:  SetLocalization.of(context)
                          .getTranslateValue('enter your mother name'),
                      icon: Icon(Icons.pregnant_woman),
                    )),
                TextFormField(
                  validator: nationalNumberValidator,
                  controller: nationalNumber,
                  decoration: InputDecoration(
                    labelText: 'National number',
                    hintText: 'Enter your national number',
                    icon: Icon(Icons.assistant_photo),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  validator: placeOfEnrollmentValidator,
                  controller: placeOfEnrollment,
                  decoration: InputDecoration(
                    labelText: 'Place of enrollment',
                    hintText: 'Enter your Place of enrollment',
                    icon: Icon(Icons.location_city),
                  ),
                ),
                TextFormField(
                  validator: registrationnumberValidator,
                  controller: registrationNumber,
                  decoration: InputDecoration(
                    labelText: 'Registration number',
                    hintText: 'Enter your Registration number ',
                    icon: Icon(Icons.format_list_numbered),
                  ),
                ),
                TextField(
                  controller: bags,
                  decoration: InputDecoration(
                    labelText: 'Bags',
                    hintText: 'Enter your bags',
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                  keyboardType: TextInputType.text,
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                   Icon(
                      Icons.event_seat,
                      size: 20,
                      color: Colors.black54,
                    ),

                    Text("seat number :",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
//                    Expanded(child:Text(
//                      numSeat,
//                      style: TextStyle(
//                        color: Colors.black54,
//                        fontStyle: FontStyle.italic,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 20,
//                      ),
//                    )),

                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade900)),
                        child: Text(
                          numSeat,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          selectSeat(context);
                        }),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cake,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("Birthday",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade900)),
                      child: Text(
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
                      onPressed: () {
                        _selectedDate(context);
                      },
                    ),
                  ],
                ),
                FadeAnimation(
                    2.5,
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.blue.shade900)),
                              onPressed: () {
                                onPressNext();
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ))))
              ])));
    }
    else if (type == "Solider") {

      return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(children: [
                TextFormField(
                    validator: firstNameValidator,
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'Enter your first name',
                      icon: Icon(Icons.perm_contact_calendar),
                    )),
                TextFormField(
                    validator: lastNameValidator,
                    controller: lastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      hintText: 'Enter your Last name',
                      icon: Icon(Icons.perm_contact_calendar),
                      //hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.black,
                      //    labelStyle: TextStyle(color: Colors.black)
                    )),
                TextFormField(
                    validator: fatherNameValidator,
                    controller: fatherName,
                    decoration: InputDecoration(
                      labelText: 'Father name',
                      hintText: 'Enter your father name',
                      icon: Icon(Icons.person),
                    )),
                TextFormField(
                    validator: motherNameValidator,
                    controller: motherName,
                    decoration: InputDecoration(
                      labelText: 'Mother name',
                      hintText: 'Enter your mother name',
                      icon: Icon(Icons.pregnant_woman),
                    )),
                TextFormField(
                  validator: placeOfEnrollmentValidator,
                  controller: placeOfEnrollment,
                  decoration: InputDecoration(
                    labelText: 'Place of enrollment',
                    hintText: 'Enter your Place of enrollment',
                    icon: Icon(Icons.location_city),
                  ),
                ),
                TextFormField(
                  validator: registrationnumberValidator,
                  controller: registrationNumber,
                  decoration: InputDecoration(
                    labelText: 'Registration number',
                    hintText: 'Enter your Registration number ',
                    icon: Icon(Icons.format_list_numbered),
                  ),
                ),
                TextField(
                  controller: bags,
                  decoration: InputDecoration(
                    labelText: 'Bags',
                    hintText: 'Enter your bags',
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                  keyboardType: TextInputType.text,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("seat number :",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade900)),
                        child: Text(
                         numSeat,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          selectSeat(context);
                        }),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cake,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("Birthday",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade900)),
                      child:    Text(
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
                      onPressed: () {
                        _selectedDate(context);
                      },
                    ),
                  ],
                ),
                FadeAnimation(
                    2.5,
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.blue.shade900)),
                              onPressed: () {
                                onPressNext();
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ))))
              ])));
    }
    else if (type == "Non_syrian") {
      return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(children: [
                TextFormField(
                    validator: firstNameValidator,
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'Enter your first name',
                      icon: Icon(Icons.perm_contact_calendar),
                    )),
                TextFormField(
                    validator: lastNameValidator,
                    controller: lastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      hintText: 'Enter your Last name',
                      icon: Icon(Icons.perm_contact_calendar),
                      //hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.black,
                      //    labelStyle: TextStyle(color: Colors.black)
                    )),
                TextFormField(
                    validator: fatherNameValidator,
                    controller: fatherName,
                    decoration: InputDecoration(
                      labelText: 'Father name',
                      hintText: 'Enter your father name',
                      icon: Icon(Icons.person),
                    )),
                TextFormField(
                    validator: motherNameValidator,
                    controller: motherName,
                    decoration: InputDecoration(
                      labelText: 'Mother name',
                      hintText: 'Enter your mother name',
                      icon: Icon(Icons.pregnant_woman),
                    )),
                TextFormField(
                  validator: passportNumberrValidator,
                  controller: passportNumber,
                  decoration: InputDecoration(
                    labelText: 'Passport number',
                    hintText: 'Enter your passport number',
                    icon: Icon(Icons.assistant_photo),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("seat number:",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade900)),
                        child: Text(
                          numSeat,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          selectSeat(context);
                        }),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cake,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("Birthday",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade900)),
                      child:  Text(
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
                      onPressed: () {
                        _selectedDate(context);
                      },
                    ),
                  ],
                ),
                FadeAnimation(
                    2.5,
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.blue.shade900)),
                              onPressed: () {
                                onPressNext();
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ))))
              ])));
    }
    else if (type == "child") {
      return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(30),
              child: Column(children: [
                TextFormField(
                    validator: firstNameValidator,
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText: 'First name',
                      hintText: 'Enter your first name',
                      icon: Icon(Icons.perm_contact_calendar),
                    )),
                TextFormField(
                    validator: lastNameValidator,
                    controller: lastName,
                    decoration: InputDecoration(
                      labelText: 'Last name',
                      hintText: 'Enter your Last name',
                      icon: Icon(Icons.perm_contact_calendar),
                      //hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.black,
                      //    labelStyle: TextStyle(color: Colors.black)
                    )),
                TextFormField(
                    validator: fatherNameValidator,
                    controller: fatherName,
                    decoration: InputDecoration(
                      labelText: 'Father name',
                      hintText: 'Enter your father name',
                      icon: Icon(Icons.person),
                    )),
                TextFormField(
                    validator: motherNameValidator,
                    controller: motherName,
                    decoration: InputDecoration(
                      labelText: 'Mother name',
                      hintText: 'Enter your mother name',
                      icon: Icon(Icons.pregnant_woman),
                    )),
                Padding(padding: EdgeInsets.only(top: 20)),
                TextFormField(
                  validator: placeOfEnrollmentValidator,
                  controller: placeOfEnrollment,
                  decoration: InputDecoration(
                    labelText: 'Place of enrollment',
                    hintText: 'Enter your Place of enrollment',
                    icon: Icon(Icons.location_city),
                  ),
                ),
                TextFormField(
                  validator: registrationnumberValidator,
                  controller: registrationNumber,
                  decoration: InputDecoration(
                    labelText: 'Registration number',
                    hintText: 'Enter your Registration number ',
                    icon: Icon(Icons.format_list_numbered),
                  ),
                ),
                TextField(
                  controller: bags,
                  decoration: InputDecoration(
                    labelText: 'Bags',
                    hintText: 'Enter your bags',
                    icon: Icon(Icons.shopping_bag_outlined),
                  ),
                  keyboardType: TextInputType.text,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.event_seat,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("seat number :",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade900)),
                        child: Text(
                          numSeat,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          selectSeat(context);
                        }),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cake,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text("Birthday",
                        style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade900)),
                      child:  Text(
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
                      onPressed: () {
                        _selectedDate(context);
                      },
                    ),
                  ],
                ),
                FadeAnimation(
                    2.5,
                    Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.blue.shade900)),
                              onPressed: () {
                                onPressNext();
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ))))
              ])));
    }
  }

  String person(String type) {
    if (type == "Civil" || type == "Solider" || type == "Non_syrian") {
      // personNumber++;
      return ("person ${personNumber + 1}");
    } else {
      // childNumber++;
      return ("child $childNumber");
    }
  }

  Widget dropDowntype(String type) {
    if (type != "child")
      return DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            type = newValue;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BookingInfo(
                        numAdult,
                        numChild,
                        newValue,
                        personNumber,
                        childNumber,
                        tripId,
                        userId)));
          });

        },
        items: <String>['Civil', 'Solider', 'Non_syrian']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    else
      return Icon(Icons.child_care);
  }

  Future getData1() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {'confirm': 0, 'user_id': userId};
try {
  var responce = await http.post(url, body: json.encode(data3));
  var responcebody = jsonDecode(responce.body);
  if (responcebody != "no")
    return responcebody;
  else
    return [{'no': "no"}];
}
catch(e){
  noInternetAlert("No internet connection");
}
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
    return responcebody;}
    catch(e){
      noInternetAlert("No internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    //setSeats();
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Booking info'),
              backgroundColor: Colors.indigo,
              actions: [
                TextButton(
                    onPressed: () async {
                      tripsStory=await getDataTripsStory();
                      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserHome(userId,tripsStory)), (route) => false);
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    )),
                Icon(
                  Icons.home,
                  semanticLabel: "Home",
                )
              ],
            ),
            body: Form(
              key: formStateBooking,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(person(type)),
                      dropDowntype(type),
                      TypeOfPerson(type)
                    ],
                  ),
                ),
              ),
            )));
  }

  void nationalOrPassportNum(String str) {
    if (str == "Civil") {
      passportNum = "0";
      nationalNum = nationalNumber.text;
    } else if (str == "Non_syrian") {
      nationalNum = "0";
      passportNum = passportNumber.text;
    } else if (str == "Solider") {
      nationalNum = "2";
      passportNum = "0";
    } else if (str == "child") {
      nationalNum = "3";
      passportNum = "0";
    }
  }

  Widget bookingAlert(String response) {
    String msg;
    if (response == "yes")
      msg = "Booking Successfully";
    else
      msg = " Booking Already Exist, Please Try Again ..!";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () async {
                if (numAdult > 1) {
                  personNumber++;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BookingInfo(
                              numAdult,
                              numChild,
                              personType,
                              personNumber,
                              childNumber,
                              tripId,
                              userId)));
                  numAdult--;
                } else if (numAdult == 1 && numChild > 0) {
                  childNumber++;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BookingInfo(
                              numAdult,
                              numChild,
                              "child",
                              personNumber,
                              childNumber,
                              tripId,
                              userId)));
                  numChild--;
                } else {
                  dataTicket1 = await getData1();
                  //dataTicket2=await getData2();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BookingRequest(
                               userId, dataTicket1)),
                          (route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onPressNext() async {
    var formData = formStateBooking.currentState;
    if (formData.validate()) {
      nationalOrPassportNum(type);
      var data = {
        "trip_id": tripId.toString(),
        "firstName": firstName.text,
        "lastName": lastName.text,
        "motherName": motherName.text,
        "fatherName": fatherName.text,
        "birthday": selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString(),
        "placeOfEnrollment": placeOfEnrollment.text,
        "registrationNumber": registrationNumber.text,
        "id_number": nationalNum,
        "seatNumber": numSeat.toString(),
        "bags": bags.text,
        "passportNumber": passportNum,
        "user_app_id": userId
      };
      var url = 'http://localhost/Asfar/booking.php';
try {
  var response = await http.post(url, body: json.encode(data));
  var responsebody = jsonDecode(response.body);

}
catch(e){
  noInternetAlert("No internet connection");
}
      var data1 = {
        "trip_id": tripId.toString(),
        "firstName": firstName.text,
        "lastName": lastName.text,
        "motherName": motherName.text,
        "fatherName": fatherName.text,
        "id_number": nationalNum
      };
      var url1 = 'http://localhost/Asfar/getPassangerId.php';
     try {
       var response1 = await http.post(url1, body: json.encode(data1));
       var responsebody1 = jsonDecode(response1.body);
       passengerId = responsebody1;

     }
catch(e){
  noInternetAlert("No internet connection");
}
      var data2 = {
        "trip_id": tripId.toString(),
        "passenger_id":passengerId[0]['id'],
        "user_id": userId,
        "seatNumber":numSeat.toString(),
        "fatherName": fatherName.text,
        "created_at": selectedDateToBooking.year.toString() +
            "-" +
            selectedDateToBooking.month.toString() +
            "-" +
            selectedDateToBooking.day.toString()
      };

      var url2 = 'http://localhost/Asfar/bookingConfirm.php';
      try {
        var response2 = await http.post(url2, body: json.encode(data2));
       // var responsebody2 = jsonDecode(response2.body);
        bookingAlert("yes");

      }
      catch(e){
        noInternetAlert("No internet connection");
      }
      // else
    }
  }
}
