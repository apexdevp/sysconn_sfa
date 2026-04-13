import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart';

//pratiksha p add

class CustomeDialogbox extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onDelete;
  final double? maxWidth;
  final double? maxHeight;
  final double? minWidth;
  final String buttontitle;
  final Future<void> Function()? function;
  final List<Widget>? actions;

  const CustomeDialogbox({
    super.key,
    required this.title,
    required this.content,
    this.onDelete,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.buttontitle = "",
    this.function,
    this.actions,
  });

  // @override
  // Widget build(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;

  //   final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  //   return AlertDialog(
  //     // insetPadding: const EdgeInsets.all(20),
  //     insetPadding: EdgeInsets.symmetric(
  //       horizontal: screenWidth * 0.04, // 4% of screen width on each side
  //       vertical: screenHeight * 0.03,
  //     ),
  //     titlePadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
  //     contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //     backgroundColor: Colors.white,
  //     //       title: Stack(
  //     //   children: [
  //     //     Align(
  //     //       alignment: Alignment.centerLeft,
  //     //       child: Row(
  //     //          mainAxisSize: MainAxisSize.min,
  //     //         children: [
  //     //           Text(title, style: kTxtStl15B),
  //     //         ],
  //     //       ),
  //     //     ),

  //     //     Align(
  //     //       alignment: Alignment.centerRight,
  //     //       child: Row(
  //     //         mainAxisSize: MainAxisSize.min,
  //     //         children: [
  //     //           if (onDelete != null)
  //     //             IconButton(
  //     //               icon: const Icon(Icons.delete_forever),
  //     //               onPressed: onDelete,
  //     //             ),
  //     //           IconButton(
  //     //             icon: const Icon(Icons.close),
  //     //             onPressed: () => Get.back(),
  //     //           ),
  //     //         ],
  //     //       ),
  //     //     ),
  //     //   ],
  //     // ),
  //     //       content: ConstrainedBox(
  //     //         constraints: BoxConstraints(
  //     //           maxWidth: maxWidth ?? 600,
  //     //           maxHeight: maxHeight ?? 350,
  //     //           minWidth: minWidth ?? 200,
  //     //         ),
  //     //         child: SingleChildScrollView(
  //     //           child: Column(
  //     //             mainAxisSize: MainAxisSize.min,
  //     //             children: [
  //     //               content,
  //     //               const SizedBox(height: 20),

  //     //              if (buttontitle.isNotEmpty)
  //     //   Align(
  //     //     alignment: Alignment.bottomRight,
  //     //     child: SizedBox(
  //     //       width: 100,
  //     //       child: ResponsiveButton(
  //     //         title: buttontitle,
  //     //         color: kButton2Color,
  //     //         function: function ?? () async {}, // function is already Future<void>
  //     //       ),
  //     //     ),
  //     //   )

  //     //             ],
  //     //           ),
  //     //         ),
  //     //       ),
  //     //     );
  //     //   }
  //     // }

  //     // Manoj 23-02-2026 Add Fixed Botton in bottom of dialo box

  //     // Manoj 19-02-2026 Header Fix
  //     title: Stack(
  //       children: [
  //         Align(
  //           alignment: Alignment.centerLeft,
  //           child: Text(title, style: kTxtStl15B),
  //         ),
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               if (actions != null) ...actions!,

  //               if (onDelete != null)
  //                 IconButton(
  //                   icon: const Icon(Icons.delete_forever),
  //                   onPressed: onDelete,
  //                 ),
  //               IconButton(
  //                 icon: const Icon(Icons.close),
  //                 onPressed: () => Get.back(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),

  //     // Manoj 19-02-2026 Body
  //     // content: ConstrainedBox(
  //     content: SizedBox(
  //       // constraints: BoxConstraints(
  //       //   maxWidth: maxWidth ?? 450,
  //       //   maxHeight: maxHeight ?? 500,
  //       //   minWidth: minWidth ?? 250,
  //       // ),
  //       width: maxWidth ?? screenWidth * 0.92, // dynamic width
  //       // height: maxHeight ?? screenHeight * 0.75,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Manoj 19-02-2026 Scrollable Body
  //           // Expanded(child: SingleChildScrollView(child: content)),
  //           ConstrainedBox(
  //              constraints: BoxConstraints(
  //         //  clampDouble prevents negative height during keyboard close animation
  //         maxHeight: clampDouble(
  //           (maxHeight ?? screenHeight * 0.75) - keyboardHeight,
  //           100, //  minimum height — never goes below 100
  //           screenHeight * 0.75,
  //         ),),
  //             child: SingleChildScrollView(child: content),
  //           ),
  //           const SizedBox(height: 16),

  //           // Manoj 19-02-2026 Fixed Bottom Button
  //           if (buttontitle.isNotEmpty)
  //             Align(
  //               alignment: Alignment.bottomLeft,
  //               child: SizedBox(
  //                 width: 120,
  //                 child: ResponsiveButton(
  //                   title: buttontitle,
  //                   color: kButton2Color,
  //                   function: function ?? () async {},
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - bottomInset;

    return GestureDetector(
      onTap: () => Get.back(), //  tap outside to close
      child: Material(
        color: Colors.black54, //  dim background
        child: GestureDetector(
          onTap: () {}, //  prevent close when tapping dialog
          child: Align(
            alignment: bottomInset > 0
                ? Alignment
                      .bottomCenter //  stick to keyboard when open
                : Alignment.center, //  center when keyboard closed
            child: Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                bottom: bottomInset > 0 ? bottomInset : 0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? screenWidth * 0.92,
                  maxHeight:
                      availableHeight *
                      0.95, //  use 95% of space above keyboard
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Title ──
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 80),
                                child: Text(title, style: kTxtStl15B),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (actions != null) ...actions!,
                                  if (onDelete != null)
                                    IconButton(
                                      icon: const Icon(Icons.delete_forever),
                                      onPressed: onDelete,
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 0),

                      // ── Scrollable Content ──
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: content,
                        ),
                      ),

                      // ── Bottom Button ──
                      if (buttontitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              width: 120,
                              child: ResponsiveButton(
                                title: buttontitle,
                                color: kButton2Color,
                                function: function ?? () async {},
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
