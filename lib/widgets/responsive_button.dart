// import 'package:flutter/material.dart';
// import 'package:sysconn_sfa/Utility/app_colors.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';

// class ResponsiveButton extends StatelessWidget {
//   final String title;
//   final Function function;

//   const ResponsiveButton({
//     super.key,
//     required this.title,
//     required this.function,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: InkWell(
//               child: Container(
//                 // height: MediaQuery.of(context).size.width * 0.024,
//                 // width: MediaQuery.of(context).size.width * 0.1,
//                 padding: const EdgeInsets.all(10.0),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(14.0)),
//                   gradient: kButtonColor,
//                 ),
//                 child: Text(
//                   title,
//                   style: kTxtStl16WB,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               onTap: () {
//                 function();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';

class ResponsiveButton extends StatelessWidget {
  final String title;
  final Function function;
  const ResponsiveButton({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient:kblackButtonColor //kButtonColor,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                function();
              },
            ),
          ),
        ],
      ),
    );
  }
}
