import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/verify_otp.dart';

import '../constant.dart';

class SignUp extends StatefulWidget {
  static String id = "sign_up";
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? _cNumber;

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cNumber = TextEditingController(text: '7276948182');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          'ITR PRO',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: LimitedBox(
              maxHeight: height * 0.33,
              child: FractionallySizedBox(
                widthFactor: 0.70,
                heightFactor: 1,
                child: Card(
                  child: FlutterLogo(),
                ),

                // Placeholder(),
              ),
            ),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _cNumber,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.trim().length >= 10) {
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  }
                },
                validator: (value) {
                  if (value!.trim().length == 0) {
                    return "Please Enter Mobile Number";
                  }
                  if (value.trim().length > 10 ||
                      value.trim().length < 10 ||
                      value.trim().contains(new RegExp(r'[A-Za-z/@_-]'))) {
                    return "Please Enter Valid Mobile Number";
                  }
                  if (value.trim().length == 10) {
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixText: '+91',
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                  ),
                  hintText: 'Can I have your number?',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.zero,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue,
                ),
              ),
              onPressed: () async {
                // ignore: null_aware_in_condition
                if (_formKey.currentState?.validate() ?? false) {
                  log('form validation successful');
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await SystemChannels.textInput.invokeMethod('TextInput.hide');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyOtp(
                        number: _cNumber?.text,
                      ),
                    ),
                  );
                } else {
                  log('Error');
                }
              },
              child: Container(
                width: width * 0.5,
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: kSignUpTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Text(
                  'Kindly call the below number for query related to account creation',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
