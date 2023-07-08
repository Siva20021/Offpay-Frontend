import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var options = {
      'key': 'rzp_test_Winb5v7jIudsVb',
      'amount': int.parse(amtController.text)*100,
      'name': prefs.getString('name'),
      'description': 'Adding Money to OffPay Wallet',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId.toString(), timeInSecForIosWeb: 4);

    var url = "https://offpay-production.up.railway.app/users/addBalance";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var re = await http.post(Uri.parse(url), body: {
      "publicId": prefs.getString('publicId'),
      "amount": amtController.text
    });

    print(re.body);

    if(re.statusCode == 200){
      int currBalance = prefs.getInt('balance')!;
      currBalance += int.parse(amtController.text);
      prefs.setInt('balance', currBalance);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message.toString(),
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(), timeInSecForIosWeb: 4);
  }

  TextEditingController amtController = TextEditingController();


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
            body: ListView(
                children: [
                  SizedBox(height: 25,),
                  Text("Enter Amount to Add to Wallet"),
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
                  SizedBox(height: 20.0),
                  InkWell(
                      onTap: () {
                        openCheckout();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 18),
                        child: Center(child:Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(25.0),
                                color: Color(0xFFF17532)),
                            child: Center(
                                child: Text('Checkout',
                                    style: TextStyle(
                                        fontFamily: 'nunito',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))))),
                      ))

                ]
            ),


          ));
        }
  }