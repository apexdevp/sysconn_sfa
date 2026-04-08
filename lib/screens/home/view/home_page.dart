import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/view/sales_menu_view.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/screens/expenses/views/expenses_menuview.dart';
import 'package:sysconn_sfa/screens/home/controller/home_page_controller.dart';
import 'package:sysconn_sfa/screens/pos/view/pos_menu_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey _firstScreenKey = GlobalKey();

  final List<Widget> homeChild = [
    SalesMenuView(),
    ExpensesMenuView(),
    PosVanMenuView(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
      init: HomePageController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.transparent, // Make transparent
            // elevation: 0, // Optional
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageList.appbarImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(controller.menuList[controller.currentIndex]),
            actions: [
              GestureDetector(
                onTap: () async {},
                child: Badge(
                  // isLabelVisible: ,
                  label: Text('1', style: TextStyle(color: Colors.white)),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: ClipOval(
                  child: Utility.companyLogo == ''
                      ? Icon(Icons.image_not_supported_outlined, size: 20)
                      : Image.file(
                          File(Utility.companyLogo),
                          width: 30,
                          height: 20,
                        ),
                ),
              ),
            ],
          ),
          drawer: const DrawerForAll(),
          body: homeChild[controller.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            selectedLabelStyle: kTxtStl14B,
            unselectedLabelStyle: kTxtStl13GreyN,
            backgroundColor: Colors.grey.shade200,
            currentIndex: controller.currentIndex,
            onTap: controller.bottomNavChange,
            items: const [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(ImageList.salesImage),
                ), //Icon(Icons.pan_tool_alt_outlined),
                label: 'Sales',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(ImageList.posvanImage),
                ), // Icon(Icons.laptop_chromebook_outlined),
                label: 'Expenses',
              ),
              BottomNavigationBarItem(
                // icon: ImageIcon(
                //   AssetImage(ImageList.posvanImage),
                // ), //Icon(Icons.money_outlined),
                icon: Icon(FontAwesomeIcons.truck),
                label: 'POS/VAN',
              ),
            ],
          ),
        );
      },
    );
  }
}
