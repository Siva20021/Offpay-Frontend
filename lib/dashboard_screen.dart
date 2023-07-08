import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:offpay/qrcode.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'HomePageUI.dart';
import 'package:random_avatar/random_avatar.dart';
import 'main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() {
    return DashboardScreenState();
  }
}
class DashboardScreenState extends State<DashboardScreen>{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        title: "OFFPAY",
        home:Scaffold(
          resizeToAvoidBottomInset: false,
          body:Container(
            child: const HomeUI(),
          ),appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFF000046),
          title:const Center(child:Text('offPAY',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Mulish',fontSize: 35.0),)),
          leading: IconButton(
            icon:  email == null ? Icon(Icons.account_circle_outlined,size: 35.0,):randomAvatar('${email}', height: 50, width: 50),
            // call toggle from SlideDrawer to alternate between open and close
            // when pressed menu button
            onPressed: () { SlideDrawer.of(context)!.toggle();},
          ),
        ),
        ));
  }
}