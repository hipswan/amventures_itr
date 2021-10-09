import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer' as dev;
import '../../app_url.dart';
import '../../network_helper.dart';

class ProcessAddPage extends StatefulWidget {
  final String? downloadUrl;
  const ProcessAddPage({Key? key, this.downloadUrl}) : super(key: key);

  @override
  _ProcessAddPageState createState() => _ProcessAddPageState();
}

class _ProcessAddPageState extends State<ProcessAddPage> {
  StreamController checkProcessStatus = StreamController();
  DateTime? processBegins;
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    processBegins = DateTime.now();
    checkStatus();

    super.initState();
  }

  checkStatus() async {
    var time = processBegins?.difference(DateTime.now()).inSeconds;
    while (time! > 10) {
      await Future.delayed(
        Duration(
          seconds: 1,
        ),
      );
      await checkPanStatus();
    }
    // checkProcessStatus.close();
  }

  Future checkPanStatus() async {
    // try {
    //   String apiUrl = AppUrl.CHECK_PAN_STATUS;
    //   String panNumber = '';
    //   String mobileNumber = '';
    //   String bankId = '';
    //   // '7276948182';

    //   var response = await NetworkHelper.post(
    //     apiUrl: apiUrl + '$mobileNumber/$panNumber/$bankId',
    //   );

    //   if (response.statusCode == 200) {
    //     dev.log(' pan card save detail is ${response.body}');
    //     var parsedJson = json.decode(response.body);
    //     if (parsedJson['status']
    //         .toString()
    //         .toLowerCase()
    //         .contains('completed')) {
    //       checkProcessStatus.close();
    //     }
    //     return "success";
    //   } else {
    //     return "error";
    //   }
    // } on SocketException catch (e, _) {
    //   dev.log(_.toString());

    //   return "no_internet";
    // } catch (e, _) {
    //   dev.log(_.toString());
    //   return "error ";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Verify Document',
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            initialData: '',
            stream: checkProcessStatus.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return WebView(
                  initialUrl: widget.downloadUrl,
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Text('done'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
