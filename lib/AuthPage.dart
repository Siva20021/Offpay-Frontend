import 'package:flutter/material.dart';
import 'package:offpay/login.dart';
import 'package:offpay/signup.dart';


class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        title: "OFFPAY",
      home: Scaffold(
          resizeToAvoidBottomInset: false,
        body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text(
                "Hello There!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(height: 20,),
              Text("Automatic identity verification which enable you to verify your identity",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/2,
                decoration: const BoxDecoration(
                    image:DecorationImage(image: AssetImage('assets/images/Illustration.png'))
                ),
              ),
              MaterialButton(
                minWidth: double.infinity,
                height:60,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyLogin()),
                  );
                },
                color: Colors.indigoAccent[400],
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(40)
                ),
                  child: const Text("Login",style: TextStyle(
                      fontWeight: FontWeight.w600,fontSize: 20
                  ),
              )
              ),
              const SizedBox(height: 10.0),
              MaterialButton(
                minWidth: double.infinity,
                height:60,
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySignUp()),
                  );
                },
                color: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                ),
                child: const Text("Sign UP",style: TextStyle(
                  fontWeight: FontWeight.w600,fontSize: 20,

                ),),
              ),
            ]
        )
        ]
    )
        )
        )
      )
    );
  }
}