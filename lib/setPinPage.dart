import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPinPage extends StatefulWidget {
  final Function() callback;

  SetPinPage({required this.callback});

  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  String pin = '';

  void _appendNumber(int number) {
    setState(() {
      pin += number.toString();
    });
  }

  void _deleteNumber() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  void _clearPin() {
    setState(() {
      pin = '';
    });
  }

  void submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString('privateToken')!;
    if (res == pin) {
      widget.callback();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed'),
            content: Text('Invalid PIN. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(height: 60.0),
                    Image.asset(
                      'assets/images/appstore.png', // Replace with the actual path to your app logo image
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      'Enter your 6-digit pin',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'sivaramakrishnan@gmail.com',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _buildPinCodeIndicator(),
                  ],
                ),
              ),
            ),
          ),
          _buildNumberPad(), // Add the _buildNumberPad container here
        ],
      ),
    );
  }

  Widget _buildPinCodeIndicator() {
    return Container(
      height: null,
      width: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) => Container(
            height:
                30.0, // Adjust the height of the container as per your design
            width: 30.0, // Adjust the width of the container as per your design
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    Colors.grey, // Adjust the outline color as per your design
                width: 2.0, // Adjust the outline width as per your design
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.all(0), // Adjust the padding as per your design
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pin.length > index ? Colors.grey : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    double screenHeight = MediaQuery.of(context).size.height;
    double numberPadHeight =
        screenHeight * 0.5; // Adjust the percentage as desired

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: numberPadHeight,
        // Set the desired background color here
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumberButton(1),
                _buildNumberButton(2),
                _buildNumberButton(3),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumberButton(4),
                _buildNumberButton(5),
                _buildNumberButton(6),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumberButton(7),
                _buildNumberButton(8),
                _buildNumberButton(9),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTickButton(),
                _buildNumberButton(0),
                _buildDeleteButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    return GestureDetector(
      onTap: () => _appendNumber(number),
      child: Container(
        height: 64.0,
        width: 64.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Mulish',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _deleteNumber,
      child: Container(
        height: 64.0,
        width: 64.0,
        child: Icon(
          Icons.backspace,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTickButton() {
    return GestureDetector(
      onTap: submit,
      child: Container(
        height: 64.0,
        width: 64.0,
        child: Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: SetPinPage(),
//   ));
// }
