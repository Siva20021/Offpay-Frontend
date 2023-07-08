import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

var code;

class MyQrcode extends StatefulWidget {
  const MyQrcode({

    Key? key
  }) : super(key: key);

  @override
  Qrcode createState() {
    return Qrcode();
  }
}

class Qrcode extends State<MyQrcode> {
  Uint8List? _imagefile;

  late String phone = "";
  late String publicId = "";
  late String name = "";




  @override
  void initState() {
   super.initState();
   print("Started Here");
   getSharedPrefs();
   print("$phone $publicId $name");
  }

  void getSharedPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('phone')!;
      publicId = prefs.getString('publicId')!;
      name = prefs.getString('name')!;
    });
  }


  void ScreenShot() async{



    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((image) async {
      if (image != null) {
        setState(() {
          _imagefile = image;
          //print(image);
        });

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);
        /// Share Plugin
        await Share.shareFiles([imagePath.path],text: "Use OFFPAY for offline Payments 😀");

      }
    }).catchError((onError) {
      print(onError);
    });

  }
  ScreenshotController screenshotController = ScreenshotController();

  Widget build(BuildContext context) {
    Map<String,dynamic>jsonData={
      'phone':phone,
      'publicId':publicId,
      'name':name
    };
    String jsonString=jsonEncode(jsonData);
    return MaterialApp(
        title: "OFFPAY",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        //backgroundColor: Colors.grey,
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading:
            IconButton( onPressed: (){
              Navigator.pop(context);
            },icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
          ),
          body: Screenshot(controller: screenshotController,
              child:Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Center (child:randomAvatar('${email}', height: 80, width: 80)),
              SizedBox(height: 25.0,),
              Container(
              child:Text("Scan QR to Receive Money",textAlign: TextAlign.center,style: TextStyle(color:Colors.blue, fontSize: 20,fontWeight: FontWeight.bold),)
            ),SizedBox(height: 15.0,),
            QrImage(
              backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
              data: jsonString, //User Id
              version: QrVersions.auto,
              size: 250.0,
              ),SizedBox(height: 15.0,),TextButton(
                  style:TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    onSurface: Colors.grey,
                  ),
                  onPressed: () {
                  ScreenShot();
                  },
                  child: Text("$phone $name $publicId")
              )],
          ))),
        )
    );
  }
}