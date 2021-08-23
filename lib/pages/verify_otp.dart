import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itrpro/app_url.dart';
import 'package:itrpro/pages/sign_up.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../main.dart';
import '../url.dart';
import 'landing_page.dart';
import 'package:http/http.dart' as http;

class VerifyOtp extends StatefulWidget {
  final number;
  VerifyOtp({this.number});
  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool isCodeSent = false;
  String? verificationCode,
      bankId,
      bankName,
      role,
      panId,
      mobileNumber,
      mainBankId,
      userTokenStatus,
      _code,
      signature = "{{ app signature }}";

  Future<void> sendCode(String number) async {
    if (number.trim().contains('1234567890')) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('You have joined as a tester'),
            content: Text(
              'Enter 3231 as a otp to progress further, note: you will be shown dummy data',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'close',
                ),
              ),
            ],
          ),
        );
      });
    }
    try {
      var response =
          await http.get(Uri.parse(AppUrl.SEND_OTP + number), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        dev.log("the data is " + data.toString(), name: 'In send otp verify');

        if (data['status']
            .toString()
            .trim()
            .toLowerCase()
            .contains("not registered")) {
          // Toast.show(
          //   "You are not registered please register",
          //   context,
          //   duration: Toast.LENGTH_LONG,
          //   gravity: Toast.BOTTOM,
          //   textColor: Colors.redAccent,
          // );
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            borderSide: BorderSide(color: Colors.red, width: 2),
            width: 310,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
            headerAnimationLoop: false,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Sign In Failed',
            desc: 'You are not registered, Kindly register first.',
            showCloseIcon: false,
            btnCancelText: 'Cancel',
            btnCancelColor: Colors.red,
            btnCancelOnPress: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignUp.id,
                (route) => false,
              );
            },
            btnOkColor: Colors.green,
            btnOkText: 'Register',
            btnOkOnPress: () {},
          )..show();

          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => AlertDialog(
          //     title: Center(
          //       child: Text('Login Failed'),
          //     ),
          //     content: Text('You are not registered, Kindly register.'),
          //     actions: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushNamedAndRemoveUntil(
          //             context,
          //             SignUp.id,
          //             (route) => false,
          //           );
          //         },
          //         child: Text('Back'),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushNamedAndRemoveUntil(
          //             context,
          //             Register.id,
          //             (route) => false,
          //           );
          //         },
          //         child: Text('Register'),
          //       ),
          //     ],
          //   ),
          // );

        } else
        // if (data['already_present_status']
        //     .toString()
        //     .trim()
        //     .toLowerCase()
        //     .contains("yes")
        //     )
        {
          role = data['role'] ?? 'No Data';
          bankId = data['bank_id'] ?? 'No Data';
          bankName = data['bank_name'] ?? 'No Data';
          mobileNumber = data['mobile_number'] ?? 'No Data';
          panId = data['pan_id'] ?? 'No Data';
          // prefs.setBool("is_sub_org", hajeriLevel.contains("Hajeri-Head-1"));

          // dev.log(data.toString());
          setState(() {
            verificationCode =
                number.contains('1234567890') ? '3231' : data['id'].toString();

            isCodeSent = true;

            // otpcode = verificationCode;
          });
        }
      } else {
        dev.log(
          '''Could't fetch otp''',
        );
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text('Server Error')),
                content: SvgPicture.asset(
                  'assets/vectors/server_down.svg',
                  width: 150,
                  height: 150,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Back',
                    ),
                  ),
                ],
              );
            });
      }
    } on SocketException catch (e) {
      dev.log(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text('no internet')),
              content: SvgPicture.asset(
                'assets/vectors/no_signal.svg',
                width: 150,
                height: 150,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Back',
                  ),
                ),
              ],
            );
          });
    } on Exception catch (e) {
      dev.log(e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text('error occurred')),
              content: SvgPicture.asset(
                'assets/vectors/notify.svg',
                width: 150,
                height: 150,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Back',
                  ),
                ),
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    // dev.debugger();
    SmsAutoFill().listenForCode;
    sendCode(widget.number);
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  setUserToken() async {
    try {
      var response = await http.post(Uri.parse(
          '$kSaveToken${prefs?.getString('worker_id')}/${prefs?.getString('mobile')}?userfirebasetoken=${prefs?.getString('token')}'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        dev.log('token ${data.toString()}');
        return "success";
      } else {
        return "server issue";
      }
    } on SocketException catch (e) {
      return "no internet";
    } catch (e) {
      return "error occurred";
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var bottomInset = mediaQuery.viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Positioned(
                top: mediaQuery.size.height * 0.08,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Enter verification code',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: mediaQuery.size.width - 50,
                        child: Text(
                          'A 4-digit OTP verification code has been sent on your phone number. Enter to verify your details.',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '+91 ${widget.number}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Change',
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '4-digit verification Code',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery.size.width * 0.65 - 50,
                        child: PinFieldAutoFill(
                          autoFocus: true,
                          codeLength: 4,
                          decoration: UnderlineDecoration(
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.black),
                            colorBuilder: FixedColorBuilder(Colors.blue[800]!),
                          ),
                          currentCode: _code,
                          onCodeSubmitted: (code) {
                            // if (code.length == 4) {
                            //   if (code.compareTo(verificationCode) == 0) {
                            //     prefs.setString(
                            //         "mobile", widget.number.toString());
                            //     prefs.setString("worker_id", workerId);
                            //     prefs.setString("org_id", orgId);
                            //     prefs.setString("org_name", orgName);
                            //     prefs.setString("emp_name", empName);
                            //     prefs.setBool("login", true);
                            //     prefs.setString("role", role);
                            //     Navigator.pushNamed(
                            //       context,
                            //       Landing.id,
                            //     );
                            //   } else {
                            //     Toast.show(
                            //       "Not the proper code".toLowerCase(),
                            //       context,
                            //       duration: Toast.LENGTH_LONG,
                            //       gravity: Toast.BOTTOM,
                            //       textColor: Colors.red,
                            //     );
                            //   }
                            // } else {
                            //   Toast.show(
                            //     "Please Enter All Four Digits".toLowerCase(),
                            //     context,
                            //     duration: Toast.LENGTH_LONG,
                            //     gravity: Toast.BOTTOM,
                            //     textColor: Colors.red,
                            //   );
                            // }
                          },
                          onCodeChanged: (code) {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            _code = code;
                            compareCode();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      !isCodeSent
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                SizedBox(
                                  height: 15.0,
                                  width: 15.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Waiting for otp',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  'To Resend Code',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isCodeSent = false;
                                    });

                                    sendCode(widget.number);
                                  },
                                  child: Text(
                                    'click here',
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30.0 + bottomInset,
                right: 15.0,
                left: 15.0,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: mediaQuery.size.height * 0.065,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blue[800],
                      ),
                    ),
                    onPressed: () async {
                      await compareCode();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  compareCode() async {
    dev.log('Code is $_code');
    if (_code!.length == 4) {
      FocusScope.of(context).requestFocus(FocusNode());

      if (_code?.compareTo(verificationCode ?? '-1') == 0) {
        await prefs?.setString("mobile", widget.number.toString());
        await prefs?.setString("bank_id", bankId!);
        await prefs?.setString("pan_id", panId!);

        await prefs?.setString("bank_name", bankName!);
        await prefs?.setString("role", role!);
        // prefs?.setBool(
        //   "is_manager",
        //   role!.trim().toLowerCase().contains('bank_manager'),
        // );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LandingPage(),
          ),
          (Route<dynamic> route) => false,
          // ModalRoute.withName(SignUp.id),
        );
      } else {
        // Toast.show(
        //   "Not the proper code".toLowerCase(),
        //   context,
        //   duration: Toast.LENGTH_LONG,
        //   gravity: Toast.BOTTOM,
        //   textColor: Colors.red,
        // );
      }
    } else {
      // Toast.show(
      //   "Please Enter All Four Digits".toLowerCase(),
      //   context,
      //   duration: Toast.LENGTH_LONG,
      //   gravity: Toast.BOTTOM,
      //   textColor: Colors.red,
      // );
    }
  }
}
