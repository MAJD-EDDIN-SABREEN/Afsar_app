import 'dart:collection';
import 'dart:convert';
import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:asfar/Localization/setLocalization.dart';
import 'package:asfar/ui/First.dart';
import 'package:asfar/ui/MyAccount.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_inc_dec/number_inc_dec.dart';
import '../main.dart';
import 'Booking.dart';
import 'Tickets.dart';
import 'Trips.dart';
import 'bookingRequest.dart';

class UserHome extends StatefulWidget {
  String userId;
  List tripsStory;
  UserHome(this.userId,this.tripsStory);
  @override
  State<StatefulWidget> createState() {
    return UserHomeState(userId,tripsStory);
  }
}
class UserHomeState extends State<UserHome> {
  String userId;
  FirstState firstState = new FirstState();
  String fromCity = '';
  String toCity = '';
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'filter with';
  TextEditingController fromCityCon=new TextEditingController();
  TextEditingController toCityCon=new TextEditingController();
  TextEditingController adultPassengers=new TextEditingController();
  TextEditingController childPassengers=new TextEditingController();
  List data;
  List tripsStory;
  List dataTicket;
  List dataBookingRe;
  List dataAccount;
  List<Widget> story;
   UserHomeState(this.userId,this.tripsStory);
   @override
 void initState()  {
    createTripsStory();
  }
  String image(String city){
    if (city=="damascus"||city=="دمشق"||city=="Damascus")
      return "images/damascus.jpg";
    if (city=="homs"||city=="حمص"||city=="Homs")
      return "images/homs.jpg";
    if (city=="daraa"||city=="درعا"||city=="Daraa")
      return "images/daraa.jpeg";
    if (city=="latakia"||city=="اللاذقية"||city=="Latakia")
      return "images/latakia.jpg";
    if (city=="tartous"||city=="طرطوس"||city=="Tartous")
      return "images/tartous.jpg";
    if (city=="suwayda"||city=="السويداء"||city=="Suwayda")
      return "images/suwayda.jpg";

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

  void languageDialog() {
    Locale _temp;
    // MyApp.setLocale(context, _temp);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(

            title: Text( SetLocalization.of(context).getTranslateValue('language')),
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
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 10),
      lastDate: DateTime(2060),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  Future  getDataTicket() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {
      'confirm': 1, 'user_id': userId
    };
try{
    var responce = await http.post(url,body: json.encode(data3));
    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return responcebody;
    else
      return [{'no':"no"}];}
   catch(e){
     noInternetAlert("No Internet Connection");
   }
  }
  Future getDataTrips() async {
    var url = 'http://localhost/Asfar/test%201.php';
    var data1={"from":fromCityCon.text,"to":toCityCon.text,"date":selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString()};
    try{
    var responce = await http.post(url,body: data1);
    var responcebody = jsonDecode(responce.body);
    return responcebody;}
    catch(e){
      noInternetAlert("No Internet Connection");
    }
  }
  Future getDataAccount() async {
    var url = 'http://localhost/Asfar/phoneNumber.php';
    var data3 = {
      'id':int.parse(userId)
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
      noInternetAlert("No Internet Connection");
    }
  }
  void createTripsStory(){
     story=new List(tripsStory.length);
    for(int i=0;i<tripsStory.length;i++)
      story[i] =Container(
        color:Colors.black12,
          width: 150,
          height: 150,
          margin: EdgeInsets.all(15),

          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//      makeItem(
//          image: 'images/damascus.jpg',
//          title: 'to :' +'${tripsStory[i]['toCity']}'
//
//      ),
                Container(
                  height:60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image(tripsStory[i]['toCity'])),
                          fit: BoxFit.fill)),
                ),

                Text('From :' +'${tripsStory[i]['fromCity']}'),
                Text('to :' +'${tripsStory[i]['toCity']}'),
        Text('Date :' +'${tripsStory[i]['dateTrip']}'),
    ElevatedButton(
      onPressed: (){showMoreInfo(context,tripsStory[i]['fromCity'],i);},
          style: ButtonStyle(

              shape:MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()) ,
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade900)),
          child: Text(
            "see more",
            style: TextStyle(color: Colors.white),
          ),
        )

      ]));
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
     noInternetAlert("No Internet Connection");
   }
   }
  
  Future  getData1BookinRe() async {
    var url = 'http://localhost/Asfar/tickets2.php';
    var data3 = {
      'confirm': 0, 'user_id': userId
    };
try{
    var responce = await http.post(url,body: json.encode(data3));

    var responcebody = jsonDecode(responce.body);
    if(responcebody!="no")
      return responcebody;
    else
      return [{'no':"no"}];

  }catch(e){
  noInternetAlert("No Internet Connection");
  }
   }

  Future showMoreInfo(BuildContext context, String value,int pos) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${tripsStory[pos]['toCity']}',style: TextStyle(color:Colors.black,fontSize: 30),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(image(tripsStory[pos]['toCity'])),
                Text('From: ${tripsStory[pos]['fromCity']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('To : ${tripsStory[pos]['toCity']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Date: ${tripsStory[pos]['dateTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Time:${tripsStory[pos]['timeTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Starting station:${tripsStory[pos]['startingStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Stop station:${tripsStory[pos]['stopStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Parking station:${tripsStory[pos]['parkingStation']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Duration of trip:${tripsStory[pos]['durationOfTrip']}',style: TextStyle(color:Colors.black,fontSize: 20),),
                Text('Cost of trip:${tripsStory[pos]['costOfTrip']} sp',style: TextStyle(color:Colors.black,fontSize: 20),)

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('booking'),
              onPressed: () {
                //  print(userHomeState.adultPassengers.text.toString());

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Booking(
                                int.parse(tripsStory[pos]['id'].toString()),int.parse(userId))));

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
              backgroundColor: Colors.indigoAccent,
              title: Text("Asfar"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/First', (route) => false);
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    )),
                Icon(
                  Icons.person,
                  semanticLabel: "logout",
                )
              ],
            ),
            body: SingleChildScrollView(
                padding: EdgeInsets.only(top: 20),
                child: Column(children: [

                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Trips",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                      fontSize: 20),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                1.4,
                                Container(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,

                                    children:story
//                                    <Widget>[
//                                      //for(int m=0;i<3;i++)
//                                      makeItem(
//                                          image: 'images/damascus.jpg',
//                                          title: 'Damascus'),
//                                      makeItem(
//                                          image: 'images/damascus.jpg',
//                                          title: 'Aleppo'),
//                                      makeItem(
//                                          image: 'images/damascus.jpg',
//                                          title: 'Daraa'),
//                                      makeItem(
//                                          image: 'images/damascus.jpg',
//                                          title: 'United States')
                                  //  ],
                                  ),
                                )),
                          ])),
                  FadeAnimation(
                      1.8,Container(
                      padding: EdgeInsets.all(25),
                      child: Column(children: [
                        DropDownField(
                            controller: fromCityCon,
                            value: fromCity,
                            strict: true,
                            hintText: 'Select city ',
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
                            strict: true,
                            hintText: 'Select city ',
                            labelText: SetLocalization.of(context)
                                .getTranslateValue('to :'),
                            icon: Icon(Icons.add_location_alt),
                            items: cities,
                            setter: (dynamic newValue) {
                              toCity = newValue;
                            }),
                        Padding(padding: EdgeInsets.only(top: 30)),
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
                        Container(
                          padding: EdgeInsets.only(left: 70, right: 70),
                          // padding: EdgeInsets.all(15),

                          child: NumberInputWithIncrementDecrement(
                            controller: adultPassengers,
                            min: 1,
                            max: 3,
                            numberFieldDecoration: InputDecoration(
                                counterText:  SetLocalization.of(context)
                                    .getTranslateValue("Adult"),
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
                                  counterText:  SetLocalization.of(context)
                                      .getTranslateValue("Children"),
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
                            Text( SetLocalization.of(context)
                                .getTranslateValue("date"),
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
                                  style:TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),  onPressed: () {
                              _selectedDate(context);}
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        // DropdownButton<String>(
                        //
                        //   value: dropdownValue,
                        //   icon: const Icon(Icons.arrow_downward),
                        //   iconSize: 24,
                        //   elevation: 16,
                        //   style: const TextStyle(color: Colors.deepPurple),
                        //   underline: Container(
                        //     height: 2,
                        //     color: Colors.deepPurpleAccent,
                        //   ),
                        //   onChanged: (String newValue) {
                        //     setState(() {
                        //       dropdownValue = newValue;
                        //     });
                        //   },
                        //   items: <String>['filter with','Time', 'Price', 'Number of sets']
                        //       .map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        // ),
                        Center(
                          child: RaisedButton(
                            child: Text(
                              SetLocalization.of(context)
                                  .getTranslateValue('search'),
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue.shade900,
                            onPressed: () async {
                              data = await getDataTrips();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Trips("user",data,int.parse(adultPassengers.text.toString()),int.parse(childPassengers.text.toString()),userId)));
                            },
                            shape: StadiumBorder(),
                          ),
                        ),
                      ]))),

                ])),

            // ]
            //    )
            //  ),
