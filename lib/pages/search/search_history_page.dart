import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itrpro/network_helper.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:itrpro/model/pan_dowload_list.dart';
import '../../app_url.dart';
import 'dart:developer' as dev;
import 'dart:io' as io;
import 'package:itrpro/main.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({Key? key}) : super(key: key);

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<PanDownloadModel> recentDownloadList = [];
  List<PanDownloadModel> lastPanDownloadList = [];
  List<PanDownloadModel> searchDownloadList = [];

  TextEditingController _cPan = TextEditingController();
  String status = "loading";
  String? loaderMessage = 'Please Wait..';
  bool isApiCall = true;
  GlobalKey<FormState> _searchPanKey = GlobalKey();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    dev.log('did change dependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SearchHistoryPage oldWidget) {
    if (recentDownloadList.isEmpty) {
      getRecentDownloadList().then((value) async {
        if (this.mounted) {
          setState(() {
            // isApiCall = false;
            loaderMessage = "Loading last pan details..";
            status = value;
          });
          await getLastDownloadList();
          setState(() {
            // isApiCall = false;
            loaderMessage = null;
            // status = value;
            isApiCall = false;
          });
        }
      }).whenComplete(() {
        getLastDownloadList().then((value) {
          if (this.mounted) {
            setState(() {
              isApiCall = false;
              status = value;
            });
          }
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getRecentDownloadList().then((value) async {
      if (this.mounted) {
        setState(() {
          isApiCall = false;
          // loaderMessage = "Loading last pan..";
          status = value;
        });
        // await getLastDownloadList();
        // setState(() {
        //   // isApiCall = false;
        //   loaderMessage = null;
        //   // status = value;
        //   isApiCall = false;
        // });
      }
    });

    super.initState();
  }

  getLastDownloadList() async {
    try {
      String apiUrl = AppUrl.LAST_PAN_FOR_DSA;
      String mobileNumber = prefs?.getString('mobile') ?? '';
      String bankId = prefs?.getString('bank_id') ?? '';
      String panNumber = prefs?.getString('pan_id') ?? '';

      var response = await NetworkHelper.get(
        apiUrl: apiUrl + '$mobileNumber/$panNumber/$bankId',
      );

      if (response.statusCode == 200) {
        dev.log('get last pan card download detail is ${response.body}');
        var parsedJson = json.decode(response.body);
        for (var panDetails in parsedJson) {
          lastPanDownloadList.add(PanDownloadModel.fromJson(panDetails));
        }

        return "success";
      } else {
        return "error";
      }
    } on io.SocketException catch (e, _) {
      dev.log(_.toString());

      return "no_internet";
    } catch (e, _) {
      dev.log(_.toString());
      return "error";
    }
  }

  setupFlutterDownloader() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher.png');
    var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    //flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    dev.log('Pan card detail dispose');

    super.dispose();
  }

  Future onSelectNotification(String? payload) async {
    // print("Payload: $payload");
    OpenFile.open(payload);
  }

  Future<String> getRecentDownloadList() async {
    try {
      String apiUrl = AppUrl.GET_RECENT_DOWNLOAD;
      String mobileNumber = '7276948182';
      String bankId = '6';
      var response = await NetworkHelper.get(
        apiUrl: apiUrl + '$mobileNumber/$bankId',
      );

      if (response.statusCode == 200) {
        dev.log('get pan card download detail is ${response.body}');
        var parsedJson = json.decode(response.body);
        for (var panDetails in parsedJson) {
          recentDownloadList.add(PanDownloadModel.fromJson(panDetails));
        }

        return "success";
      } else {
        return "error";
      }
    } on io.SocketException catch (e, _) {
      dev.log(_.toString());

      return "no_internet";
    } catch (e, _) {
      dev.log(_.toString());
      return "error";
    }
  }

  Future getPanSearchResult() async {
    try {
      String apiUrl = AppUrl.BANK_MANAGER_PAN_SEARCH;
      String panNumber = _cPan.text.trim();
      String bankId = prefs?.getString('bank_id') ?? '';
      // '7276948182';

      var response = await NetworkHelper.get(
        apiUrl: apiUrl + '$panNumber/$bankId',
      );

      if (response.statusCode == 200) {
        dev.log('get pan card search detail is ${response.body}');
        var parsedJson = json.decode(response.body);
        searchDownloadList.add(PanDownloadModel.fromJson(parsedJson));

// {"id":null,"userid":null,"panorgstn":"AYMPM8589N","contact":null,"status":null,"submitdate":null,"reportreadydate":null,"assessmentyear":null,"username":null,"email":null,"bankname":null,"state":null,"mailstatus":null,"clientname":null,"mailid":null,"returntype":null,"pass":null,"month":null,"totalstatuscount":null,"ifsc":null,"itrpdfreport":"/FINALREPORT/2021-08-11-12-06/6/AYMPM8589N/100608021AYMPM8589N.PDF","accounttype":null,"systemusername":null,"branch":null}
        //show alert
      } else {
        //show Alert
      }
    } on io.SocketException catch (e, _) {
      dev.log(_.toString());

      //show Alert

    } catch (e, _) {
      dev.log(_.toString());
      //show Alert

    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[50]!.withAlpha(75),
        automaticallyImplyLeading: false,
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
                Text('${loaderMessage ?? 'Please Wait...'}'),
              ],
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30.0,
            10.0,
            30.0,
            30.0,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[50]!.withAlpha(75),
          ),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(
                        0,
                        -3,
                      ),
                      blurRadius: 10.0,
                      color: Colors.grey.withAlpha(60),
                      spreadRadius: -5.0,
                    )
                  ],
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
                        onPressed: () async {
                          if (_searchPanKey.currentState?.validate() ?? false) {
                            searchDownloadList.clear();
                            setState(
                              () {
                                loaderMessage = 'getting pan detail...';
                                isApiCall = true;
                              },
                            );

                            await getPanSearchResult();
                            setState(() {
                              loaderMessage = null;
                              isApiCall = false;
                            });
                          }
                        },
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width - 60 - 50,
                      child: Form(
                        key: _searchPanKey,
                        child: TextFormField(
                          controller: _cPan,
                          cursorColor: Colors.green[800],
                          cursorHeight: 20.0,
                          validator: (value) {
                            var searchPanValue = value?.trim() ?? '';
                            if (searchPanValue.isEmpty) {
                              return 'please enter pan card details';
                            } else if (searchPanValue.length != 10) {
                              return 'enter 10-digit alphanumeric number';
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
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0,
                          10,
                        ),
                        blurRadius: 10.0,
                        color: Colors.grey.withAlpha(60),
                        spreadRadius: -5.0,
                      )
                    ],
                    color: Colors.blue.shade50,
                    border: Border.all(
                      width: 2.0,
                      color: Colors.blueGrey.withAlpha(
                        100,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: getDownloadListView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDownloadListView() {
    switch (status) {
      case "success":
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lastPanDownloadList.length > 0) Text('Last Pan'),
              LimitedBox(
                maxHeight: lastPanDownloadList.length * 65,
                child: RecentPanList(
                  panList: lastPanDownloadList,
                  color: Colors.blueAccent,
                ),
              ),
              if (searchDownloadList.length > 0) Text('Search Pan Result'),
              LimitedBox(
                maxHeight: searchDownloadList.length * 65,
                child: RecentPanList(
                  panList: searchDownloadList,
                  color: Colors.greenAccent,
                ),
              ),
              if (recentDownloadList.length > 0) Text('Pan List'),
              LimitedBox(
                maxHeight: recentDownloadList.length * 65,
                child: RecentPanList(
                  panList: recentDownloadList,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        );
        break;
      case "no_result":
        return Container();
        break;
      case "no_internet":
        return Container();
        break;
      case "error":
        return Container();
        break;
      default:
        return Container();
        break;
    }
  }
}

class RecentPanList extends StatelessWidget {
  final List<PanDownloadModel>? panList;
  final color;

  RecentPanList({
    Key? key,
    @required this.panList,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 65,
      physics: NeverScrollableScrollPhysics(),
      itemCount: panList?.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      50.0,
                    ),
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(
                          0,
                          10,
                        ),
                        color: Colors.black.withOpacity(
                          0.15,
                        ),
                        spreadRadius: -5.0,
                        blurRadius: 10.0,
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(
                              0,
                              10,
                            ),
                            color: Colors.black.withOpacity(
                              0.15,
                            ),
                            spreadRadius: -5.0,
                            blurRadius: 10.0,
                          )
                        ],
                        color: Colors.purple,
                      ),
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 78,
                      child: SelectableText(
                        '${panList?.elementAt(index).panorgstn ?? 'error'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Suisse',
                          fontWeight: FontWeight.w900,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  CircleBorder(),
                ),
                padding: MaterialStateProperty.all(
                  EdgeInsets.all(
                    8.0,
                  ),
                ),
              ),
              onPressed: () async {
                // log('Pressed Download Button');
                var currentPanDetail = panList?.elementAt(index);
                if (currentPanDetail?.itrpdfreport?.isNotEmpty ?? false) {
                  String fileName = '${currentPanDetail?.userid}.pdf';

                  String apiUrl =
                      AppUrl.END_POINT + "${currentPanDetail?.itrpdfreport}";

                  try {
                    http.Response response = await http.get(
                      Uri.parse(
                        apiUrl,
                      ),
                      headers: {'content-type': 'application/pdf'},
                    );
                    if (response.statusCode == 200) {
                      List<int> data = response.bodyBytes;
                      String pdfPath = io.Platform.isAndroid
                          ? '/storage/emulated/0/Download/$fileName'
                          : (await path.getApplicationDocumentsDirectory())
                                  .path +
                              '/Download/$fileName';
                      io.File? result =
                          await io.File('$pdfPath').writeAsBytes(data);
                      if (result != null) {
                        var androidPlatformChannelSpecifics =
                            new AndroidNotificationDetails(
                          'pdf_download',
                          'pdf_download',
                          'download pdf',
                          importance: Importance.max,
                          priority: Priority.high,
                          playSound: true,
                          tag: 'Itr stats',
                          icon: '@mipmap/ic_launcher.png',
                        );
                        var iOSPlatformChannelSpecifics =
                            new IOSNotificationDetails();
                        var platformChannelSpecifics = new NotificationDetails(
                          android: androidPlatformChannelSpecifics,
                          iOS: iOSPlatformChannelSpecifics,
                        );

                        await flutterLocalNotificationsPlugin.show(
                          0,
                          'ITR stats for ${currentPanDetail?.panorgstn}',
                          'Tap To Open',
                          platformChannelSpecifics,
                          payload: pdfPath,
                        );
                        // Platform.isIOS ? OpenFile.open(excelPath) : null;

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          width: 310,
                          buttonsBorderRadius:
                              BorderRadius.all(Radius.circular(2)),
                          headerAnimationLoop: false,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Downloaded Completed!',
                          desc:
                              'Your Itr report has been downloaded successfully, ',
                          showCloseIcon: false,
                          btnCancelColor: Colors.red,
                          btnCancelOnPress: () {
                            Navigator.pop(context);
                          },
                          btnCancelText: 'Later..',
                          btnOkColor: Colors.green,
                          btnOkText: 'Open File',
                          btnOkOnPress: () {
                            OpenFile.open(pdfPath);
                          },
                        )..show();
                      } else
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.ERROR,
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          width: 310,
                          buttonsBorderRadius:
                              BorderRadius.all(Radius.circular(2)),
                          headerAnimationLoop: false,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Downloaded Completed!',
                          desc:
                              'Your Itr report has been downloaded successfully, ',
                          showCloseIcon: false,
                          btnCancelColor: Colors.red,
                          btnCancelOnPress: () {
                            Navigator.pop(context);
                          },
                          btnCancelText: 'Later..',
                          btnOkColor: Colors.green,
                          btnOkText: 'Open File',
                          btnOkOnPress: () {},
                        )..show();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('server error!'),
                          padding: EdgeInsets.fromLTRB(
                            12.0,
                            0.0,
                            12.0,
                            50.0,
                          ),
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    }

                    // await FlutterDownloader.enqueue(
                    //   url:
                    //       "https://hajeri.in/qrcodes/${prefs.getString('org_id')}/${widget.pointName}/$pdfSizeDropDownValue.pdf",
                    //   savedDir: io.Platform.isAndroid
                    //       ? '/storage/emulated/0/Download/'
                    //       : (await path
                    //               .getApplicationDocumentsDirectory())
                    //           .path,
                    //   headers: {'content-type': 'application/pdf'},
                    //   fileName: fileName,
                    //   showNotification: true,
                    //   openFileFromNotification: true,
                    // );

                  } on io.SocketException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('device is not connected to internet'),
                        margin: EdgeInsets.fromLTRB(
                          12.0,
                          0.0,
                          12.0,
                          50.0,
                        ),
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  } on path.MissingPlatformDirectoryException catch (e1) {
                    dev.log(e1.message, name: 'In flutter downloader');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('file not downloaded'),
                        padding: EdgeInsets.fromLTRB(
                          12.0,
                          0.0,
                          12.0,
                          50.0,
                        ),
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  } catch (e2) {
                    dev.log(e2.toString(), name: 'In flutter downloader');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('file not downloaded'),
                        padding: EdgeInsets.fromLTRB(
                          12.0,
                          0.0,
                          12.0,
                          50.0,
                        ),
                        backgroundColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  }
                } else {}
              },
              child: Icon(
                Icons.download,
              ),
            ),
          ],
        );
      },
    );
  }
}
