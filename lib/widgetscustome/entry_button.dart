import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

//pratiksha p add
class MakeEntryButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final IconData icon; //Manisha C 23-03-2026 added
  final Color backgroundColor; //Manisha C 23-03-2026 added
  final bool isLightStyle; //Manisha C 23-03-2026 added

  const MakeEntryButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon = Icons.add, //Manisha C 23-03-2026 added
    this.backgroundColor = Colors.black, //Manisha C 23-03-2026 added
    this.isLightStyle = false, //Manisha C 23-03-2026 added
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLightStyle
              ? InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 18, color: Colors.black),
                        const SizedBox(width: 6),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor:Colors.black,// kContrastLightColor, //kContrastDarkColor,
                    backgroundColor:
                        backgroundColor, //Manisha C 23-03-2026 added
                    foregroundColor: Colors.black,
                    elevation: 4,
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color:Colors.black ),//kContrastDarkColor
                    ),
                  ),
                  onPressed: onTap,
                  // icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  icon: Icon(
                    icon,
                    size: 16,
                    color: Colors.white,
                  ), //Manisha C 23-03-2026 added
                  label: Text(title, style: kTxtStl13WB),
                ),
          // child: ElevatedButton.icon(
          //   style: ElevatedButton.styleFrom(
          //     // backgroundColor:Colors.black,// kContrastLightColor, //kContrastDarkColor,
          //     backgroundColor: backgroundColor, //Manisha C 23-03-2026 added
          //     foregroundColor: Colors.black,
          //     elevation: 4,
          //     padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       // side: BorderSide(color:Colors.black ),//kContrastDarkColor
          //     ),
          //   ),
          //   onPressed: onTap,
          //   // icon: const Icon(Icons.add, size: 16, color: Colors.white),
          //   icon: Icon(
          //     icon,
          //     size: 16,
          //     color: Colors.white,
          //   ), //Manisha C 23-03-2026 added
          //   label: Text(title, style: kTxtStl13WB),
          // ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:sysconn_oms/app/utilities/textstyle.dart';

// //pratiksha p add
// class MakeEntryButton extends StatelessWidget {
//   final String title;
//   final Function() onTap;
//   const MakeEntryButton({super.key, required this.title, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor:Colors.black,// kContrastLightColor, //kContrastDarkColor,
//               foregroundColor: Colors.black,
//               elevation: 4,
//               padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//                // side: BorderSide(color:Colors.black ),//kContrastDarkColor
//               ),
//             ),
//             onPressed: onTap,
//             icon: const Icon(Icons.add, size: 16, color: Colors.white),
//             label: Text(title, style: kTxtStl13WB),
//           ),
//         ),
//       ],
//     );
//   }
// }
