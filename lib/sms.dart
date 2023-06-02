import 'package:background_sms/background_sms.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offpay/afterPay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:offpay/main.dart';



class Smsset extends StatefulWidget {
 final Barcode? text;
  const Smsset({Key ?key, required this.text}) : super(key: key);
  @override
  SendSmsState createState() {

    return SendSmsState();
  }
}

class SendSmsState extends State<Smsset> {

  final formGlobalKey = GlobalKey < FormState > ();
  TextEditingController amtController = TextEditingController();
  TextEditingController sendController = TextEditingController();
  TextEditingController recvController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController pinController = TextEditingController();

    String recipents = "+917049382846";

    void SendData(Barcode? text) async{
      var barcodedata = text!.code;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.getString('email');
      print(barcodedata);
      print(email);
      print(amtController.text);
      print(pinController.text);
      print(descController.text);

      var arrdata = ['reciever:${barcodedata}\nsender:${email}\namount:${amtController.text}\npincode:${pinController.text}\ndescription:${descController.text}'];
      print(arrdata);
      var stringList = arrdata.join(" ");
      print(stringList);
      _sendSMS(stringList, recipents);
    }

    void _sendSMS(String message, String recipents) async {
      bool result = await BackgroundSms.isSupportCustomSim as bool;
      if (result) {
        print("Support Custom Sim Slot");
        SmsStatus result = await BackgroundSms.sendMessage(
            phoneNumber: recipents, message: message, simSlot: 1);
        if (result == SmsStatus.sent) {
          print("Sent");
        } else {
          print("Failed");
        }
      } else {
        print("Not Support Custom Sim Slot");
        SmsStatus result = await BackgroundSms.sendMessage(
            phoneNumber: recipents, message: message);
        if (result == SmsStatus.sent) {
          print("Sent");
        } else {
          print("Failed");
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "OFFPAY",
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home:Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:
        IconButton( onPressed: (){
          Navigator.pop(context);
        },icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
      body: SingleChildScrollView(
          child:Column(
          children: [
    Form(
    key: formGlobalKey,
    child: Column(
    children: [
            SizedBox(height: 25.0,),
            Align(child:Text("Enter Amount",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),alignment: Alignment.center,),
            Padding(padding:EdgeInsets.only(left: 15.0, right: 15.0,top:10.0,bottom: 10.0),
            child:TextFormField(
              controller: amtController,
              keyboardType:TextInputType.number,
              obscureText: false,
              maxLength: null,
              onFieldSubmitted: (value) {},
              validator: (value) {
                if ((value != null && value.isEmpty)) {
                  return 'Enter a Amount';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Enter Amount to send",
                contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 50),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)
                ),
              ),
            )),
            Align(child:Text("Enter PIN CODE",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),alignment: Alignment.center,),
            Padding(padding:EdgeInsets.only(left: 15.0, right: 15.0,top:10.0,bottom: 10.0),
                child:TextFormField(
                  controller: pinController,
                  keyboardType:TextInputType.number,
                  obscureText: false,
                  maxLength: 4,
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if ((value != null && value.isEmpty)) {
                      return 'Enter a Pincode';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Pincode",
                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 50),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                  ),
                )),
            Align(child:Text("Payment Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),alignment: Alignment.center,),
            Padding(padding:EdgeInsets.only(left: 15.0, right: 15.0,top:10.0,bottom: 10.0),
                child:TextFormField(
                  controller: descController,
                  keyboardType:TextInputType.text,
                  obscureText: false,
                  maxLength: null,
                  onFieldSubmitted: (value) {},
                  validator: (value) {
                    if ((value != null && value.isEmpty)) {
                      return 'Enter a description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 50),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                  ),
                )),
            SizedBox(height: 20.0,),
            Center (
                child:Container(
          child: SizedBox(
            height: 50,
            width: 150,
            child:
          TextButton(
            style:TextButton.styleFrom(
              shape: StadiumBorder(),

              primary: Colors.white,
              backgroundColor: Colors.teal,
              onSurface: Colors.grey,
            ),
              onPressed: () {
              final isValid = formGlobalKey.currentState?.validate();
              if (isValid!) {
                SendData(widget.text);
                Navigator
                    .of(context)
                    .pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Success())
                );
              }
              formGlobalKey.currentState?.save();
              },
              child: const Text("Send")
          )),
    ))
          ]),
      )])))
    );
  }
}