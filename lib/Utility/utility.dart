import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pluto_grid_plus_export/pluto_grid_plus_export.dart'
    as pluto_grid_export;
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/save_file_mobile.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/api/entity/company/bank_entity.dart';
import 'package:sysconn_sfa/api/entity/company/companyentity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/chart/flchart.dart';
import 'package:sysconn_sfa/chart/sampleview.dart';
import 'package:file_saver/file_saver.dart';
import 'package:trina_grid/trina_grid.dart';

class Utility {
  const Utility();
  static String employeeName = ''; //Snehal 23-12-2025 add
  static bool isCmpEmp = true; //Snehal 23-12-2025 add
  static String groupCode = ''; //Snehal 23-12-2025 add
  static String employeeId = ''; //Snehal 23-12-2025 add
  static String loginDmsToken = '';
  static String username = '';
  static String email = '';
  static bool authValue = false;
  static String loginBbpsToken = '';
  static String logintoken = '';
  static String moduleCode = '';
  static bool isVisitCheckIn = false;
  static double borderCornerRadious = 14.0;
  static String companyId = '';
  static String encryptionKey = 'IoE53BzpHQZuBgp36tdk1RJTlvppAnyy';
  static String encryptIV = 'Mwbd/xN0VdEWhNtx1Uilow==';
  static String companyName = '';
  static String cmpmailingname = '';
  static String cmpusertype = 'ADMIN';
  static String partnerCode = '';
  static String companyLogo = '';
  static String cmpmobileno = '';
  static String customerPersonaId = '';
  static String appMode = 'Test'; //'Test'
  static String getApiHostUrl86 =
      'sysconnoms-get.sysconn.ai'; //'sysconnoms-get.umedtallymis.com';//'dms-distributor-get.dmsbusinessconnect.com';//'dms-distributor-get.dms-systemxs.com';
  static String postApiHostUrl86 =
      'sysconnoms-post.sysconn.ai'; // 'sysconnoms-post.umedtallymis.com';//'dms-distributor-post.dmsbusinessconnect.com';//'dms-distributor-post.dms-systemxs.com';
  static String getApiHostUrlRept86 = 'dms-dist-reports-get.dms-systemxs.com';
  static String getApiHostUrlDms = appMode == 'Test'
      ? getApiHostUrl86
      : 'sysxs_app_get.systemxssepay.com';
  static String postApiHostUrlDms = appMode == 'Test'
      ? postApiHostUrl86
      : 'sysxs_app_post.systemxssepay.com';
  static List<SOAddToCartEntity> cartDetailsDataList = [];
  static String domainName = '.dms-systemxs.com';

  // static String apiDbName1 = 'SystemXS';
  static DateTime? selectedFromDateOfDateController = findStartOfThisYear(
    DateTime.now(),
  );
  static DateTime? selectedToDateOfDateController = findLastOfThisYear(
    DateTime.now(),
  );
  static CompanyEntity companyMasterEntity = CompanyEntity();
  static String partyId = '';
  static String vchTypeCode = '';
  static String rateType = 'E';
  static bool isLocCompulsory = true;
  static const int tIMEOUTDURATION = 100; //pratiksha p 23-03-2024 add
  static String sysDbName =
      'Sysconn_OMS'; //'ScaleUpOMS';//'SystemXS'; //pratiksha p add
  static bool isSharedAccess = false;
  static String dashAmtScaleSelected =
      'Actuals'; // Snehal 28-09224 add for outstanding report
  static String dashAmtUnitScaleSelected() {
    //// Snehal 28-09224 add for outstanding report
    return Utility.dashAmtScaleSelected == 'Crores'
        ? 'Cr'
        : Utility.dashAmtScaleSelected == 'Lakhs'
        ? 'La'
        : 'Rs';
  }

  static UserEntity userMasterEntity =
      UserEntity();

  static String cmpAllowBackdatedAccess = '0';
  static List<FlChartData> flChartData = <FlChartData>[];
  static BankEntity bbpsBankRegisteredEntity = BankEntity();
  static String expVchPrefix = ''; //snehal 16-10-2024 add for expenses
  static String expVchtTypeName = ''; //snehal 16-10-2024 add for expenses
  // static Future<dynamic> showCircularLoadingWid(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (_) {
  //       return Center(
  //         child: Platform.isIOS
  //             ? const CupertinoActivityIndicator()
  //             : const CircularProgressIndicator(),
  //       );
  //     },
  //   );
  // }


