import 'dart:convert';

import 'package:asfar/Animation/FadeAnimation.dart';
import 'package:asfar/Localization/setLocalization.dart';
import 'package:asfar/ui/First.dart';
import 'package:asfar/ui/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  FirstState firstPage = new FirstState();
  TextEditingController mobileNumber=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController confirmPassword=new TextEditingController();
  GlobalKey<FormState>formStateSignup=new GlobalKey<FormState>();
   List dataUserId;
   List dataTripsStory;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController fatherName = new TextEditingController();
  TextEditingController motherName = new TextEditingController();
  TextEditingController nationalNumber = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  TextEditingController placeOfEnrollment = new TextEditingController();
  TextEditingController registrationNumber = new TextEditingController();
  TextEditingController passportNumber = new TextEditingController();

  String mobileValidator(String val){
    if (val.trim().isEmpty)
      return SetLocalization.of(context)
          .getTranslateValue("phone number can't empty");
    //"Phone number can't empty";
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
          .getTranslateValue("password can't more than 12");

  }
  String confirmPasswordValidator(String val){
    if (val.trim().isEmpty)
      return SetLocalization.of(context)
          .getTranslateValue("confirm password can't empty");

    if(confirmPassword.text!=password.text)
      return  SetLocalization.of(context)
          .getTranslateValue("confirm password should be equal password");

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

  Future  getUserId() async {
    var url = 'http://localhost/Asfar/userAppId.php';
    var data2 = {
      'mobile':mobileNumber.text,
    };
    try{
    var responce = await http.post(url,body: json.encode(data2));
    var responcebody = jsonDecode(responce.body);
    print(responcebody);
    return responcebody;}
    catch(e)
    {
      noInternetAlert("No Internet Connection");
    }
  }
  Future getDataTripsStory() async {
    var url = 'http://localhost/Asfar/tripsStory.php';
    var data2 = {

      "dateTrip": selectedDate1.year.toString() +
          "-" +
          selectedDate1.month.toString() +
          "-" +
          (selectedDate1.day+1).toString()
    };
try {
  var responce = await http.post(url, body: json.encode(data2));
  var responcebody = jsonDecode(responce.body);
  return responcebody;
}
catch(e){
  noInternetAlert("No Internet Connection");
}
  }
  Future<Widget>signUpAlert(String response) async {
    String msg;
    if (response=="yes") {
      msg = SetLocalization.of(context)
          .getTranslateValue("sign up Successfully");
      dataUserId=await getUserId();
      dataTripsStory=await getDataTripsStory();
    }else
      msg=SetLocalization.of(context)
          .getTranslateValue("phone number Already Exist, Please Try Again With New  phone number..!");

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

                if (response=="yes") {
                  print(response);
                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserHome(dataUserId[0]['id'].toString(),dataTripsStory)), (route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void signUp() async{
    var formData=formStateSignup.currentState;
    if(formData.validate()) {
      formData.save();
      var data={"mobile" : mobileNumber.text ,"password":password.text.hashCode,"firstname":firstName.text,"lastname":lastName.text,"mothername":motherName.text,"fathername":fatherName.text,"birthday":selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString(),"placeOfEnrollment":placeOfEnrollment.text,"registrationNumber":registrationNumber.text};
      var url='http://localhost/Asfar/sign.php';
      try{
      var response = await http.post(url, body: json.encode(data));
      var responsebody = jsonDecode(response.body);

      if(response.statusCode==200){
        if(responsebody=="yes") {
          signUpAlert(responsebody);

        }
        else
          signUpAlert(responsebody);
      }


    }
    catch(e)
    {
      noInternetAlert("No Internet Connection");
    }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              title: Text(SetLocalization.of(context)
                  .getTranslateValue("sign up")),
            ),
            body:Form(
                key:formStateSignup ,
                child:SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/mobile_phone.jpg'),
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
                                              .getTranslateValue("sign up"),
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
                                        Center(
                                          child: Text("Account Information",style: TextStyle(color: Colors.indigo),),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey.shade100))),
                                          child: TextFormField(
                                            controller: mobileNumber,
                                            validator:mobileValidator,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: SetLocalization.of(context)
                                                  .getTranslateValue("phone number"),
                                              labelText:  SetLocalization.of(context)
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
                                            controller: password,
                                            validator:passwordValidator ,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: SetLocalization.of(context)
                                                    .getTranslateValue("password"),
                                                labelText:  SetLocalization.of(context)
                                                    .getTranslateValue("password"),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                icon: Icon(Icons.lock)),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: confirmPassword,
                                            validator:confirmPasswordValidator,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: SetLocalization.of(context)
                                                    .getTranslateValue("confirm password"),
                                                labelText:  SetLocalization.of(context)
                                                    .getTranslateValue("confirm password"),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[400]),
                                                icon: Icon(Icons.lock)),
                                          ),



                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
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
                                      Center(
                                        child: Text("Personal Information",style: TextStyle(color: Colors.indigo),),
                                      ),
                                      TextFormField(
                                          validator: firstNameValidator,
                                          controller: firstName,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                            labelText:  SetLocalization.of(context)
                                                .getTranslateValue( 'first name'),
                                            hintText:  SetLocalization.of(context)
                                                .getTranslateValue('enter your first name'),
                                            icon: Icon(Icons.perm_contact_calendar),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])
                                          )),
                                      TextFormField(
                                          validator: lastNameValidator,
                                          controller: lastName,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                            labelText:  SetLocalization.of(context)
                                                .getTranslateValue('last name'),
                                            hintText:  SetLocalization.of(context)
                                                .getTranslateValue('enter your Last name'),
                                            icon: Icon(Icons.perm_contact_calendar),
                                            //hintStyle: TextStyle(color: Colors.black),
                                            fillColor: Colors.black,
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])
                                            //    labelStyle: TextStyle(color: Colors.black)
                                          )),
                                      TextFormField(
                                          validator: fatherNameValidator,
                                          controller: fatherName,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                            labelText:  SetLocalization.of(context)
                                                .getTranslateValue('father name'),
                                            hintText:  SetLocalization.of(context)
                                                .getTranslateValue('enter your father name'),
                                            icon: Icon(Icons.person),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])
                                          )),
                                      TextFormField(
                                          validator: motherNameValidator,
                                          controller: motherName,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                            labelText:  SetLocalization.of(context)
                                                .getTranslateValue('mother name'),
                                            hintText:  SetLocalization.of(context)
                                                .getTranslateValue('enter your mother name'),
                                            icon: Icon(Icons.pregnant_woman),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])
                                          )),

                                      TextFormField(
                                        validator: placeOfEnrollmentValidator,
                                        controller: placeOfEnrollment,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                          labelText: 'Place of enrollment',
                                          hintText: 'Enter your Place of enrollment',
                                          icon: Icon(Icons.location_city),
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])
                                        ),
                                      ),
                                      TextFormField(
                                        validator: registrationnumberValidator,
                                        controller: registrationNumber,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                          labelText: 'Registration number',
                                          hintText: 'Enter your Registration number ',
                                          icon: Icon(Icons.format_list_numbered),
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])
                                        ),
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
                                ],),
                                      SizedBox(
                                        height: 10,
                                      ),

                                    ],
                                  ),
                                )),



                              FadeAnimation(
                                  2,
                                  Container(
                                      height: 50,

                                      child: Center(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(
                                                    Colors.blue.shade900)),
                                            onPressed:signUp,
                                            child: Text(
                                              SetLocalization.of(context)
                                                  .getTranslateValue('sign up'),

                                              style: TextStyle(
                                                  color: Colors.white, //fontSize: 40)
                                                 ),
                                            ),

                                            //shape: StadiumBorder()
                                            //color: Colors.indigoAccent
                                          )))),
                              SizedBox(
                                height: 70,
                              ),
                              // FadeAnimation(
                              //     1.5,
                              //     Text(
                              //       "Forgot Password?",
                              //       style: TextStyle(
                              //           color: Color.fromRGBO(143, 148, 251, 1)),
                              //     )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
        ));








    // Container(
    //   margin: EdgeInsets.all(30),
    //   child: ListView(
    //     children: [
    //       TextField(
    //           decoration: InputDecoration(
    //             labelText: 'User name',
    //             hintText: '',
    //             icon: Icon(Icons.perm_contact_calendar),
    //           )),
    //       TextField(
    //           obscureText: true,
    //           decoration: InputDecoration(
    //             labelText: 'Password',
    //             hintText: '',
    //             icon: Icon(Icons.lock),
    //           )),
    //       TextField(
    //           obscureText: true,
    //           decoration: InputDecoration(
    //             labelText: 'Confirm password',
    //             hintText: '',
    //             icon: Icon(Icons.lock),
    //           )),
    //       Container(
    //         child:RaisedButton(onPressed:(){Navigator.pushNamedAndRemoveUntil(context,'/UserHome', (route) =>false);},
    //           child: Text("Sign in",style: TextStyle(color: Colors.white),),
    //           shape: StadiumBorder(),
    //           color: Colors.indigoAccent,
    //         ),
    //         margin: EdgeInsets.only(top:20,right:70,left:70),
    //       )














    //   TextField(
    //       decoration: InputDecoration(
    //     labelText: 'First name',
    //     hintText: 'Enter your first name',
    //     icon: Icon(Icons.perm_contact_calendar),
    //   )),
    //   TextField(
    //       decoration: InputDecoration(
    //     labelText: 'Last name',
    //     hintText: 'Enter your Last name',
    //     icon: Icon(Icons.perm_contact_calendar),
    //   )),
    //   TextField(
    //       decoration: InputDecoration(
    //     labelText: 'Father name',
    //     hintText: 'Enter your father name',
    //     icon: Icon(Icons.person),
    //   )),
    //   TextField(
    //       decoration: InputDecoration(
    //     labelText: 'Mother name',
    //     hintText: 'Enter your mother name',
    //     icon: Icon(Icons.pregnant_woman),
    //   )),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'National number',
    //       hintText: 'Enter your national number',
    //       icon: Icon(Icons.assistant_photo),
    //     ),
    //     keyboardType: TextInputType.number,
    //   ),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'Birthday',
    //       hintText: 'Enter your birthday',
    //       icon: Icon(Icons.cake),
    //     ),
    //     keyboardType: TextInputType.datetime,
    //   ),
    //   TextField(
    //       decoration: InputDecoration(
    //     labelText: 'Birth place',
    //     hintText: 'Enter your birth place',
    //     icon: Icon(Icons.location_city),
    //   )),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'مكان القيد',
    //       hintText: '',
    //       icon: Icon(Icons.location_city),
    //     ),
    //   ),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'رقم الخانة',
    //       hintText: '',
    //       icon: Icon(Icons.format_list_numbered),
    //     ),
    //   ),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'phone',
    //       hintText: '',
    //       icon: Icon(Icons.phone),
    //     ),
    //     keyboardType: TextInputType.phone,
    //   ),
    //   TextField(
    //     decoration: InputDecoration(
    //       labelText: 'Email',
    //       hintText: '',
    //       icon: Icon(Icons.email),
    //     ),
    //     keyboardType: TextInputType.emailAddress,
    //   ),
    //   Container(
    //     child: RaisedButton(
    //       onPressed: () {
    //         Navigator.pushNamed(context, '/CreateAccount2');
    //       },
    //       child: Text(
    //         "next",
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       shape: StadiumBorder(),
    //       color: Colors.indigoAccent,
    //     ),
    //     margin: EdgeInsets.only(top: 20, right: 70, left: 70),
    //   )
    //
    //      ],
    //   ),
    // ),
//      bottomNavigationBar: BottomNavigationBar(
//        items: [
//          BottomNavigationBarItem(
//            title: Text("Sign in"),
//            icon: Icon(Icons.account_box),
//          ),
//          BottomNavigationBarItem(
//              title: Text("Login"), icon: Icon(Icons.person)),
//          BottomNavigationBarItem(
//              title: Text("Language"), icon: Icon(Icons.language)),
//          BottomNavigationBarItem(
//              title: Text("More"), icon: Icon(Icons.announcement))
//        ],
//
//        //fixedColor: Colors.white,
//        type: BottomNavigationBarType.fixed,
//        backgroundColor: Colors.indigo,
//        onTap: navigationBottom,
//        fixedColor: Colors.white,
//        unselectedItemColor: Colors.white,
//      ),

  }
}
