import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/widgetscustome/loadingicon.dart';

class ResponsiveButton extends StatefulWidget {
  final String title;
  final Future<void> Function() function; // Async function
  final Color? color;
  final Color? textColor; //Manisha C 24-03-2026 added
  final Color? borderColor; //Manisha C 24-03-2026 added
  final EdgeInsets? padding; //Manisha C 24-03-2026 added
  final double? fontSize; //Manisha C 24-03-2026 added

  const ResponsiveButton({
    super.key,
    required this.title,
    required this.function,
    this.color,
    this.textColor, //Manisha C 24-03-2026 added
    this.borderColor, //Manisha C 24-03-2026 added
    this.padding, //Manisha C 24-03-2026 added
    this.fontSize, //Manisha C 24-03-2026 added
  });

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              try {
                await widget.function();
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        //Manisha C 24-03-2026 added
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: widget.color ?? kButton2Color,
          //Manisha C 24-03-2026 added
          border: Border.all(color: widget.borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: _isLoading
              // ?  LoadingIcon( height: 16,color: Colors.white,
              //     // child: CircularProgressIndicator(
              //     //   strokeWidth: 2,
              //     //   color: Colors.white,
              //     // ),
              //   )
              //Manisha C 24-03-2026 added
              ? LoadingIcon(height: 16, color: widget.textColor ?? Colors.white)
              : Text(
                  widget.title,
                  // style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
                  //Manisha C 24-03-2026 added
                  style: TextStyle(
                    // fontSize: 14.0,
                    fontSize: widget.fontSize ?? 14.0,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor ?? Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}

// class ResponsiveButton extends StatelessWidget {
//   final String title;
//   final Function function;
//   final Color? color;

//   const ResponsiveButton({
//     super.key,
//     required this.title,
//     required this.function,
//     this.color
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
//                 padding: const EdgeInsets.all(6.0),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                   color:color?? kButtonColor,
//                 ),
//                 child: Text(
//                   title,
//                   style: kTxtStl14WB,
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


// import 'package:flutter/material.dart';
// import 'package:sysconn_oms/app/custom_widgets/loadingicon.dart';
// import 'package:sysconn_oms/app/utilities/default_colors.dart';


// class ResponsiveButton extends StatefulWidget {
//   final String title;
//   final Future<void> Function() function; // Async function
//   final Color? color;

//   const ResponsiveButton({
//     super.key,
//     required this.title,
//     required this.function,
//     this.color,
//   });

//   @override
//   State<ResponsiveButton> createState() => _ResponsiveButtonState();
// }

// class _ResponsiveButtonState extends State<ResponsiveButton> {
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: _isLoading
//           ? null
//           : () async {
//               setState(() => _isLoading = true);
//               try {
//                 await widget.function();
//               } finally {
//                 if (mounted) setState(() => _isLoading = false);
//               }
//             },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color:widget.color?? kButton2Color,
//         ),
//         child: Center(
//           child: _isLoading
//               ?  LoadingIcon( height: 16,color: Colors.white,
//                   // child: CircularProgressIndicator(
//                   //   strokeWidth: 2,
//                   //   color: Colors.white,
//                   // ),
//                 )
//               : Text(
//                   widget.title,
//                   style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//         ),
//       ),
//     );
//   }
// }


// // class ResponsiveButton extends StatelessWidget {
// //   final String title;
// //   final Function function;
// //   final Color? color;

// //   const ResponsiveButton({
// //     super.key,
// //     required this.title,
// //     required this.function,
// //     this.color
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Expanded(
// //             child: InkWell(
// //               child: Container(
// //                 // height: MediaQuery.of(context).size.width * 0.024,
// //                 // width: MediaQuery.of(context).size.width * 0.1,
// //                 padding: const EdgeInsets.all(6.0),
// //                 decoration: BoxDecoration(
// //                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
// //                   color:color?? kButtonColor,
// //                 ),
// //                 child: Text(
// //                   title,
// //                   style: kTxtStl14WB,
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               onTap: () {
// //                 function();
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
