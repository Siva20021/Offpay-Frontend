import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:offpay/HomePageUI.dart';
import 'login.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  SignupPage createState() {
    return SignupPage();
  }
}

class SignupPage extends State<MySignUp> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void Signup() async {
    var url = Uri.parse('https://offpay-production.up.railway.app/register');
    print({
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "password": passController.text,
      "pin" : pinController.text
    });
    var response = await http.post(url, body: {
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "password": passController.text,
      "pin" : pinController.text
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var res = jsonDecode(response.body);
    print(res["publicId"]);
    //Save to prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('publicId', res["publicId"]);
    prefs.setString('email', emailController.text);
    prefs.setString('name', nameController.text);
    prefs.setString('phone', phoneController.text);
    prefs.setString('privateToken', pinController.text);
    prefs.setInt('balance', 0);


    StatusCode = response.statusCode;
    BodyMsg = response.body;
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //         const DashboardScreen.DashboardScreen()));
    if (StatusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: 'Successfully Login',
        btnOkText: 'Confirm',
        btnOkIcon: Icons.verified,
        dismissOnTouchOutside: false,
      ).show();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeUI()),
      );
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: '$BodyMsg',
        btnOkText: 'Try Again',
        btnOkIcon: Icons.arrow_back_ios,
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          return null;
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: "OFFPAY",
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: null,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          'assets/images/signup.json', // Replace with the relative path to your Lottie animation file
                          width: screenSize.width,
                          height: screenSize.height * 0.5,
                        ),
                        Container(
                          width: double.infinity,
                          height: 700,
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
                                    'Signup',
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
                                    'Enter your details',
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
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                onFieldSubmitted: (value) {
                                                  // Validator
                                                },
                                                validator: (value) {
                                                  if (value != null &&
                                                      value.isEmpty) {
                                                    return 'Enter a valid Name!';
                                                  }
                                                  return null;
                                                },
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Name",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.blue,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  errorStyle: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  10), // Add some spacing between the containers
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 4,
                                                onFieldSubmitted: (value) {},
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter a valid pincode';
                                                  }
                                                  return null;
                                                },
                                                controller: pinController,
                                                obscureText: true,
                                                onChanged: (value) {
                                                  // Update the suffix text whenever the text changes
                                                  setState(() {});
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Pincode",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade400),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  errorStyle: TextStyle(
                                                      color: Colors.red),

                                                  counterText:
                                                      '', // Remove the default counter text
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                                          keyboardType: TextInputType.number,
                                          maxLength: 10,
                                          onFieldSubmitted: (value) {},
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter a valid mobile Number';
                                            }
                                            return null;
                                          },
                                          controller: phoneController,
                                          onChanged: (value) {
                                            // Update the suffix text whenever the text changes
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Phone Number",
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
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  right:
                                                      8.0), // Adjust the padding as needed
                                              child: Icon(Icons.phone),
                                            ),
                                            prefixText: '+91 | ',
                                            counterText: '',
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
                                            Text("Already have an account? ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    fontFamily: 'Mulish')),
                                            InkWell(
                                                child: Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Mulish',
                                                      color: Colors.white,
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
                                                Signup();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget makeInput({label, obsureText = false, inputtype, maxval = null}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        keyboardType: inputtype,
        obscureText: obsureText,
        maxLength: maxval,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600)),
        ),
      ),
      SizedBox(
        height: 30,
      )
    ],
  );
}
