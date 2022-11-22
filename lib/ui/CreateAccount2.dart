import 'package:flutter/material.dart';
class CreateAccount2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateAccount2State();
  }
}

class CreateAccount2State extends State<CreateAccount2> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent,
            title: Text("Create account"),
          ),
          body:Container(
            margin: EdgeInsets.all(30),
            child: ListView(
              children: [
//                SizedBox(
//                  child: Image.asset('images/signIn.jpg'),
//                  height: 200,
//                  // width: 200
//                ),
                TextField(
                    decoration: InputDecoration(
                      labelText: 'User name',
                      hintText: '',
                      icon: Icon(Icons.perm_contact_calendar),
                    )),
                TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: '',
                      icon: Icon(Icons.lock),
                    )),
                TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      hintText: '',
                      icon: Icon(Icons.lock),
                    )),
                Container(
                  child:RaisedButton(onPressed:(){Navigator.pushNamedAndRemoveUntil(context,'/UserHome', (route) =>false);},
                    child: Text("Sign in",style: TextStyle(color: Colors.white),),
                    shape: StadiumBorder(),
                    color: Colors.indigoAccent,
                  ),
                  margin: EdgeInsets.only(top:20,right:70,left:70),
                )
              ],
            ),
          ) ,
        )
    );
  }
}