import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offpay/HomePageUI.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OFFPAY",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => (HomeUI())),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                )),
          ),
          body: Center(child: Lottie.asset("assets/images/payment.json"))),
    );
  }
}
