import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/login/loginnew.dart';
import 'package:sysconn_sfa/routes/navigator_routes.dart';
import 'package:sysconn_sfa/screens/home/view/home_page.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(SafeArea(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SYSCONN SFA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          surfaceTint: Colors.white,
          outline: Colors.grey.shade500,
          secondary: kAppIconColor,
        ),
        iconTheme: IconThemeData(color: kAppIconColor),
        useMaterial3: true,
        fontFamily: GoogleFonts.lato().fontFamily,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme(titleTextStyle: kTxtStl17W, elevation: 0.0),
      ),
      home: UpgradeAlert(
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        upgrader: Upgrader(countryCode: 'IN'),
        child: LoginScreen(), //LoginScreen(),//LoginPage(),
      ),
      getPages: [
        GetPage(
          name: NavigatorRoutes.homescreen,
          page: () =>
              HomePage(), //const HomeScreenView(),//snehal 11-02-2026 comment for ui changes
        ),
        // GetPage(
        //   name: NavigatorRoutes.soReport,
        //   page: () => const DelNoteCreate(
        //     vchType: '',
        //     partyId: '',
        //     partyName: '',

        //   ),
        // ),
      ],
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
