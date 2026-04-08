// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart'; 
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/api/controllers/utility/date_controller.dart';

// class DateCalendar extends StatelessWidget {
//   const DateCalendar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final DateController dateController = Get.find();

//     return Obx(() {
//       String date = dateController.date.value;

//       return Container(
//         width: 60, //MediaQuery.of(context).size.width * 0.13,
//         height: 70, //MediaQuery.of(context).size.height * 0.07,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(9.0),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 60, //MediaQuery.of(context).size.width * 0.13,
//               height: 20, //MediaQuery.of(context).size.height * 0.03,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(9.0),
//                   topRight: Radius.circular(9.0),
//                 ),
//                 color: Colors.pink[50],
//               ),
//               child: Text(
//                 date != ''
//                     ? DateFormat('MMM').format(DateTime.parse(date)).toString()
//                     : '',
//                 style: kTxtStl12B,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         date != ''
//                             ? DateFormat('d').format(DateTime.parse(date)).toString()
//                             : '',
//                         style: kTxtStl12B,
//                       ),
//                     ],
//                   ),
//                   const Divider(
//                     height: 3.0,
//                   ),
//                   Text(
//                     date != ''
//                         ? DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.parse(date)).toString()
//                         : '',
//                     style: kTxtStl12B,
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class DateCalendar extends StatelessWidget {
  final String date;
  
  const DateCalendar({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,//MediaQuery.of(context).size.width * 0.13,
      height: 70,//MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Column(
        children: [
          Container(
            width: 60,//MediaQuery.of(context).size.width * 0.13,
            height: 20,//MediaQuery.of(context).size.height * 0.03,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9.0),
                topRight: Radius.circular(9.0)),
              color: kLightAppColor,//Colors.pink[50],
            ),
            child: Text(date != ''?DateFormat('MMM').format(DateTime.parse(date)).toString():'',
            style: kTxtStl12B,textAlign: TextAlign.center,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(date != ''?DateFormat('d').format(DateTime.parse(date)).toString():'',
                    style: kTxtStl12B,),
                    // Text(' / ',style: kTxtStl12N,),
                    // Text(date != ''?DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.parse(date)).toString():'',
                    // style: kTxtStl12B,),
                  ],
                ),
                Divider(
                  height: 3.0,
                ),
                Text(date  != ''?
                DateFormat(DateFormat.ABBR_WEEKDAY).format(DateTime.parse(date)).toString():'',
                style: kTxtStl12B,textAlign: TextAlign.center,),
              ],
            )
          )
        ],
      ),
    );
  }
}