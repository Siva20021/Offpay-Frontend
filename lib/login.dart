import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offpay/dashboard_screen.dart' as DashboardScreen;
import 'package:offpay/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dashboard_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

var StatusCode;
var BodyMsg;

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyLogin> {
  final formGlobalKey = GlobalKey < FormState > ();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void SendCom() async{
    var url = Uri.parse('https://offpay-backend.herokuapp.com/users/login');
    var response = await http.post(url, body: {"loginEmail":emailController.text,
      "loginPass":passController.text
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    StatusCode = response.statusCode;
    BodyMsg = response.body;
    if(StatusCode != 200){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: 'Successfully Login',
        btnOkText:'Confirm',
        btnOkIcon:Icons.verified,
        dismissOnTouchOutside:false,
        btnOkOnPress: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', emailController.text);
          //Navigator.of(context).pop(); //to be used later after completion
          Navigator
              .of(context)
              .pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardScreen.DashboardScreen())
          );
        },
      ).show();
    }
    else{
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: '$BodyMsg',
          btnOkText:'Try Again',
          btnOkIcon:Icons.arrow_back_ios,
          dismissOnTouchOutside:false,
        btnOkOnPress: () {
         return null;
        },
      ).show();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:
        IconButton( onPressed: (){
          Navigator.pop(context);
        },icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
      body: SafeArea(
    child:SingleChildScrollView(
    child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Column(
                  children: [
                  const Text ("Login", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20,),
                    Text("Welcome back ! Login with your credentials",style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),),
                    SizedBox(height: 30,)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40
                  ),
                  child: Column(
                    children: [
                      Form(
                          key: formGlobalKey,
                      child: Column(
                          children: [
                            TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (value) {
                                  //Validator
                                },
                                validator: (value) {
                                  if ((value != null && value.isEmpty) ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!)) {
                                    return 'Enter a valid email!';
                                  }
                                  return null;
                                },
                          controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter email address",
                                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade400)
                                ),
                              ),),
                      const SizedBox(height: 20.0,),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (value) {},
                          validator: (value) {
                            if ((value != null && value.isEmpty)) {
                              return 'Enter a valid password!';
                            }
                            return null;
                          },
                        controller: passController,
                        obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade400)
                            ),
                          )),
                      SizedBox(height: 50,)
                       ]) )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border:const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black)
                        )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height:60,
                      onPressed: () {
                        final isValid = formGlobalKey.currentState?.validate();
                        if (isValid!) {
                          SendCom();
                        }
                        formGlobalKey.currentState?.save();
                      },
                      color: Colors.indigoAccent[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                      child: const Text("Login",style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white70
                      ),),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("Dont have an account?"),
                    InkWell(child:Text("Sign Up",style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),onTap:(){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MySignUp()),
                );})
                  ],
                )
              ],

            ),
          ],
        ),
      ),
        ))));
  }
}