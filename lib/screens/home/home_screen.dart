import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/screens/home/home_view.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget gredientimg(String image) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(48, 71, 123, 1),//pratiksha p 31-01-2025 change opacity as in new version  color was showing white
                      Color.fromRGBO(102, 75, 170, 1),
                      Color.fromRGBO(117, 40, 142, 1)
                    ],
                  ),
                ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size.height * 0.024,
        child: Image.asset(
          image, //ImageList.homeXs,
          height: size.height * 0.028,
        ),
      ),
    );
  }

  //pooja // add custom widget
  Widget homeimg(String title, String img) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(img, height: size.height * 0.03),
          const SizedBox(height: 4),
          Text(title, style: kTxtStl12WB),
        ],
      ),
    );
  }

  CurvedNavigationBar customNavigationBar() {
    return CurvedNavigationBar(
      index: _currentIndex,
      height: 54,
      items: [
        _currentIndex == 0
            ? gredientimg(ImageList.homeXs)
            : homeimg('Home', ImageList.homeXs),
        _currentIndex == 1
            ? gredientimg(ImageList.report)
            : homeimg('Reports', ImageList.report),
        _currentIndex == 2
            ? gredientimg(ImageList.help)
            : homeimg('Help', ImageList.help),
        _currentIndex == 3
            ? gredientimg(ImageList.homeprofile)
            : homeimg('Profile', ImageList.homeprofile),
      ],
      color: const Color.fromRGBO(143, 46, 42, 1),
      buttonBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {
        if (Utility.companyId == '') {
          scaffoldMessageBar( 'Please select company first!!');
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    );
  }

  Widget selectedBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeView();
      // case 1:
      //   return const RetailerReport();
      // case 2:
      //   return const ShowAllTicketsReport();
      // case 3:
      //   return const MyProfileScreenView();
      default:
        return const HomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        bool navBool = await _onWillPopFun();
        if (navBool) {
          navigator.pop();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: customAppbar(
          context: context,
          title: Utility.companyName == ''
              ? 'Select Company Name'
              : Utility.companyName, //selectedAppbarTitle(),
          scaffoldKey: scaffoldKey,
          actions: [
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.width * 0.01,
            //       right: MediaQuery.of(context).size.width * 0.03),
            //   child: GestureDetector(
            //     child: Badge(
            //       backgroundColor: const Color.fromRGBO(143, 46, 42,
            //           5), //pooja // 20-08-2024 // change color //Colors.red,
            //       label: Text(
            //         '1',
            //         style: kTxtStl12WN,
            //       ),
            //       // child: Icon(
            //       //   Icons.notifications_outlined,
            //       //   size: MediaQuery.of(context).size.height * 0.04,
            //       // ),
            //     ),
            //     // onTap: () async {
            //     //   await Navigator.of(context).push(MaterialPageRoute(
            //     //       builder: (context) => const NotificationDetails()));
            //     // },
            //   ),
            // ),
          ],
        ),
        drawer: const DrawerForAll(),
        onDrawerChanged: (val) {
          if (!val) {
            if (mounted) {
              setState(() {});
            }
          }
        },
        //bottomNavigationBar: customNavigationBar(),
        body: selectedBody(),
      ),
    );
  }

  Future<bool> _onWillPopFun() async {
    bool willPopValue = false;
    if (_currentIndex == 0) {
       Utility.showAlertYesNo(
        iconData: Icons.question_mark_sharp,
        iconcolor: kAppColor,
        title: 'Alert',
        msg: 'Are you sure? \n you want to quit this app!!',
        yesBtnFun: () {
          Navigator.pop(context);
          if (mounted) {
            setState(() {
              willPopValue = true;
            });
          }
          return willPopValue;
        },
        noBtnFun: () {
          if (mounted) {
            setState(() {
              willPopValue = false;
            });
          }
          Navigator.pop(context);
        },
      );
    } else {
      if (mounted) {
        setState(() {
          _currentIndex = 0;
        });
      }
    }
    // print('willPopValue $willPopValue');
    return willPopValue;
  }
}
