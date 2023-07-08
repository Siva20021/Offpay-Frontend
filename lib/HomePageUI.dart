import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offpay/payment.dart';
import 'package:offpay/qrcode.dart';
import 'package:offpay/scanner.dart';
import 'package:offpay/sms.dart';
import 'package:carbon_icons/carbon_icons.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
        title: "OFFPAY",
    home:Scaffold(
      body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children:[ClipPath(
        clipper: CustomClipPath(),
          child:Container(
            child:Lottie.asset("assets/images/pay.json"),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    colors: [
                      Color(0xFF000046),
                      Color(0xFF1CB5E0),
                    ],
                  )),
          height:300,
      )),
            const SizedBox(height: 0.0,),
             Container(
              child:GridView.count(
                crossAxisCount:2,
                children:  <Widget>[
                  Column(
                      children: [Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 2, color: Colors.green)),
                  child: InkWell(
                    child: Icon(
                      CarbonIcons.qr_code,
                      color: Colors.green,
                      size: 32.0,
                    ),
                    onTap:(){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyQrcode()),
                    );},
                  )
                ),
                  Text("QR CODE",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold))]),
        Column(
          children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.lightBlue)),
                    child: InkWell(
                      child: const Icon(
                        CarbonIcons.scan,
                        color: Colors.blue,
                        size: 32.0,
                      ),
                      onTap:(){Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRViewExample()),
                      );},
                    )
                  ),
        Text("SCAN & PAY",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold))]),
        Column(
          children: [ Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.purple)),
                      child:
                      InkWell(
                        child: const Icon(
                          CarbonIcons.wallet,
                          color: Colors.purple,
                          size: 32.0,
                        ),
                        onTap:(){Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cart()),
                        );},
                      )
                  ),Text("ADD MONEY",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold))]),

                ],
              ),
                height: MediaQuery.of(context).size.height*0.38,
                width: MediaQuery.of(context).size.width*0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),  // radius of 10
                      // green as background color
                )
            )]),
      //bottomSheet: const showSheet(),
    )
    );
  }
  }


class CustomClipPath extends CustomClipper<Path>{
 @override
  Path getClip(Size size){
   double w = size.width;
   double h = size.height;
   final path = Path();
   path.lineTo(0,h);
   path.quadraticBezierTo(w*0.5,h-100,w,h);
   path.lineTo(w,0);
   path.close();
   return path;
 }
 @override
    bool shouldReclip(CustomClipper<Path> oldClipper){
      return false;
    }
}