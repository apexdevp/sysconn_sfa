// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:flutter/widgets.dart';

// scaffold key is null or not given i.e. we are not calling drawer here
// and except first screen of app don't add key or drawer
AppBar customAppbar({
  required BuildContext context,
  required String title,
  GlobalKey<ScaffoldState>? scaffoldKey,
  List<Widget>? actions,
  Widget? bottom,
}) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: scaffoldKey == null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.maybePop(context);
              },
            )
          : InkWell(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.menu_rounded, color: Colors.white),
            ),
    ),
    leadingWidth: 50,
    titleSpacing: 0,
    title: Text(
      scaffoldKey == null ? title : Utility.companyName,
      style: kTxtStl16B,
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            //
                        Color(0xffF54749),
                        
                    //  Color.fromARGB(255, 223, 98, 15),
                      Color(0xffF54749),
          ],
        ),
      ),
    ),
    actions: actions,
    // actions: scaffoldKey == null?
    // actions:
    // [
    //   Container(
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       border: Border.all(color: Colors.black)
    //     ),
    //     margin: const EdgeInsets.all(0),
    //     padding: const EdgeInsets.all(8),
    //     child: Utility.companyLogo == ''?
    //     Icon(Icons.image_not_supported_outlined,color: Theme.of(context).colorScheme.secondary, size: 20,)
    //     :Image.file(File(Utility.companyLogo),width: 23,height: 16,)
    //   ),
    // ],
    bottom: bottom == null
        ? null
        : PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Column(children: [bottom, const SizedBox(height: 10)]),
          ),
  );
}