   //pratiksha p 30-04-2026
  // ── REPLACE the old commented-out showCircularLoadingWid with these 3 ──
  static Future<void> showCircularLoadingWid(BuildContext context) {
    if (Get.isDialogOpen ?? false) return Future.value();
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (_) => const _LoadingDialog(),
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen ?? false) Get.back();
  }

  static Future<T> runWithLoading<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    showCircularLoadingWid(context);
    try {
      return await task();
    } finally {
      hideLoading();
    }
  }
 /////////////

  void cursorPosition(txtController, text) {
    txtController.value = txtController.value.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: text.length,
        extentOffset: text.length,
      ),
      composing: TextRange.empty,
    );
  }

  //  static  Future<void> exportToCsv({required PlutoGridStateManager? stateManager,required String reportTitle}) async {
  //     Uint8List bytes = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager!));
  //     await FileSaveHelper.saveAndLaunchFile(bytes, '$reportTitle.csv');//pratiksha p add
  //   }
  static Future<void> exportToCsv({
    required List<TrinaRow> allRows,
    required List<TrinaColumn> columns,
    required String reportTitle,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln(columns.map((c) => '"${c.title}"').join(','));
    for (final row in allRows) {
      final rowData = columns
          .map((col) {
            final cellValue =
                row.cells[col.field]?.value?.toString().replaceAll('"', '""') ??
                '';
            return '"$cellValue"';
          })
          .join(',');
      buffer.writeln(rowData);
    }
    final bytes = convert.utf8.encode(buffer.toString());
    await FileSaver.instance.saveFile(
      name: reportTitle,
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'csv',
      // ext: 'csv',
    );
  }

  //  static void exportToCsv({required PlutoGridStateManager stateManager,required String fileName}) async {
  //   Uint8List bytes = Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
  //   final savedPath = await FileSaver.instance.saveFile(name: fileName,bytes: bytes,ext: 'csv',);
  //   if (savedPath.toString().isNotEmpty) {
  //     // OpenFile.open(savedPath.toString());
  //   }
  // }

  static var formattedNumber = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ); //pratiksha p 18-09-2024 add
  static final List<String> stateDropdownlist = [
    "NA", // komal // not applicale if state is null
    "Andaman & Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra & Nagar Haveli and Daman & Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu & Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  static String useremailid = '';
  static Future saveCompanyDetails(
    String companyid,
    String companyName, //String partnercode,
    String mailingname,
    String usertype,
    String companyLogo,
    String groupCode, //Snehal 5-01-2025 add
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyid', companyid);
    await prefs.setString('companyName', companyName);
    await prefs.setString('mailingname', mailingname);
    await prefs.setString('companyusertype', usertype);
    await prefs.setString('cmp_logo_image', companyLogo);
    await prefs.setString('group_id', groupCode); //Snehal 5-01-2026 add
    Utility.companyId = companyid;
    Utility.companyName = companyName;
    Utility.cmpmailingname = mailingname;
    Utility.cmpusertype = usertype;
    Utility.companyLogo = companyLogo;
    Utility.groupCode = groupCode; //Snehal 5-01-2026 add
  }

  static Future getCompanyDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyid = (prefs.getString('companyid')) ?? '0';
    String companyName =
        (prefs.getString('companyName')) ?? 'Select Company First';
    String mailingname = (prefs.getString('mailingname')) ?? '';
    String usertype = (prefs.getString('companyusertype')) ?? 'ADMIN';
    String companyLogo = (prefs.getString('cmp_logo_image')) ?? '';
    String groupId = (prefs.getString('group_id')) ?? ''; //Snehal 5-01-2026 add
    print('dashboard companyid = $companyid');
    print('dashboard companyName = $companyName');
    print('dashboard groupid = $groupId');
    Utility.companyId = companyid;
    Utility.companyName = companyName;
    Utility.cmpmailingname = mailingname;
    Utility.cmpusertype = usertype;
    Utility.companyLogo = companyLogo;
    Utility.groupCode = groupId; //Snehal 5-01-2026 add
  }

  // static Future<void> showAlert(BuildContext context, IconData icons,
  //     Color iconcolor, String title, String msg) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Platform.isIOS
  //           ? CupertinoAlertDialog(
  //               title: Row(
  //                 children: [
  //                   Icon(icons,size: 40.0,color: iconcolor,),
  //                   const SizedBox(width: 9.0,),
  //                   Text(title,style: kTxtStlB,),
  //                 ],
  //               ),
  //               content: Text(
  //                 msg,
  //                 style: kTxtStl13N,
  //               ),
  //               actions: [
  //                 CupertinoButton(
  //                     child: Text('OK',style: TextStyle(color:kNewColor ),),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     }),
  //               ],
  //             )
  //           : AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(14.0)),
  //               backgroundColor: Colors.white,
  //               title: Row(
  //                 children: [
  //                   Icon(
  //                     icons,
  //                     size: 40.0,
  //                     color: iconcolor,
  //                   ),
  //                   const SizedBox(
  //                     width: 9.0,
  //                   ),
  //                   Text(
  //                     title,
  //                     style: kTxtStlB,
  //                   ),
  //                 ],
  //               ),
  //               content: Text(
  //                 msg,
  //                 style: kTxtStl16N,
  //               ),
  //               actionsAlignment: MainAxisAlignment.center,
  //               actions: <Widget>[
  //                 ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(14.0)),
  //                         backgroundColor: kNewColor,
  //                         foregroundColor: Colors.white,
  //                         padding: const EdgeInsets.all(14.0)),
  //                     child: Text(
  //                       'OK',
  //                       style: kTxtStl13B,
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     }),
  //               ],
  //             );
  //     },
  //   );
  // }

  static Future<void> showAlert({
    required IconData icons,
    required Color iconcolor,
    required String title,
    required String msg,
  }) async {
    return Get.dialog(
      Platform.isIOS
          ? CupertinoAlertDialog(
              title: Row(
                children: [
                  Icon(icons, size: 40.0, color: iconcolor),
                  const SizedBox(width: 9.0),
                  Text(title, style: kTxtStlB),
                ],
              ),
              content: Text(msg, style: kTxtStl13N),
              actions: [
                CupertinoButton(
                  child: Text('OK', style: TextStyle(color: kNewColor)),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(icons, size: 40.0, color: iconcolor),
                  const SizedBox(width: 9.0),
                  Text(title, style: kTxtStlB),
                ],
              ),
              content: Text(msg, style: kTxtStl16N),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    backgroundColor: kNewColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14.0),
                  ),
                  child: Text('OK', style: kTxtStl13B),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
      barrierDismissible: true,
    );
  }

  // static Future<void> showAlertYesNo(BuildContext context,
  //     {IconData? iconData,
  //     Color? iconcolor,
  //     String title = '',
  //     String msg = '',
  //     Function()? yesBtnFun,
  //     Function()? noBtnFun}) {
  //   return showDialog(
  //     context: context,
  //     builder: (_) {
  //       return Platform.isIOS
  //           ?
  //           CupertinoAlertDialog(
  //               title: Row(
  //                 children: [
  //                   iconData == null
  //                       ? Container()
  //                       : Icon(
  //                           iconData,
  //                           size: 40,
  //                           color: iconcolor,
  //                         ),
  //                   const SizedBox(
  //                     height: 9.0,
  //                   ),
  //                   Flexible(
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           title,
  //                           style: kTxtStl16B,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               content: Text(
  //                 msg,
  //                 style: kTxtStl13N,
  //               ),
  //               actions: [
  //                 CupertinoButton(
  //                   onPressed: yesBtnFun,
  //                   child: Text(
  //                     'YES',
  //                     style: TextStyle(color: kNewColor ),
  //                   ),
  //                 ),
  //                 CupertinoButton(
  //                   onPressed: noBtnFun,
  //                   child: Text(
  //                     'NO',
  //                     style: TextStyle(color:kNewColor ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           : AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(14.0)),
  //               backgroundColor: Colors.white,
  //               title: Row(
  //                 children: [
  //                   iconData == null
  //                       ? Container()
  //                       : Icon(
  //                           iconData,
  //                           size: 40,
  //                           color: iconcolor,
  //                         ),
  //                   const SizedBox(
  //                     height: 9.0,
  //                   ),
  //                   Flexible(
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           title,
  //                           style: kTxtStl16B,
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               content: Text(
  //                 msg,
  //                 style: kTxtStl13N,
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   style: TextButton.styleFrom(
  //                     backgroundColor: kNewColor,
  //                   ),
  //                   onPressed: yesBtnFun,
  //                   child: const Text(
  //                     'YES',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //                 TextButton(
  //                   onPressed: noBtnFun,
  //                   child: Text(
  //                     'NO',
  //                     style: TextStyle(color:kNewColor),
  //                   ),
  //                 ),
  //               ],
  //             );
  //     },
  //   );
  // }

  static void showAlertYesNo({
    IconData? iconData,
    Color? iconcolor,
    String title = '',
    String msg = '',
    Function()? yesBtnFun,
    Function()? noBtnFun,
  }) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
      title: '',
      content: Column(
        children: [
          if (iconData != null) Icon(iconData, size: 40, color: iconcolor),
          const SizedBox(height: 8),
          Text(title, style: kTxtStl16B, textAlign: TextAlign.center),
          const SizedBox(height: 5),
          Text(msg, style: kTxtStl13N, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: kNewColor),
          onPressed: () {
            if (yesBtnFun != null) yesBtnFun();
            Get.back(); // Close dialog
          },
          child: const Text('YES', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            if (noBtnFun != null) noBtnFun();
            Get.back(); // Close dialog
          },
          child: Text('NO', style: TextStyle(color: kNewColor)),
        ),
      ],
      radius: 14.0,
    );
  }
  // static Future checkInternetIsConnected(context,
  //     {required Function onCallFun}) async {
  //   bool isConnected = false;
  //   try {
  //     final response = await InternetAddress.lookup('www.google.com');
  //     if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
  //       isConnected = true;
  //     }
  //   } on SocketException {
  //     isConnected = false;
  //   }
  //   if (isConnected) {
  //     await onCallFun();
  //   } else {
  //     Utility.showAlert(context, Icons.wifi_off, Colors.black, 'Alert',
  //         'Check internet connection');
  //   }
  //   return isConnected;
  // }

  static Future<bool> checkInternetIsConnected({
    required Function onCallFun,
  }) async {
    bool isConnected = false;

    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException {
      isConnected = false;
    }

    if (isConnected) {
      await onCallFun(); // run function
    } else {
      Utility.showAlert(
        icons: Icons.wifi_off,
        iconcolor: Colors.black,
        title: 'Alert',
        msg: 'Check internet connection',
      );
    }

    return isConnected;
  }

  static Widget processLoadingWidget() {
    return Platform.isIOS
        ? const CupertinoActivityIndicator(color: Colors.orange)
        : const CircularProgressIndicator(color: Colors.orange);
  }

  static Map<String, String> getSystemxsDmsHeaders({required String token}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };

    if (token != '') {
      headers = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
    }
    return headers;
  }

  static Future<String> encryptJson({required String jsonText}) async {
    final keya = encrypt.Key.fromUtf8(Utility.encryptionKey);
    // print('keya $keya');
    final iv = encrypt.IV.fromBase64(
      Utility.encryptIV,
    ); //5InVY0cG38jFJQQG//encrypt.IV.fromLength(16)
    // print('iv ${iv.base64}');
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keya, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(jsonText, iv: iv);
    // print('encrypted ${encrypted.base64}');
    // print('jsontext $jsonText');
    return encrypted.base64;
  }

  static Future<String> decryptedJson({required String encryptedJson}) async {
    final keya = encrypt.Key.fromUtf8(Utility.encryptionKey);
    // print('keya $keya');
    final iv = encrypt.IV.fromBase64(
      Utility.encryptIV,
    ); //5InVY0cG38jFJQQG//encrypt.IV.fromLength(16)
    // print('iv ${iv.base64}');
    final encrypter = encrypt.Encrypter(
      encrypt.AES(keya, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );
    final decrypted = encrypter.decrypt64(encryptedJson, iv: iv);
    return decrypted;
  }
  //========================================= static date method ======================================

  static String selectedStringDateLocal = 'Current Financial Year';
  // static DateTime? selectedFromDateOfDateController =
  //     findStartOfThisYear(DateTime.now());
  // static DateTime? selectedToDateOfDateController =
  //     findLastOfThisYear(DateTime.now());
  static List<String> dateList = [
    "Today",
    "Yesterday",
    "Current Week",
    "Last Week",
    "Current Month",
    "Last Month",
    "Current Quarter",
    "Last Quarter",
    "Current Financial Year",
    "Last Financial Year",
    "Current Calender Year",
    "Last Calender Year",
    "Custom Date",
  ];
  static String? dateSelectedFormat = Utility.getDateSelectedFormat(
    selectedStringDateLocal,
  );

  static String getDateSelectedFormat(String selectedFormat) {
    String selectedDateFormat = '';
    if (selectedFormat == 'Today' || selectedFormat == 'Yesterday') {
      selectedDateFormat = 'Day';
    } else if (selectedFormat == 'Current Week' ||
        selectedFormat == 'Last Week') {
      selectedDateFormat = 'WK';
    } else if (selectedFormat == 'Current Month' ||
        selectedFormat == 'Last Month') {
      selectedDateFormat = 'MTH';
    } else if (selectedFormat == 'Current Quarter' ||
        selectedFormat == 'Last Quarter') {
      selectedDateFormat = 'QTR';
    } else if (selectedFormat == 'Current Financial Year' ||
        selectedFormat == 'Last Financial Year') {
      selectedDateFormat = 'FY';
    } else if (selectedFormat == 'Current Calender Year' ||
        selectedFormat == 'Last Calender Year') {
      selectedDateFormat = 'CY';
    } else {
      selectedDateFormat = 'Date';
    }
    return selectedDateFormat;
  }

  // static onPressedBackArrowDate() {
  //   if (Utility.selectedStringDateLocal == "Today") {
  //     Utility.selectedFromDateOfDateController =
  //         findYesterday(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findYesterday(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Yesterday") {
  //     Utility.selectedFromDateOfDateController =
  //         findYesterday(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findYesterday(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfLastWeek(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastDateOfLastWeek(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastMonth(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastMonth(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastMonth(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastMonth(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Quarter") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastQuarter(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastQuarter(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Financial Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastYear(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Financial Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastYear(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfLastWeek(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastQuarter(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Quarter") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastQuarter(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastQuarter(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Calender Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfLastCalenderYear(
  //         Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastCalenderYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Calender Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfLastCalenderYear(
  //         Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfLastCalenderYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Custom Date") {}
  // }

  // on list name clicked
  // static void onPressedPopupMenuDate(selectedStringDate, context) async {
  //   DateTime todayDate = DateTime.now();
  //   if (selectedStringDate == "Today") {
  //     Utility.selectedFromDateOfDateController = DateTime.now();
  //     Utility.selectedToDateOfDateController = DateTime.now();
  //   }
  //   if (selectedStringDate == "Yesterday") {
  //     Utility.selectedFromDateOfDateController =
  //         DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
  //     Utility.selectedToDateOfDateController =
  //         DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
  //   }
  //   if (selectedStringDate == "Current Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfTheWeek(todayDate);
  //     Utility.selectedToDateOfDateController = findLastDateOfTheWeek(todayDate);
  //   }
  //   if (selectedStringDate == "Current Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfThisMonth(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfThisMonth(todayDate);
  //   }
  //   if (selectedStringDate == "Last Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastMonth(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfLastMonth(todayDate);
  //   }
  //   if (selectedStringDate == "Current Quarter") {
  //     Utility.selectedFromDateOfDateController = findStartOfQuarter(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfQuarter(todayDate);
  //   }
  //   if (selectedStringDate == "Current Financial Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfThisYear(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfThisYear(todayDate);
  //   }
  //   if (selectedStringDate == "Last Financial Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfLastYear(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfLastYear(todayDate);
  //   }
  //   if (selectedStringDate == "Last Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfPreviousWeek(todayDate);
  //     Utility.selectedToDateOfDateController =
  //         findLastDateOfPreviousWeek(todayDate);
  //   }
  //   if (selectedStringDate == "Last Quarter") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfLastQuarter(todayDate);
  //     Utility.selectedToDateOfDateController = findLastOfLastQuarter(todayDate);
  //   }
  //   if (selectedStringDate == "Current Calender Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfCurrentCalenderYear(todayDate);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfCurrentCalenderYear(todayDate);
  //   }
  //   if (selectedStringDate == "Last Calender Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfPreviousCalenderYear(todayDate);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfPreviousCalenderYear(todayDate);
  //   }
  //   if (selectedStringDate == "Custom Date") {
  //     await selectDateRange(context, Utility.selectedFromDateOfDateController!,
  //             Utility.selectedToDateOfDateController!)
  //         .then((datetimerange) {
  //       Utility.selectedFromDateOfDateController = datetimerange.start;
  //       Utility.selectedToDateOfDateController = datetimerange.end;
  //     });
  //   }
  // }

  // static onPressedForwardArrowDate() {
  //   if (Utility.selectedStringDateLocal == "Today") {
  //     Utility.selectedFromDateOfDateController =
  //         findTomorrow(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findTomorrow(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Yesterday") {
  //     Utility.selectedFromDateOfDateController =
  //         findTomorrow(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findTomorrow(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfNextWeek(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastDateOfNextWeek(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextMonth(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextMonth(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Month") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextMonth(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextMonth(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Quarter") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextQuarter(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextQuarter(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Financial Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextYear(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Financial Year") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextYear(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Week") {
  //     Utility.selectedFromDateOfDateController =
  //         findFirstDateOfNextWeek(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastDateOfNextWeek(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Quarter") {
  //     Utility.selectedFromDateOfDateController =
  //         findStartOfNextQuarter(Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextQuarter(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Current Calender Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfNextCalenderYear(
  //         Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextCalenderYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Last Calender Year") {
  //     Utility.selectedFromDateOfDateController = findStartOfNextCalenderYear(
  //         Utility.selectedFromDateOfDateController!);
  //     Utility.selectedToDateOfDateController =
  //         findLastOfNextCalenderYear(Utility.selectedToDateOfDateController!);
  //   }
  //   if (Utility.selectedStringDateLocal == "Custom Date") {}
  // }

  static DateTime findYesterday(DateTime dateTime) {
    return dateTime.subtract(const Duration(days: 1));
  }

  static DateTime findTomorrow(DateTime dateTime) {
    return dateTime.add(const Duration(days: 1));
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(
      Duration(days: DateTime.daysPerWeek - dateTime.weekday),
    );
  }

  // static DateTime findFirstDateOfLastWeek(DateTime dateTime) {
  //   Utility.selectedFromDateOfDateController =
  //       findFirstDateOfTheWeek(Utility.selectedFromDateOfDateController!);
  //   Utility.selectedFromDateOfDateController = Utility
  //       .selectedFromDateOfDateController!
  //       .subtract(const Duration(days: 1));
  //   Utility.selectedFromDateOfDateController =
  //       findFirstDateOfTheWeek(Utility.selectedFromDateOfDateController!);
  //   return Utility.selectedFromDateOfDateController!;
  // }

  // static DateTime findLastDateOfLastWeek(DateTime dateTime) {
  //   Utility.selectedToDateOfDateController =
  //       findFirstDateOfTheWeek(Utility.selectedToDateOfDateController!);
  //   Utility.selectedToDateOfDateController = Utility
  //       .selectedToDateOfDateController!
  //       .subtract(const Duration(days: 1));
  //   Utility.selectedToDateOfDateController =
  //       findLastDateOfTheWeek(Utility.selectedToDateOfDateController!);
  //   return Utility.selectedToDateOfDateController!;
  // }

  // static DateTime findFirstDateOfNextWeek(DateTime dateTime) {
  //   Utility.selectedFromDateOfDateController =
  //       findLastDateOfTheWeek(Utility.selectedFromDateOfDateController!);
  //   Utility.selectedFromDateOfDateController =
  //       Utility.selectedFromDateOfDateController!.add(const Duration(days: 1));
  //   Utility.selectedFromDateOfDateController =
  //       findFirstDateOfTheWeek(Utility.selectedFromDateOfDateController!);
  //   return Utility.selectedFromDateOfDateController!;
  // }

  // static DateTime findLastDateOfNextWeek(DateTime dateTime) {
  //   Utility.selectedToDateOfDateController =
  //       findLastDateOfTheWeek(Utility.selectedToDateOfDateController!);
  //   Utility.selectedToDateOfDateController =
  //       Utility.selectedToDateOfDateController!.add(const Duration(days: 1));
  //   Utility.selectedToDateOfDateController =
  //       findLastDateOfTheWeek(Utility.selectedToDateOfDateController!);
  //   return Utility.selectedToDateOfDateController!;
  // }

  static DateTime findStartOfThisMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime findLastOfThisMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  static DateTime findStartOfLastMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month - 1, 1);
  }

  static DateTime findLastOfLastMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 0);
  }

  static DateTime findStartOfNextMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 1);
  }

  static DateTime findLastOfNextMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 2, 0);
  }

  static DateTime findStartOfQuarter(DateTime dateTime) {
    int quarterNumber = ((dateTime.month - 1) / 3 + 1).toInt();
    return DateTime(dateTime.year, (quarterNumber - 1) * 3 + 1, 1);
  }

  static DateTime findLastOfQuarter(DateTime dateTime) {
    int quarterNumber = ((dateTime.month - 1) / 3 + 1).toInt();
    DateTime firstDayOfQuarter = DateTime(
      dateTime.year,
      (quarterNumber - 1) * 3 + 1,
      1,
    );
    return DateTime(firstDayOfQuarter.year, firstDayOfQuarter.month + 3, 0);
  }

  static DateTime findStartOfLastQuarter(DateTime dateTime) {
    int quarterNumber = ((dateTime.month - 1) / 3 + 1).toInt();
    DateTime date = DateTime(dateTime.year, (quarterNumber - 1) * 3 + 1, 1);
    date = date.subtract(const Duration(days: 1));
    quarterNumber = ((date.month - 1) / 3 + 1).toInt();
    return DateTime(date.year, (quarterNumber - 1) * 3 + 1, 1);
  }

  static DateTime findLastOfLastQuarter(DateTime dateTime) {
    DateTime date = findStartOfQuarter(dateTime);
    date = date.subtract(const Duration(days: 1));
    int quarterNumber = ((date.month - 1) / 3 + 1).toInt();
    DateTime firstDayOfQuarter = DateTime(
      date.year,
      (quarterNumber - 1) * 3 + 1,
      1,
    );
    return DateTime(firstDayOfQuarter.year, firstDayOfQuarter.month + 3, 0);
  }

  static DateTime findStartOfNextQuarter(DateTime dateTime) {
    int quarterNumber = ((dateTime.month - 1) / 3 + 1).toInt();
    DateTime firstDayOfQuarter = DateTime(
      dateTime.year,
      (quarterNumber - 1) * 3 + 1,
      1,
    );
    DateTime date = DateTime(
      firstDayOfQuarter.year,
      firstDayOfQuarter.month + 3,
      0,
    );
    date = date.add(const Duration(days: 1));
    quarterNumber = ((date.month - 1) / 3 + 1).toInt();
    return DateTime(date.year, (quarterNumber - 1) * 3 + 1, 1);
  }

  static DateTime findLastOfNextQuarter(DateTime dateTime) {
    int quarterNumber = ((dateTime.month - 1) / 3 + 1).toInt();
    DateTime firstDayOfQuarter = DateTime(
      dateTime.year,
      (quarterNumber - 1) * 3 + 1,
      1,
    );
    DateTime date = DateTime(
      firstDayOfQuarter.year,
      firstDayOfQuarter.month + 3,
      0,
    );
    date = date.add(const Duration(days: 1));
    quarterNumber = ((date.month - 1) / 3 + 1).toInt();
    firstDayOfQuarter = DateTime(date.year, (quarterNumber - 1) * 3 + 1, 1);
    return DateTime(firstDayOfQuarter.year, firstDayOfQuarter.month + 3, 0);
  }

  static DateTime findStartOfThisYear(DateTime dateTime) {
    DateTime date;
    if (dateTime.month < 4) {
      date = DateTime(dateTime.year - 1, 4, 1);
    } else {
      date = DateTime(dateTime.year, 4, 1);
    }
    return date;
  }

  static DateTime findLastOfThisYear(DateTime dateTime) {
    DateTime date;
    if (dateTime.month < 4) {
      date = DateTime(dateTime.year, 4, 0);
    } else {
      date = DateTime(dateTime.year + 1, 4, 0);
    }
    return date;
  }

  static DateTime findStartOfLastYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year - 1, 4, 1);
    return date;
  }

  static DateTime findLastOfLastYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year - 1, 4, 0);
    return date;
  }

  static DateTime findStartOfNextYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year + 1, 4, 1);
    return date;
  }

  static DateTime findLastOfNextYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year + 1, 4, 0);
    return date;
  }

  static DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(
      const Duration(days: 7),
    );
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  static DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(
      const Duration(days: 7),
    );
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  static DateTime findStartOfCurrentCalenderYear(DateTime dateTime) {
    DateTime date;
    date = DateTime(dateTime.year, 1);
    return date;
  }

  static DateTime findLastOfCurrentCalenderYear(DateTime dateTime) {
    DateTime date;
    date = DateTime(dateTime.year + 1, 1, 0);
    return date;
  }

  static DateTime findStartOfLastCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year, 1);
    return date;
  }

  static DateTime findLastOfLastCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year - 1, 1, 0);
    return date;
  }

  static DateTime findStartOfNextCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year + 2, 1);
    return date;
  }

  static DateTime findLastOfNextCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year + 1, 1, 0);
    return date;
  }

  static DateTime findStartOfPreviousCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfCurrentCalenderYear(dateTime);
    date = DateTime(date.year - 1, 1);
    return date;
  }

  static DateTime findLastOfPreviousCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfCurrentCalenderYear(dateTime);
    date = DateTime(date.year, 0);
    return date;
  }

  static Map<String, String> getHeaders({token}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-type": "application/json",
    };

    if (token) {
      headers = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${Utility.logintoken}",
      };
    }
    return headers;
  }

  //pooja // 21-10-2024 // add for sales and purchase dashboard
  static List<ChartSampleData> chartData = <ChartSampleData>[];
  static void getDataForDefault(
    List xdata,
    List ydata, {
    List? y1AxisDataForDoughnutDefault,
  }) {
    flChartData = [];
    for (int i = 0; i < xdata.length; i++) {
      flChartData.add(
        FlChartData(
          x: xdata[i].toString(),
          y: double.parse(ydata[i].toString()),
        ),
      );
    }
  }

  static Future onPressedPopupMenuDate(selectedStringDate, context) async {
    // void
    DateTime todayDate = DateTime.now();
    if (selectedStringDate == "Today") {
      Utility.selectedFromDateOfDateController = DateTime.now();
      Utility.selectedToDateOfDateController = DateTime.now();
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(todayDate).toString()} - ${DateFormat('dd/MM/yyyy').format(todayDate).toString()}";
    }
    if (selectedStringDate == "Yesterday") {
      Utility.selectedFromDateOfDateController = DateTime(
        todayDate.year,
        todayDate.month,
        todayDate.day - 1,
      );
      Utility.selectedToDateOfDateController = DateTime(
        todayDate.year,
        todayDate.month,
        todayDate.day - 1,
      );
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(Utility.selectedFromDateOfDateController!).toString()} - ${DateFormat('dd/MM/yyyy').format(Utility.selectedToDateOfDateController!).toString()}";
    }
    if (selectedStringDate == "Current Week") {
      Utility.selectedFromDateOfDateController = findFirstDateOfTheWeek(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastDateOfTheWeek(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findFirstDateOfTheWeek(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfTheWeek(todayDate)).toString()}";
    }
    if (selectedStringDate == "Current Month") {
      Utility.selectedFromDateOfDateController = findStartOfThisMonth(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastOfThisMonth(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfThisMonth(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfThisMonth(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Month") {
      Utility.selectedFromDateOfDateController = findStartOfLastMonth(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastOfLastMonth(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastMonth(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastMonth(todayDate)).toString()}";
    }
    if (selectedStringDate == "Current Quarter") {
      Utility.selectedFromDateOfDateController = findStartOfQuarter(todayDate);
      Utility.selectedToDateOfDateController = findLastOfQuarter(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfQuarter(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfQuarter(todayDate)).toString()}";
    }
    if (selectedStringDate == "Current Financial Year") {
      Utility.selectedFromDateOfDateController = findStartOfThisYear(todayDate);
      Utility.selectedToDateOfDateController = findLastOfThisYear(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfThisYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfThisYear(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Financial Year") {
      Utility.selectedFromDateOfDateController = findStartOfLastYear(todayDate);
      Utility.selectedToDateOfDateController = findLastOfLastYear(todayDate);
      // Utility.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastYear(todayDate)).toString()}";
    }

    // komal // new format added
    if (selectedStringDate == "Last Week") {
      Utility.selectedFromDateOfDateController = findFirstDateOfPreviousWeek(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastDateOfPreviousWeek(
        todayDate,
      );
      // Utility.dateController.text = "${DateFormat('dd/MM/yyyy').format(findFirstDateOfPreviousWeek(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfPreviousWeek(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Quarter") {
      Utility.selectedFromDateOfDateController = findStartOfLastQuarter(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastOfLastQuarter(todayDate);
      // Utility.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfLastQuarter(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastQuarter(todayDate)).toString()}";
    }
    if (selectedStringDate == "Current Calender Year") {
      Utility.selectedFromDateOfDateController = findStartOfCurrentCalenderYear(
        todayDate,
      );
      Utility.selectedToDateOfDateController = findLastOfCurrentCalenderYear(
        todayDate,
      );
      // Utility.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfCurrentCalenderYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfCurrentCalenderYear(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Calender Year") {
      Utility.selectedFromDateOfDateController =
          findStartOfPreviousCalenderYear(todayDate);
      Utility.selectedToDateOfDateController = findLastOfPreviousCalenderYear(
        todayDate,
      );
      // Utility.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfPreviousCalenderYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfPreviousCalenderYear(todayDate)).toString()}";
    }
    if (selectedStringDate == "Custom Date") {
      // await selectDateRange(context, Utility.selectedFromDateOfDateController!, Utility.selectedToDateOfDateController!).then((datetimerange) {
      //   Utility.selectedFromDateOfDateController = datetimerange.start;
      //   Utility.selectedToDateOfDateController = datetimerange.end;
      // });
      await selectDateRange(
        Utility.selectedFromDateOfDateController!,
        Utility.selectedToDateOfDateController!,
      ).then((datetimerange) {
        Utility.selectedFromDateOfDateController = datetimerange.start;
        Utility.selectedToDateOfDateController = datetimerange.end;
      });
    }
  }

   // Manoj 23-06-2026 Add Custom getx snackbar
  static void showErrorSnackBar(String message, {Color bgColor = Colors.red}) {
    Get.snackbar(
      'Error', // no title
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      borderRadius: 10,
      maxWidth: 300,
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

//pratiksha p 30-04-2026 add
class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator(radius: 14)
                : const CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }
}
