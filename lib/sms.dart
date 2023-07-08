import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:offpay/setPinPage.dart';
import 'package:offpay/afterPay.dart';

class Smsset extends StatefulWidget {
  final String phone;
  final String publicId;
  final String name;

  const Smsset(
      {Key? key,
      required this.phone,
      required this.publicId,
      required this.name})
      : super(key: key);

  @override
  SendSmsState createState() {
    return SendSmsState();
  }
}

class SendSmsState extends State<Smsset> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController amtController = TextEditingController();
  TextEditingController sendController = TextEditingController();
  TextEditingController recvController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.publicId);
    print(widget.name);
  }

  String recipients = "+91 7978069951";

  void transaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://offpay-production.up.railway.app/users/transaction";

    var response = await http.post(Uri.parse(url), body: {
      "From": prefs.getString('publicId'),
      "Body":
          "${widget.publicId},${prefs.getString('publicId')},${amtController.text}"
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {

      int currBalance = prefs.getInt('balance')!;
      currBalance += int.parse(amtController.text);
      prefs.setInt('balance', currBalance);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Success(),
        ),
      );
    } else {
      print("Failed");
    }
  }

  void SendData(Barcode? text) async {
    print(text);
    if (text != null) {
      var barcodeData = text.code;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      print(barcodeData);
      print(email);
      print(amtController.text);
      print(pinController.text);
      print(descController.text);

      var arrData = [
        'receiver: $barcodeData\nsender: $email\namount: ${amtController.text}\npincode: ${pinController.text}\ndescription: ${descController.text}'
      ];
      print(arrData);
      var stringList = arrData.join(" ");
      print(stringList);
      _sendSMS(stringList, recipients);
    } else {
      // Handle the case when `text` is null.
      print(null);
      // You can show an error message or take appropriate action.
    }
  }

  void _sendSMS(String message, String recipients) async {
    // Check if the SEND_SMS permission is granted
    PermissionStatus status = await Permission.sms.status;
    if (!status.isGranted) {
      // Permission is not granted, request it
      status = await Permission.sms.request();
      if (!status.isGranted) {
        // Permission denied by the user
        print('SMS permission denied');
        return;
      }
    }

    bool result = await BackgroundSms.isSupportCustomSim as bool;
    if (result) {
      print("Support Custom Sim Slot");
      SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: recipients, message: message, simSlot: 1);
      if (result == SmsStatus.sent) {
        print("Sent");
      } else {
        print("Failed");
      }
    } else {
      print("Not Support Custom Sim Slot");
      SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: recipients, message: message);
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
      home: Scaffold(
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
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25.0),
                    Text(
                      'TO',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TTNormsPro',
                          color: Colors.grey[600]),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Paying ${widget.name.toUpperCase()}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'TTNormsPro',
                          color: Colors.grey[900]),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '${widget.phone}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'TTNormsPro',
                          color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16.0),

                    // TextFormField(
                    //   controller: recipientController,
                    //   keyboardType: TextInputType.text,
                    //   decoration: InputDecoration(
                    //     hintText: 'Enter recipient name',
                    //   ),
                    //   validator: (value) {
                    //     if (value?.isEmpty ?? true) {
                    //       return 'Recipient name is required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 16.0),

                    Center(
                      child: IntrinsicWidth(
                        child: Container(
                          child: TextFormField(
                            controller: amtController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefix: Text('₹ ',
                                  style: TextStyle(
                                      fontSize:
                                          40)), // Add Rupee symbol as prefix
                              hintText: '0',
                              hintStyle: TextStyle(
                                  fontSize:
                                      40), // Increase font size to make it appear bigger
                              contentPadding: EdgeInsets.all(
                                  16), // Increase padding to make it appear bigger
                            ),
                            style: TextStyle(fontSize: 40),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Amount is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey, // Set gray background color
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)), // Set rounded edges
                      ),
                      child: IntrinsicWidth(
                        child: Padding(
                          padding:
                              EdgeInsets.all(10), // Add padding for spacing
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add spacing between text and TextFormField
                              TextFormField(
                                controller: descController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove the border
                                  hintText: 'Add a Note',
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .white), // Set white hint text color
                                ),
                                style: TextStyle(
                                    color: Colors
                                        .white), // Set white input text color
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Description is required';
                                  }
                                  return null;
                                },
                              ),
                              // Add spacing below the TextFormField
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formGlobalKey.currentState?.validate() ==
                                true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SetPinPage(callback: transaction),
                                ),
                              );
                              // Form is valid, proceed with sending money
                              // Add your logic here
                            }
                          },
                          child: Text('Send'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              //   Form(
              //     key: formGlobalKey,
              //     child: Column(
              //       children: [
              //         SizedBox(
              //           height: 25.0,
              //         ),
              //         Align(
              //           child: Text(
              //             "Enter Amount",
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           alignment: Alignment.center,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(
              //             left: 15.0,
              //             right: 15.0,
              //             top: 10.0,
              //             bottom: 10.0,
              //           ),
              //           child: TextFormField(
              //             controller: amtController,
              //             keyboardType: TextInputType.number,
              //             obscureText: false,
              //             maxLength: null,
              //             onFieldSubmitted: (value) {},
              //             validator: (value) {
              //               if (value?.isEmpty ?? true) {
              //                 return 'Enter an Amount';
              //               }
              //               return null;
              //             },
              //             decoration: InputDecoration(
              //               hintText: "Enter Amount to send",
              //               contentPadding: EdgeInsets.symmetric(
              //                 vertical: 5,
              //                 horizontal: 50,
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //               border: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Align(
              //           child: Text(
              //             "Enter PIN CODE",
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           alignment: Alignment.center,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(
              //             left: 15.0,
              //             right: 15.0,
              //             top: 10.0,
              //             bottom: 10.0,
              //           ),
              //           child: TextFormField(
              //             controller: pinController,
              //             keyboardType: TextInputType.number,
              //             obscureText: false,
              //             maxLength: 4,
              //             onFieldSubmitted: (value) {},
              //             validator: (value) {
              //               if (value?.isEmpty ?? true) {
              //                 return 'Enter a Pincode';
              //               }
              //               return null;
              //             },
              //             decoration: InputDecoration(
              //               hintText: "Enter Pincode",
              //               contentPadding: EdgeInsets.symmetric(
              //                 vertical: 5,
              //                 horizontal: 50,
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //               border: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Align(
              //           child: Text(
              //             "Payment Description",
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           alignment: Alignment.center,
              //         ),
              //         Padding(
              //           padding: EdgeInsets.only(
              //             left: 15.0,
              //             right: 15.0,
              //             top: 10.0,
              //             bottom: 10.0,
              //           ),
              //           child: TextFormField(
              //             controller: descController,
              //             keyboardType: TextInputType.text,
              //             obscureText: false,
              //             maxLength: null,
              //             onFieldSubmitted: (value) {},
              //             validator: (value) {
              //               if (value?.isEmpty ?? true) {
              //                 return 'Enter a description';
              //               }
              //               return null;
              //             },
              //             decoration: InputDecoration(
              //               hintText: "Enter description",
              //               contentPadding: EdgeInsets.symmetric(
              //                 vertical: 5,
              //                 horizontal: 50,
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //               border: OutlineInputBorder(
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           height: 20.0,
              //         ),
              //         Center(
              //           child: Container(
              //             child: SizedBox(
              //               height: 50,
              //               width: 150,
              //               child: TextButton(
              //                 style: TextButton.styleFrom(
              //                   shape: StadiumBorder(),
              //                   primary: Colors.white,
              //                   backgroundColor: Colors.teal,
              //                   onSurface: Colors.grey,
              //                 ),
              //                 onPressed: () {
              //                   final isValid =
              //                       formGlobalKey.currentState?.validate();
              //                   SendData(Barcode("dummy", BarcodeFormat.unknown,
              //                       [])); // Pass a dummy Barcode value
              //                   Navigator.of(context).pushReplacement(
              //                     MaterialPageRoute(
              //                       builder: (BuildContext context) =>
              //                           const Success(),
              //                     ),
              //                   );

              //                   formGlobalKey.currentState?.save();
              //                 },
              //                 child: const Text("Send"),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
