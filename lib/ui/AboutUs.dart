import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AboutUs extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AboutUsState();
  }
}

class AboutUsState extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigoAccent,
              title: Text("About Us"),
            ),
            body:SingleChildScrollView(
              scrollDirection: Axis.vertical,
               padding:EdgeInsets.only(left: 10,right: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Container(
                    height: 200,
//width: 220,
//                    color: Colors.red,
  decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("images/asfarLogo.jpg"),
          fit: BoxFit.fill)),
                  )),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Container(
                    //height: 200,
                    color:Colors.black12,
                    //width: ,
                    child:
                    Column(

                      //mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(20)),
                        Text("Asfar International",style: TextStyle(fontSize:40,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.indigo),),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                      Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
                          "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")



                      ],
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}