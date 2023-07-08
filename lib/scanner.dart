import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offpay/sms.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 300 ||
        MediaQuery.of(context).size.height < 300)
        ? 150.0
        : 300.0;
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
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 50,
                  borderWidth: 10,
                  cutOutSize: scanArea),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      try{
        var res = jsonDecode(scanData.code!);
        if(res["phone"]!="" && res["publicId"]!="" && res["name"]!=""){
          print("True");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ( Smsset(phone:res["phone"],publicId:res["publicId"],name:res["name"]))),
          );
        }
      } catch(err){
        print(err);
      }

    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

//(Text(
//                 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'))