//
            drawer: Drawer(
              
              child: Container(
                  color: Colors.indigoAccent.shade400,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 30),
                  
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //padding:  EdgeInsets.only(top: 30),
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () async {

                                tripsStory=await getDataTripsStory();
                                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserHome(userId,tripsStory)), (route) => false);
                              },
                              child: Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_box,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () async {

                                dataAccount=await getDataAccount();
                                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyAccount(dataAccount)), (route) => true);
                              },
                              child: Text(
                                "My account",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                      //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.airplane_ticket,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () async {
                                dataTicket=await getDataTicket();
                                //datatick1=await getData2();
                                Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Tickets(dataTicket,userId)), (route) => true);
                              },
                              child: Text(
                                "My ticket",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.border_color,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () async {
                                dataBookingRe=await getData1BookinRe();
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BookingRequest( userId, dataBookingRe)), (
                                    route) => true);
                              },
                              child: Text(
                                "My booking request",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () {
                                languageDialog();
                              },
                              child: Text(
                                "Language",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.web,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/CreateAccount');
                              },
                              child: Text(
                                "Visit website",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.only(right: 20)),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/AboutUs');
                              },
                              child: Text(
                                "About us",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ))
                        ],
                      ),
                    ],
                  )
                //
              ),
            )));
  }

  Widget makeItem({image, title}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image:
            DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.2),
              ])),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
