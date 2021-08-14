import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:itrpro/app_url.dart';
import 'package:itrpro/model/bank_detail.dart';
import 'package:itrpro/network_helper.dart';
import 'dart:developer' as dev;

class AddPanPage extends StatefulWidget {
  const AddPanPage({Key? key}) : super(key: key);

  @override
  _AddPanPageState createState() => _AddPanPageState();
}

class _AddPanPageState extends State<AddPanPage> {
  bool isSubmitted = false;
  String? bankName;
  List<BankDetail> bankDetails = [];
  List<DropdownMenuItem<String>> bankNameDropDownItems = [
    DropdownMenuItem(child: Text('Loading....'), value: '-1'),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    bankNameDropDownItems = [
      DropdownMenuItem<String>(child: Text('Loading....'), value: '-1'),
    ];
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Pan Card',
        ),
      ),
      body: Container(
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
                                var caMobileNumber = await showModalBottomSheet(
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
                                        borderRadius: BorderRadius.circular(
                                          20.0,
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
                                                  color: Colors.green.shade300,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
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
                                          TextField(
                                            cursorColor: Colors.green[800],
                                            cursorHeight: 20.0,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 12.0,
                                              ),
                                              hintText:
                                                  'Enter Pan Card Details',
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
                                            onPressed: () {},
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
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Terms and Condition',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: StatefulBuilder(
                                      builder:
                                          (context, StateSetter setState) =>
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
                                                    'content of terms and condition'),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isTermsChecked,
                                                onChanged: (termsChecked) {
                                                  setState(() {
                                                    isTermsChecked =
                                                        termsChecked!;
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    setState(() {
                                                      isTermsChecked =
                                                          !isTermsChecked;
                                                    });
                                                  },
                                                  child: Text(
                                                    'Click here for output authorization',
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                                            onPressed:
                                                isTermsChecked ? () {} : null,
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
                  : Column(
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
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            50.0,
                                          ),
                                          bottomRight: Radius.circular(
                                            50.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.search,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width - 60 - 60,
                                child: TextField(
                                  cursorColor: Colors.green[800],
                                  cursorHeight: 20.0,
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        DropdownButtonFormField(
                          isExpanded: true,
                          value: bankName,
                          onChanged: (value) {},
                          items: bankNameDropDownItems,
                          decoration: InputDecoration(
                            fillColor: Colors.blue[50],
                            filled: true,
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
                          onPressed: () {
                            setState(() {
                              isSubmitted = true;
                            });
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
    );
  }
}
