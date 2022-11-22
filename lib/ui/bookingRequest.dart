import 'dart:convert';

import 'package:asfar/Localization/setLocalization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Tickets.dart';
import 'UserHome.dart';
class BookingRequest extends StatefulWidget {
  //String tripId;
  String userId;
  List data1;

  BookingRequest(this.userId,this.data1);
  @override
  State<StatefulWidget> createState() {
    return BookingRequestState(userId,data1);
  }
}

class BookingRequestState extends State<BookingRequest> {
  //String tripId;
  String userId;
  List data1;
  List data2;
  List data6;
  List datatick1;
  List datatick2;
  List tripsStory;
  List dataCancelBooking;
  List dataRefresh;
  DateTime selectedDate = DateTime.now();
  BookingRequestState(this.userId,this.data1);

  Future  getDataTrip(int tripId) async {
    var url = 'http://localhost/Asfar/tickets.php';
    var data4 = {
      'trip_id':tripId
    };
    var responce = await http.post(url,body: json.encode(data4));
    var responcebody = jsonDecode(responce.body);
    return responcebody;
  }
  Future  getDataPassanger(int passngerId) async {
    var url = 'http://localhost/Asfar/getDataPassanger.php';
    var data5 = {
      'passenger_id':passngerId
    };
    var responce = await http.post(url,body: json.encode(data5));
    var responcebody = jsonDecode(responce.body);
    return responcebody;
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

    var responce = await http.post(url, body: json.encode(data2));
    var responcebody = jsonDecode(responce.body);
    return responcebody;
  }
  Future getDataRefresh() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {'confirm': 0, 'user_id': userId};

      var responce = await http.post(url, body: json.encode(data3));
      var responcebody = jsonDecode(responce.body);
      if (responcebody != "no")
        return responcebody;
      else
        return [{'no': "no"}];

  }
  Future<void> requestOrTicket(int num) async {
    if (num==1) {
      datatick1=await getData1();
      //datatick1=await getData2();
      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
          builder: (BuildContext context) =>
              Tickets(datatick1,userId)), (route) => false);
    }
  }
  Future  getData1() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {
      'confirm': 1, 'user_id': userId
    };

    var responce = await http.post(url,body: json.encode(data3));
    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return responcebody;
    else
      return [{'no':"no"}];
  }

  Future    cancelBooking(int id) async {
    var url = 'http://localhost/Asfar/cancelBooking.php';
    var data3 = {
      'id':id,

    };

    var responce = await http.post(url,body: json.encode(data3));
    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return [{'yes':"yes"}];
    else
      return [{'no':"no"}];
  }

  Widget cancelBookingAlert(String response) {
    String msg=response;

    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
      TextButton(
      child: new Text("OK"),
        onPressed: () async {
          dataRefresh=await getDataRefresh();
          Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookingRequest (userId,dataRefresh)), (route) => false);
        },
          )
          ]);});}
   void onPressCancelBooking (int id) async{
    dataCancelBooking=await cancelBooking(id);
    if (dataCancelBooking[0]['yes']=="yes")
       cancelBookingAlert("cancel Booking sucessfuly");
    else
      cancelBookingAlert("cancel Booking faild");

   }
  Future showMoreInfo(BuildContext context,int pos) async {
    data2=await getDataTrip(data1[pos]["trip_id"]);
    //print(data1[pos]["passenger_id"]);
    data6=await getDataPassanger(data1[pos]["passenger_id"]);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking request"),
          content: SingleChildScrollView(
              child: Container(
                  color: Colors.blueGrey
                  ,child:Center(
                  child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding:EdgeInsets.only(top: 15)),
                        Text("Name :${data6[0]['firstName']}  ${data6[0]['lastName']}"),
                        Padding(padding:EdgeInsets.only(top: 15)),
                        Text("From :${data2[0]['fromCity']}"),
                        Padding(padding:EdgeInsets.only(top: 15)),
                        Text("To :${data2[0]['toCity']}"),
                        Padding(padding:EdgeInsets.only(top: 15)),
                        Text("Date :${data2[0]['dateTrip']}"),
                        Padding(padding:EdgeInsets.only(top: 15)),
                        Text("Time :${data2[0]['timeTrip']}"),
                        Padding(padding:EdgeInsets.only(top: 15)),
                      ]))
              )),
          actions: <Widget>[

            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel Booking request'),
              onPressed: () {
                onPressCancelBooking(data1[pos]["id"]);
              },
            ),
          ],
        );
      },
    );
  }
Widget bookingReList()
{
  if(data1[0]['no']!='no')
    {
      return ListView.builder(
          itemCount: data1.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int postion) {
            return ListTile(
              title: Text("Date of booking : ${data1[postion]['created_at']} "),
              //subtitle: Text("Father Name :${data1[postion]['fatherName']}"),
              leading: CircleAvatar(
                child: Text("${postion+1}"),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onTap: () {
                showMoreInfo(context,postion);
              },
            );
          });
    }
  else
    return Center(
      child: Text("No booking request found"),
    );

}
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Booking request'),
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
          body:bookingReList()

          ,   bottomNavigationBar:
        BottomNavigationBar(

          items: [
            BottomNavigationBarItem(
              title: Text(
                  "Booking request"),
              icon: Icon(Icons.border_color),
            ),
            BottomNavigationBarItem(
                title: Text(
                    "Tickets"),
                icon: Icon(Icons.sticky_note_2)),

          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.indigo.shade400,
          onTap:requestOrTicket,
          //navigationBottom,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
        ));
  }
}
