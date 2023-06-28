import 'dart:convert';

import 'package:lottie/lottie.dart';
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
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void SendCom() async {
    var url =
        Uri.parse('https://offpay-production.up.railway.app/loginWithEmail');
    var response = await http.post(url, body: {
      "loginEmail": emailController.text,
      "loginPass": passController.text
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    StatusCode = response.statusCode;
    BodyMsg = response.body;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            const DashboardScreen.DashboardScreen()));
    // if (StatusCode != 200) {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.SUCCES,
    //     animType: AnimType.SCALE,
    //     title: 'Successfully Login',
    //     btnOkText: 'Confirm',
    //     btnOkIcon: Icons.verified,
    //     dismissOnTouchOutside: false,
    //     btnOkOnPress: () async {
    //       SharedPreferences prefs = await SharedPreferences.getInstance();
    //       prefs.setString('email', emailController.text);
    //       //Navigator.of(context).pop(); //to be used later after completion

    //     },
    //   ).show();
    // } else {
    //   AwesomeDialog(
    //     context: context,
    //     dialogType: DialogType.ERROR,
    //     animType: AnimType.SCALE,
    //     title: '$BodyMsg',
    //     btnOkText: 'Try Again',
    //     btnOkIcon: Icons.arrow_back_ios,
    //     dismissOnTouchOutside: false,
    //     btnOkOnPress: () {
    //       return null;
    //     },
    //   ).show();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
        title: "OFFPAY",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  )),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Container(
                height: null,
                width: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Lottie.asset(
                          'assets/images/signup.json', // Replace with the relative path to your Lottie animation file
                          width: screenSize.width,
                          height: screenSize.height * 0.5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 600,
                          color: Colors.blue,
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Mulish',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Form(
                                  key: formGlobalKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onFieldSubmitted: (value) {},
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return 'Enter an email address!';
                                            }
                                            // Regular expression pattern to validate email addresses
                                            String pattern =
                                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                                            RegExp regex = RegExp(pattern);
                                            if (!regex.hasMatch(value!)) {
                                              return 'Enter a valid email address!';
                                            }
                                            return null;
                                          },
                                          // Use a separate controller for the email field
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            hintText: "Enter Email",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          onFieldSubmitted: (value) {},
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return 'Enter a valid password!';
                                            }
                                            return null;
                                          },
                                          controller: passController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: "Enter Password",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 10),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade400),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            errorStyle:
                                                TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Already have an account? "),
                                            InkWell(
                                                child: Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyLogin()),
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: MaterialButton(
                                            minWidth: double.infinity,
                                            height: 60,
                                            onPressed: () {
                                              final isValid = formGlobalKey
                                                  .currentState
                                                  ?.validate();
                                              // print(isValid);
                                              if (isValid!) {
                                                // Perform sign up action
                                                SendCom();
                                              }
                                              formGlobalKey.currentState
                                                  ?.save();
                                            },
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))));
  }
}
