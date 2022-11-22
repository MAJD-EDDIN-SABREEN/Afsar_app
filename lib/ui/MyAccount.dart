import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  List dataAccount;
  MyAccount(this.dataAccount);
  @override
  State<StatefulWidget> createState() {
    return MyAccountState(dataAccount);
  }
}

class MyAccountState extends State<MyAccount> {
  List dataAccount;
  MyAccountState(this.dataAccount);
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigoAccent,
              title: Text("My Account"),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              // padding:EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Container(
                    height: 200,
//width: 220,
//color: Colors.red,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/person.png"),
                            fit: BoxFit.fill)),
                  )),
                  Padding(padding: EdgeInsets.only(bottom: 50)),
                  Container(
                    // height: 200,
                    //color: Colors.black12,
                    //width: ,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(20)),
                        Text(
                          "Phone number : ${dataAccount[0]["mobile"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Name : ${dataAccount[0]["firstname"]}  ${dataAccount[0]["lastname"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Father name : ${dataAccount[0]["fathername"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Mother name : ${dataAccount[0]["mothername"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Birthday : ${dataAccount[0]["birthday"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Place Of Enrollment : ${dataAccount[0]["placeOfEnrollment"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          "Registration Number : ${dataAccount[0]["registrationNumber"]}",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 40)),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue.shade900)),
                          // onPressed:signUp,
                          child: Text("change password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 40)),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue.shade900)),
                          // onPressed:signUp,
                          child: Text("change phone Number",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 40))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
