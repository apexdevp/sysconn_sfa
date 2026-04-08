import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/utility.dart';


// scaffoldMessageBar(BuildContext context,String message,{bool isError = true}){
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     behavior: SnackBarBehavior.floating,
//     margin: const EdgeInsets.all(9.0),
//     backgroundColor: isError?Colors.red.shade200:Colors.teal.shade200,
//     duration: const Duration(milliseconds: 1000),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(14.0)
//     ),
//     content: Text(message)
//   ));
// }

void scaffoldMessageBar(String message, {bool isError = true}) {
  Get.snackbar(
    '', // Title (empty for your design)
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.red.shade200 : Colors.teal.shade200,
    margin: const EdgeInsets.all(9.0),
    duration: const Duration(milliseconds: 1000),
    borderRadius: 14.0,
    colorText: Colors.black,
    isDismissible: true,
    animationDuration: const Duration(milliseconds: 300),
  );
}

void scaffoldMessageValidationBar(BuildContext context,String message,{bool isError = true}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(9.0),
    backgroundColor: isError?Colors.red.shade400:Colors.teal.shade200,
    duration: const Duration(milliseconds: 1000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14.0)
    ),
    content: Text(message)
  ));
}
// void snackbarMessageBar(String message, {bool isError = true}) {
//   Get.rawSnackbar(
//     messageText: Text(
//       message,
//       style: const TextStyle(color: Colors.white),
//     ),
//     backgroundColor: isError ? Colors.red : Colors.green,
//     snackPosition: SnackPosition.BOTTOM,
//     duration: const Duration(seconds: 2),
//     dismissDirection: DismissDirection.horizontal,
//   );
// }
//snehal 24-05-2024 add time format
  //============================================ time format ===================================
  String timeFormat(String time){
    String timeFormat = '';
    if(time == '' || time == '00:00:00'){
      timeFormat = '';
    }else{
      timeFormat = DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(time));    // komal // 11-3-2024 // time changed as hh to HH bcze it was giving an 12 pm as am error
    }
    return timeFormat;
  }


//================================== indian rupees format =============================================

String indianRupeeFormat(double amount){
    return '₹ ${(NumberFormat('#,###.0#').format(amount)).toString()}';
  }

//====================================== range date select calendar ===================================

// Future<DateTimeRange> selectDateRange(BuildContext context,DateTime fromDateSelected,DateTime toDateSelected) async {
//     DateTimeRange initialRange = DateTimeRange(start: fromDateSelected, end: toDateSelected);    
//     DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: initialRange,
//       firstDate: DateTime(fromDateSelected.year - 1),
//       lastDate: DateTime(2101),
//       fieldStartLabelText: 'Enter Date (mm/dd/yyyy)',
//       fieldEndLabelText: 'Enter Date (mm/dd/yyyy)',
//       builder: (context,child){
//         return Theme(
//           data: ThemeData(
//             textTheme: const TextTheme(labelSmall: TextStyle(fontSize: 14)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.6,
//                 maxWidth: MediaQuery.of(context).size.width * 0.9,
//                 ),
//                 child: SingleChildScrollView(child: child),
//               )
//             ],
//           ),
//         );
//       },
//     );
//     return picked ?? initialRange;
//   }

