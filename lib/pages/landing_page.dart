import 'package:flutter/material.dart';
import 'package:itrpro/pages/addpan/add_pan.dart';
import 'package:itrpro/pages/search/search_history_page.dart';
import '../constant.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../main.dart';
import 'package:permission_handler/permission_handler.dart';

class LandingPage extends StatefulWidget {
  final initialPageIndex;
  LandingPage({
    Key? key,
    this.initialPageIndex = 1,
  }) : super(key: key);
  static const id = "landing_page";

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<LandingPage> {
  TargetPlatform? platform;
  static List pageView = [];
  bool? isOrg;
  PageController? _pageController;
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    isOrg = prefs?.getBool('is_org');
    pageView = [
      SearchHistoryPage(),
      Center(
        child: Text('Kharcha'),
      ),
      Center(
        child: Text('Rupaya'),
      ),
    ];

    _tabController = TabController(
      length: 3,
      initialIndex: widget.initialPageIndex,
      vsync: this,
    );
    _pageController = PageController(
      initialPage: widget.initialPageIndex,
    );
    _checkPermission();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    _pageController?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final storageStatus = await Permission.storage.status;

      if (storageStatus != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus != PermissionStatus.granted) {
        final result = await Permission.camera.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
      final locationStatus = await Permission.location.status;

      if (locationStatus != PermissionStatus.granted) {
        final result = await Permission.locationWhenInUse.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            children: [
              SearchHistoryPage(),
              AddPanPage(),
              Center(
                child: Text('Rupaya'),
              ),
            ],
          ),

          // PageView.builder(
          //   physics: NeverScrollableScrollPhysics(),
          //   controller: _pageController,
          //   itemCount: 3,
          //   itemBuilder: (context, index) {
          //     return pageView[index];
          //   },
          // ),

          //  TabBarView(
          //   //No Scroll whence changing tab
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     Dashboard(),
          //     // Scanner(),
          //     Text(
          //       'scanner',
          //     ),
          //     MonthlyAttendance(),
          //   ],
          // ),
          bottomNavigationBar: ConvexAppBar.badge(
            {},
            gradient: kGradient,
            height: 60,
            elevation: 5,
            curveSize: 85,
            controller: _tabController,
            style: TabStyle.react,
            items: <TabItem>[
              TabItem(
                icon: Icons.dashboard_outlined,
                title: 'Pan',
              ),
              TabItem(
                icon: Icons.contact_mail,
                title: 'Add Pan',
              ),
              TabItem(
                icon: Icons.dashboard_outlined,
                title: 'Pay',
              ),
            ],
            onTap: (int i) {
              // print('Click index=$i');
              _pageController?.jumpToPage(i);
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
