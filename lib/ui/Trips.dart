import 'dart:convert';

import 'package:asfar/ui/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookingInfo.dart';
import 'Login.dart';
class Trips extends StatefulWidget {
  String searchType;
  List data;
  int numAdult;
  int numChild;
  String userId;
  Trips(this.searchType,this.data,this.numAdult,this.numChild,this.userId);
  @override
  State<StatefulWidget> createState() {
    return TripsState(searchType,data,numAdult,numChild,userId);
  }
}
class TripsState extends State<Trips> {
 String searchType;
  List data;
   int numAdult;
   int numChild;
   String userId;
   List tripsStory;
 DateTime selectedDate = DateTime.now();
  TripsState(this.searchType,this.data,this.numAdult,this.numChild,this.userId);
  UserHomeState userHomeState;
  String image(String city){
    if (city=="damascus"||city=="دمشق")
      return "images/damascus.jpg";
    if (city=="homs"||city=="حمص")
      return "images/homs.jpg";
    if (city=="daraa"||city=="درعا")
      return "images/daraa.jpeg";
    if (city=="latakia"||city=="اللاذقية")
      return "images/latakia.jpg";
    if (city=="tartous"||city=="طرطوس")
      return "images/tartous.jpg";
    if (city=="suwayda"||city=="السويداء")
      return "images/suwayda.jpg";

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
  Future showMoreInfo(BuildContext context, String value,int pos) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${data[pos]['toCity']}',style: TextStyle(color:Colors.black,fontSize: 30),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(image(data[pos]['toCity'])),
                Text('From: ${data[pos]['fromCity']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('To : ${data[pos]['toCity']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Date: ${data[pos]['dateTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Time:${data[pos]['timeTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Starting station:${data[pos]['startingStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Stop station:${data[pos]['stopStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Parking station:${data[pos]['parkingStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Duration of trip:${data[pos]['durationOfTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Cost of trip:${data[pos]['costOfTrip']} sp',style: TextStyle(color:Colors.black,fontSize: 20),)

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('booking'),
              onPressed: () {
                //  print(userHomeState.adultPassengers.text.toString());

                if(searchType=="user") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BookingInfo(
                                  numAdult,
                                  numChild,
                                  "Civil", 0, 0,int.parse(data[pos]['id']),userId)));
                }
                else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Login("Trips", data,numAdult,numChild,int.parse(data[pos]['id']))));
                }
                // print(userHomeState.adultPassengers.text.toString());
                //Navigator.pushNamed(context, '/Booking');
                //bookingDialog();
              },
            ),
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
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trips"),
          backgroundColor: Colors.indigo,
          actions: [
            TextButton(


                onPressed: () async {
                  if(searchType=='user')
                   { tripsStory=await getDataTripsStory();
                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserHome(userId,tripsStory)), (route) => false);}
                  else
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/First', (route) => false);

                },
                child: Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                )

            ),
            Icon(
              Icons.home,
              semanticLabel: "Home",
            )


          ],
        ),
        //backgroundColor: Colors.lime,
        body:  ListView.builder(
            shrinkWrap: true,
            itemCount:data.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int postion) {
              return
                Container(
                  padding: EdgeInsets.only(left: 10, top: 20,bottom: 10),
                  // width: 50,
                  color: Colors.black12,
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                        children: [
                          Container(
                            height: 150,
                            width:140,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(image(data[postion]['toCity'])),
                                    fit: BoxFit.fill)),
                          ),
//                          SizedBox(
//                              child: Image.asset(image(data[postion]['toCity'])),
//                              height: 150,
//                              width:150
//
//                          ),
                          Padding(padding: EdgeInsets.only(left:20)),
                          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [ Text('From :${data[postion]['fromCity']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                )),
                              Padding(padding: EdgeInsets.only(top:10)),
                              Text('To :${data[postion]['toCity']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  )),
                              Padding(padding: EdgeInsets.only(top:10)),
                              Text('Date :${data[postion]['dateTrip']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  )),
                              Padding(padding: EdgeInsets.only(top:10)),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(
                                  'Time:${data[postion]['timeTrip']}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                  )),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              ElevatedButton(
                                onPressed: () {showMoreInfo(context,data[postion]['fromCity'],postion);},
                                style: ButtonStyle(
                                    shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.blue.shade900)),
                                child: Text(
                                  "see more",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              // typeSearch(searchType,postion)
                            ],)

                        ]),
                  ),

                );}),
      ),
    );
  }

// Widget typeSearch(String type,int pos)
// {
//   if(type=="user")
//     return  ElevatedButton(
//       onPressed: () {showMoreInfo(context,data[pos]['fromCity'],pos);},
//       style: ButtonStyle(
//           shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
//           backgroundColor: MaterialStateProperty.all<Color>(
//               Colors.blue.shade900)),
//       child: Text(
//         "see more",
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   else
//     return  ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     Login("Trips", data,numAdult,numChild)));
//         },
//       style: ButtonStyle(
//           shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
//           backgroundColor: MaterialStateProperty.all<Color>(
//               Colors.blue.shade900)),
//       child: Text(
//         "login",
//         style: TextStyle(color: Colors.white),
//       ),
//     );
// }
}