Future<DateTimeRange> selectDateRange(
    DateTime fromDateSelected, DateTime toDateSelected) async {
  
  final context = Get.context!;

  DateTimeRange initialRange = DateTimeRange(start: fromDateSelected, end: toDateSelected);

  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    initialDateRange: initialRange,
    firstDate: DateTime(fromDateSelected.year - 1),
    lastDate: DateTime(2101),
    fieldStartLabelText: 'Enter Date (mm/dd/yyyy)',
    fieldEndLabelText: 'Enter Date (mm/dd/yyyy)',
    builder: (context, child) {
      return Theme(
        data: ThemeData(
          textTheme: const TextTheme(labelSmall: TextStyle(fontSize: 14)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: SingleChildScrollView(child: child),
            ),
          ],
        ),
      );
    },
  );

  return picked ?? initialRange;
}

  //================================================single date selected calendar ===================================

  // Future<DateTime> selectDateSingle(BuildContext context,{required DateTime dateSelected,DateTime? firstDate,DateTime? lastDate}) async {
  //   DateTime date = dateSelected;
  //   if(Platform.isIOS){
  //     await showCupertinoModalPopup(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 500,
  //           color: Colors.white,
  //           child: Column(
  //             children: [
  //               CupertinoButton(
  //                 child: const Text('Save'), 
  //                 onPressed: (){
  //                   Navigator.of(context).pop();
  //                 }),
  //               SizedBox(
  //                 height: 400,
  //                 child: CupertinoDatePicker(
  //                   mode: CupertinoDatePickerMode.date,
  //                   initialDateTime: dateSelected,
  //                   minimumYear: dateSelected.year - 1,
  //                   maximumYear: dateSelected.year + 1,
  //                   minimumDate: firstDate ?? DateTime(dateSelected.year - 1),
  //                   maximumDate: lastDate ?? DateTime(dateSelected.year + 1),
  //                   onDateTimeChanged: (DateTime? picked){
  //                     if(picked != null){
  //                       date = picked;
  //                     }
  //                   }
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     );
  //   }else{
  //     DateTime? picked = await showDatePicker(
  //       context: context, 
  //       initialDate: dateSelected, 
  //       firstDate: firstDate ?? DateTime(dateSelected.year - 1), 
  //       lastDate: lastDate ?? DateTime(dateSelected.year + 1),
  //       fieldLabelText: 'Enter Date (mm/dd/yyyy)',
  //       builder: (context,child){
  //         return Theme(
  //           data: ThemeData(
  //             colorScheme: ColorScheme.fromSwatch().copyWith(
  //               primary: kLightAppColor,//Colors.cyan.shade200,
  //               // background: Colors.white,
  //             ),
  //             textTheme: const TextTheme(labelSmall: TextStyle(fontSize: 14)),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                   maxHeight: MediaQuery.of(context).size.height * 0.7,
  //                   maxWidth: MediaQuery.of(context).size.width * 0.9,
  //                 ),
  //                 child: SingleChildScrollView(child: child),
  //               )
  //             ],
  //           ),
  //         );
  //       }
  //     );

  //     if(picked != null){
  //       date = picked;
  //     }
  //   }
  //   return date;
  // }
  Future<DateTime> selectDateSingle({
  required DateTime dateSelected,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final context = Get.context!;

  DateTime date = dateSelected;

  // ----------------------------
  // iOS Date Picker (Cupertino)
  // ----------------------------
  if (Platform.isIOS) {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 500,
          color: Colors.white,
          child: Column(
            children: [
              CupertinoButton(
                child: const Text('Save'),
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: 400,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: dateSelected,
                  minimumYear: dateSelected.year - 1,
                  maximumYear: dateSelected.year + 1,
                  minimumDate: firstDate ?? DateTime(dateSelected.year - 1),
                  maximumDate: lastDate ?? DateTime(dateSelected.year + 1),
                  onDateTimeChanged: (picked) {
                    date = picked;
                                    },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------
  // Android / Windows / Others
  // ----------------------------
  else {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateSelected,
      firstDate: firstDate ?? DateTime(dateSelected.year - 1),
      lastDate: lastDate ?? DateTime(dateSelected.year + 1),
      fieldLabelText: 'Enter Date (mm/dd/yyyy)',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: kLightAppColor,
            ),
            textTheme: const TextTheme(labelSmall: TextStyle(fontSize: 14)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: SingleChildScrollView(child: child),
              )
            ],
          ),
        );
      },
    );

    if (picked != null) {
      date = picked;
    }
  }

  return date;
}
   //============================================= convert amount unit ==============================

  String amtFormat({required String value,bool isUnitEnable = false}){
    String val = num.parse(value) != 0?value:'0';
    if(Utility.dashAmtScaleSelected == 'Crores'){
      val =  '${(num.parse(value) / 10000000).toStringAsFixed(2)}${isUnitEnable?' Cr':''}';
    }else if(Utility.dashAmtScaleSelected == 'Lakhs'){
      val =  '${(num.parse(value) / 100000).toStringAsFixed(2)}${isUnitEnable?' La':''}';
    }
    return val;
  }