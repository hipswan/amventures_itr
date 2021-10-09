import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:itrpro/app_url.dart';
import 'package:itrpro/model/bank_detail.dart';
import 'package:itrpro/network_helper.dart';
import 'package:itrpro/pages/processpage/process_add_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:developer' as dev;

import '../../main.dart';

class AddPanPage extends StatefulWidget {
  const AddPanPage({Key? key}) : super(key: key);

  @override
  _AddPanPageState createState() => _AddPanPageState();
}

class _AddPanPageState extends State<AddPanPage>
    with AutomaticKeepAliveClientMixin<AddPanPage> {
  bool isSubmitted = false;
  String? bankName;
  TextEditingController _cPan = TextEditingController(text: 'BEZPS6655F');
  TextEditingController _cCamobile = TextEditingController();
  List<BankDetail> bankDetails = [];
  List<DropdownMenuItem<String>> bankNameDropDownItems = [
    DropdownMenuItem(child: Text('Loading....'), value: '-1'),
  ];
  GlobalKey<FormState> _savePanKey = GlobalKey<FormState>();
  GlobalKey<FormState> _sendSms = GlobalKey<FormState>();
  bool isApiCall = false;
  String? loaderMessage = 'Please Wait...';

  @override
  void dispose() {
    // TODO: implement dispose
    bankNameDropDownItems = [
      DropdownMenuItem<String>(child: Text('Loading....'), value: '-1'),
    ];
    _savePanKey.currentState!.dispose();
    _cPan.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getBankName().then((List<BankDetail>? banklist) {
      if (this.mounted) {
        bankNameDropDownItems.clear();
        if (banklist?.isNotEmpty ?? false) {
          banklist?.forEach(
            (bankdetail) => bankNameDropDownItems.add(
              DropdownMenuItem<String>(
                child: Text(
                  bankdetail.name!,
                ),
                value: bankdetail.name!,
              ),
            ),
          );
        } else {
          bankNameDropDownItems.add(
            DropdownMenuItem(
              child: Text(
                'Error Occurred',
              ),
              value: 'Error occurred',
            ),
          );
        }
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // isApiCall = false;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Pan Card',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isApiCall,
        progressIndicator: SizedBox(
          height: MediaQuery.of(context).size.aspectRatio * 150,
          width: size.width * 0.7,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 32.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              border: Border.all(
                width: 1.0,
                color: Colors.black38,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Text(
                    '$loaderMessage',
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(
            15.0,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[50]!.withAlpha(75),
          ),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 30.0,
                ),
                child: isSubmitted
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Send link to CA ?',
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  var caMobileNumber =
                                      await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) {
                                      var bottomInsets = MediaQuery.of(context)
                                          .viewInsets
                                          .bottom;

                                      return Container(
                                        padding: EdgeInsets.fromLTRB(
                                          30.0,
                                          30.0,
                                          30.0,
                                          30.0 + bottomInsets,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                          color: Colors.blue[50],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                height: 8.0,
                                                width: 40.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.green.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            Text(
                                              'Enter Contact Number of CA',
                                            ),
                                            SizedBox(
                                              height: 22.0,
                                            ),
                                            Form(
                                              key: _sendSms,
                                              child: TextFormField(
                                                controller: _cCamobile,
                                                cursorColor: Colors.green[800],
                                                cursorHeight: 20.0,
                                                validator: (value) {
                                                  if (value!.trim().length ==
                                                      0) {
                                                    return "Please Enter Mobile Number";
                                                  }
                                                  if (value.trim().length > 10 ||
                                                      value.trim().length <
                                                          10 ||
                                                      value.trim().contains(
                                                          new RegExp(
                                                              r'[A-Za-z/@_-]'))) {
                                                    return "Please Enter Valid Mobile Number";
                                                  }
                                                  if (value.trim().length ==
                                                      10) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                      new FocusNode(),
                                                    );
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(
                                                  //   vertical: 8.0,
                                                  //   horizontal: 12.0,
                                                  // ),
                                                  prefix: Text(
                                                    '+91-',
                                                  ),
                                                  hintText:
                                                      'Enter Mobile Number',
                                                  fillColor: Colors.blue[50],
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      50.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                    horizontal: 30.0,
                                                    vertical: 15.0,
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (_sendSms.currentState!
                                                    .validate()) {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    loaderMessage =
                                                        'Sending sms...';
                                                    isApiCall = true;
                                                  });
                                                  await sendSmsByLink(
                                                      mobileNumber: _cCamobile
                                                          .text
                                                          .trim());
                                                  setState(() {
                                                    loaderMessage = null;
                                                    isApiCall = false;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'Send',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'Yes',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool isTermsChecked = false;
                                  var result = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Terms and Condition',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: StatefulBuilder(
                                        builder:
                                            (context, StateSetter termSetter) =>
                                                Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 150,
                                              padding: EdgeInsets.all(
                                                8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.blue[700]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10.0,
                                                ),
                                              ),
                                              child: Scrollbar(
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    'content of terms and condition',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Checkbox(
                                                      value: isTermsChecked,
                                                      onChanged:
                                                          (termsChecked) {
                                                        termSetter(() {
                                                          isTermsChecked =
                                                              termsChecked!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      termSetter(() {
                                                        isTermsChecked =
                                                            !isTermsChecked;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Click here for output authorization',
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                    horizontal: 30.0,
                                                    vertical: 15.0,
                                                  ),
                                                ),
                                              ),
                                              onPressed: isTermsChecked
                                                  ? () async {
                                                      Navigator.of(context)
                                                          .pop<String>(
                                                              'process');
                                                    }
                                                  : null,
                                              child: Text(
                                                'Process',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      loaderMessage =
                                          'Processing your request..';
                                      isApiCall = true;
                                    });
                                    var result = await processPanAddRequest();
                                    if (result.contains('error')) {
                                      await Future.delayed(
                                        Duration(
                                          seconds: 2,
                                        ),
                                      );
                                      setState(() {
                                        loaderMessage = null;
                                        isApiCall = false;
                                      });
                                      routeToDownload(
                                        url:
                                            'https://www.bankverification.in/urlitrdownload/startitrdownload/download@bankverification.in/6/ITR/CWBPK6582J/nogst',
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'No',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                isSubmitted = false;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.replay_outlined,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'Enter Pan Again',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Form(
                        key: _savePanKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                vertical: 22.0,
                              ),
                              child: Text(
                                'Welcome!! Add your Pan and bank details.',
                                strutStyle: StrutStyle(
                                  fontSize: 18.0,
                                ),
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Container(
                                width: size.width - 60,
                                child: TextFormField(
                                  controller: _cPan,
                                  cursorColor: Colors.green[800],
                                  cursorHeight: 20.0,
                                  validator: (value) {
                                    var pan = value!.trim();
                                    if (pan.isEmpty) {
                                      return 'enter pan detail before searching';
                                    } else if (pan.length != 10) {
                                      return 'enter 10-digit alphanumeric pan number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    hintText: 'Enter Pan Card Details',
                                    fillColor: Colors.blue[50],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        50.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: bankName,
                              onChanged: (value) {},
                              validator: (value) {
                                var bankName = value?.trim() ?? '';
                                if (bankName.isEmpty) {
                                  return 'select bank name';
                                }
                                return null;
                              },
                              items: bankNameDropDownItems,
                              decoration: InputDecoration(
                                fillColor: Colors.blue[50],
                                filled: true,
                                hintText: 'Select Bank Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_savePanKey.currentState?.validate() ??
                                    false) {
                                  setState(() {
                                    loaderMessage = 'Saving Pan Details';
                                    isApiCall = true;
                                  });
                                  String saveResult = await savePanRes();

                                  if (!saveResult
                                      .toLowerCase()
                                      .contains('success')) {
                                    setState(() {
                                      loaderMessage = null;

                                      isApiCall = false;
                                      isSubmitted = true;
                                    });
                                  }
                                  //toast failed to save

                                }
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future routeToDownload({String? url}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessAddPage(
          downloadUrl: url,
        ),
      ),
    );
  }

  Future processPanAddRequest() async {
    try {
      String apiUrl = AppUrl.PROCESS_DOWNLOAD_MANAGER;
      // String mobileNumber = prefs?.getString('mobile') ?? '';
      String panId = prefs?.getString('pan_id') ?? '';
      String bankId = prefs?.getString('bank_id') ?? '';
      String emailTo = '';
      String itrgstorboth = '';
      String gstn = '';
      var response = await NetworkHelper.get(
        apiUrl: apiUrl + '$emailTo/$bankName/$itrgstorboth/$panId/$gstn',
      );

      if (response.statusCode == 200) {
        dev.log('send link by sms response is ${response.body}');
        var parsedJson = json.decode(response.body);

        return "success";
      } else {
        return "error";
      }
    } on SocketException catch (e, _) {
      dev.log(_.toString());

      return "no_internet";
    } catch (e, _) {
      dev.log(_.toString());
      return "error";
    }
  }

  Future<List<BankDetail>> getBankName() async {
    var apiUrl = AppUrl.BANK_LIST;

    try {
      var response = await NetworkHelper.get(
        apiUrl: apiUrl,
      );
      if (response.statusCode == 200) {
        var parsedJson = json.decode(response.body);
        dev.log("the bank list  is " + parsedJson.toString(),
            name: 'In get bank list');

        for (var bankname in parsedJson) {
          bankDetails.add(BankDetail.fromjson(bankname));
        }
        return bankDetails;
      } else {
        dev.log(
          '''Could't fetch bank list''',
        );
        return [];
      }
    } on SocketException catch (e) {
      dev.log(e.message);
      return [];
    } on Exception catch (e) {
      dev.log(e.toString());
      return [];
    }
  }

  Future<String> sendSmsByLink({String? mobileNumber}) async {
    try {
      String apiUrl = AppUrl.SEND_LINK_SMS;
      // String mobileNumber = prefs?.getString('mobile') ?? '';
      String panId = prefs?.getString('pan_id') ?? '';
      String bankId = prefs?.getString('bank_id') ?? '';
      var response = await NetworkHelper.get(
        apiUrl: apiUrl + '$mobileNumber/$panId/$bankId',
      );

      if (response.statusCode == 200) {
        dev.log('send link by sms response is ${response.body}');
        var parsedJson = json.decode(response.body);

        return "success";
      } else {
        return "error";
      }
    } on SocketException catch (e, _) {
      dev.log(_.toString());

      return "no_internet";
    } catch (e, _) {
      dev.log(_.toString());
      return "error";
    }
  }

  Future savePanRes() async {
    try {
      String apiUrl = AppUrl.SAVE_PAN;
      String panNumber = _cPan.text.trim();
      String mobileNumber = prefs?.getString('mobile') ?? '';
      // '7276948182';

      var response = await NetworkHelper.post(
        apiUrl: apiUrl + '$mobileNumber/$panNumber',
      );

      if (response.statusCode == 200) {
        dev.log(' pan card save detail is ${response.body}');
        var parsedJson = json.decode(response.body);

        return "success";
      } else {
        return "error";
      }
    } on SocketException catch (e, _) {
      dev.log(_.toString());

      return "no_internet";
    } catch (e, _) {
      dev.log(_.toString());
      return "error ";
    }
  }

  @override
  bool get wantKeepAlive => true;
}
