import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  String status = "loading";

  @override
  void initState() {
    getRecentDownloadList().then((value) {
      setState(() {
        status = value;
      });
    });

    super.initState();
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
      http.Response response = await http.get(
        Uri.parse(
          apiUrl + '$mobileNumber/$bankId',
        ),
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[50]!.withAlpha(75),
        automaticallyImplyLeading: false,
      ),
      body: Container(
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
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
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
                    width: size.width - 60 - 50,
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
    );
  }

  Widget getDownloadListView() {
    switch (status) {
      case "success":
        return RecentPanList(
          recentPanList: recentDownloadList,
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
  final List<PanDownloadModel>? recentPanList;
  const RecentPanList({
    Key? key,
    @required this.recentPanList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 65,
      itemCount: recentPanList?.length,
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
                    color: Colors.redAccent,
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
                      child: Text(
                        '${recentPanList?.elementAt(index).panorgstn ?? 'error'}',
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
                var currentPanDetail = recentPanList?.elementAt(index);
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
                            iOS: iOSPlatformChannelSpecifics);

                        await flutterLocalNotificationsPlugin.show(
                            0,
                            'ITR stats for ${currentPanDetail?.panorgstn}',
                            'Tap To Open',
                            platformChannelSpecifics,
                            payload: pdfPath);
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
                      const SnackBar(
                        content: Text('device is not connected to internet'),
                      ),
                    );
                  } on path.MissingPlatformDirectoryException catch (e1) {
                    dev.log(e1.message, name: 'In flutter downloader');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('file not downloaded'),
                      ),
                    );
                  } catch (e2) {
                    dev.log(e2.toString(), name: 'In flutter downloader');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('file not downloaded'),
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
