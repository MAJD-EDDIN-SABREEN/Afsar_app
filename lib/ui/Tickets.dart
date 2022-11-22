import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'UserHome.dart';
import 'bookingRequest.dart';
class Tickets extends StatefulWidget {
  //String tripId;
  String userId;
  List data1;

  Tickets(this.data1,this.userId);
  @override
  State<StatefulWidget> createState() {
    return TicketsState(data1,userId);
  }
}
class TicketsState extends State<Tickets> {
  //String tripId;
  String userId;
  List data1;
  List data2;
  List data6;
  List dataForBookingRe;
  List tripsStory;
  DateTime selectedDate = DateTime.now();
 TicketsState(this.data1,this.userId);
  Future  getData2(int tripId) async {
    var url = 'http://localhost/Asfar/tickets.php';
    var data4 = {
      'trip_id':tripId
    };
    var responce = await http.post(url,body: json.encode(data4));
    var responcebody = jsonDecode(responce.body);
    return responcebody;
  }
  Future  getData1Refresh() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {
      'confirm':1, 'user_id': userId
    };

    var responce = await http.post(url,body: json.encode(data3));
    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return responcebody;
    else
      return [{'no':"no"}];
  }
  Future  getData1BookinRe() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {
      'confirm': 0, 'user_id': userId
    };

    var responce = await http.post(url,body: json.encode(data3));

    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return responcebody;
    else
      return [{'no':"no"}];

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

  Future<void> requestOrTicket(int num) async {
    if (num==0) {
      dataForBookingRe=await getData1BookinRe();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (BuildContext context) =>
              BookingRequest( userId, dataForBookingRe)), (
          route) => false);
    }
    else
    {
      data1=await getData1Refresh();
      Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
          builder: (BuildContext context) =>
              Tickets(data1,userId)), (route) => false);
    }
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
  Future showMoreInfo(BuildContext context,int pos) async {
    data2=await getData2(data1[pos]['trip_id']);
    data6=await getDataPassanger(data1[pos]["passenger_id"]);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ticket"),
          content: SingleChildScrollView(
              child: Container(
                  decoration:BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/background.png'),
                          fit: BoxFit.fill)),
                  //color: Colors.blueGrey
                  child:Center(
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
                            SizedBox(
                                width: 50,
                                height: 50,
                                child:Image.asset("images/asfarLogo.jpg"))
                          ]))
              )),
          actions: <Widget>[

            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Widget ticketList()
  {
  if(data1[0]['no']!="no")
    return ListView.builder(
        shrinkWrap: true,
        itemCount:data1.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int postion) {
          return
            Container(
              padding: EdgeInsets.only(left:20, top: 20),
              child:  SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: [
                      SizedBox(
                          child:Icon(Icons.sticky_note_2,size: 25,),
                          height: 200

                      ),
                      Padding(padding: EdgeInsets.only(left:20)),
                      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [ Text('date of Ticket :${data1[postion]['created_at']}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            )),

                          Padding(padding: EdgeInsets.only(top:15)),
                          ElevatedButton(
                            onPressed: () {
                              showMoreInfo(context,postion);},
                            style: ButtonStyle(
                                shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.blue.shade900)),
                            child: Text(
                              "see Ticket",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          // typeSearch(searchType,postion)
                        ],)

                    ]),
              ),

            );}
    );
  else
    return Center(
        child:Text("No Tickets Found")
    );

  }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tickets'),
            backgroundColor: Colors.indigo,
            actions: [
              TextButton(
                  onPressed: () async {
                    data1=await getData1Refresh();
                    Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Tickets(data1,userId)), (route) => false);
                  },
                  child: Text(
                    "Refresh",
                    style: TextStyle(color: Colors.white),
                  )
              ),
              Icon(
                Icons.refresh,
                semanticLabel: "refresh",
              ),
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
          body:ticketList()
          ,
          bottomNavigationBar:
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