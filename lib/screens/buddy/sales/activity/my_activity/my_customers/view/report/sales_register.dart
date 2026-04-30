import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_report_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_entry_screen.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

// ── App theme colours ────────────────────────────────────────────────────────
const _kRed    = Color(0xFFD32F2F);
const _kOrange = Color(0xFFF57C00);
const _kBg     = Color(0xFFF5F6FA);

class SalesRegister extends StatelessWidget {
  final String vchType;
  const SalesRegister({super.key, required this.vchType});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<SalesReportController>()) {
      Get.delete<SalesReportController>(force: true);
    }

    final controller = Get.put(SalesReportController(vchType: vchType));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _kBg,
      appBar:SfaCustomAppbar(
        title: '$vchType Report',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CalendarSingleView(
                    fromDate: Utility.selectedFromDateOfDateController!,
                    toDate: Utility.selectedToDateOfDateController!,
                    function: () async {
                      await selectDateRange(
                        Utility.selectedFromDateOfDateController!,
                        Utility.selectedToDateOfDateController!,
                      ).then((dateTimeRange) {
                        Utility.selectedFromDateOfDateController =
                            dateTimeRange.start;
                        Utility.selectedToDateOfDateController =
                            dateTimeRange.end;
                        controller.salesRegisterRepAPI();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),

      // ── GRADIENT APP BAR ──────────────────────────────────────────────────
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(size.height * 0.13),
      //   child: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [_kRed, _kOrange],
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Color(0x33D32F2F),
      //           blurRadius: 8,
      //           offset: Offset(0, 3),
      //         ),
      //       ],
      //     ),
      //     child: SafeArea(
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           // Title + back
      //           Padding(
      //             padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
      //             child: Row(
      //               children: [
      //                 IconButton(
      //                   icon: const Icon(Icons.arrow_back_ios_new,
      //                       color: Colors.white, size: 20),
      //                   onPressed: () => Get.back(),
      //                 ),
      //                 Expanded(
      //                   child: Text(
      //                     '$vchType Register',
      //                     style: const TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 17,
      //                       fontWeight: FontWeight.bold,
      //                       letterSpacing: 0.3,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),

      //           // Date picker
      //           Padding(
      //             padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 CalendarSingleView(
      //                   fromDate: Utility.selectedFromDateOfDateController!,
      //                   toDate: Utility.selectedToDateOfDateController!,
      //                   function: () async {
      //                     await selectDateRange(
      //                       Utility.selectedFromDateOfDateController!,
      //                       Utility.selectedToDateOfDateController!,
      //                     ).then((range) {
      //                       Utility.selectedFromDateOfDateController =
      //                           range.start;
      //                       Utility.selectedToDateOfDateController = range.end;
      //                       controller.salesRegisterRepAPI();
      //                     });
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: _kRed,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () async {
          await Get.to(
            () => SalesCreateScreen(vchType: 'Sales', isEdit: false),
          );
        },
        child: const Icon(Icons.add),
      ),

      // ── BODY ──────────────────────────────────────────────────────────────
      body: Column(
        children: [
          // Total summary bar
          Obx(() {
            if (controller.isDataLoad.value != 1 ||
                (controller.reportlist?.isEmpty ?? true)) {
              return const SizedBox.shrink();
            }
            return _SummaryBar(controller: controller);
          }),

          Expanded(
            child: Obx(() {
              // Loading
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? const CupertinoActivityIndicator()
                      : const CircularProgressIndicator(color: _kOrange),
                );
              }

              // Empty
              if (controller.isDataLoad.value == 2 ||
                  (controller.reportlist?.isEmpty ?? true)) {
                return const Center(child: NoDataFound());
              }

              // List
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                itemCount: controller.reportlist!.length,
                itemBuilder: (context, i) {
                  final report = controller.reportlist![i];
                  return _SalesCard(
                    report: report,
                    onTap: () => Get.to(
                      () => SalesCreateScreen(
                        hedId: report.uniqueid,
                        vchType: vchType,
                        isEdit: true,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SUMMARY BAR
// ═══════════════════════════════════════════════════════════════

class _SummaryBar extends StatelessWidget {
  final SalesReportController controller;
  const _SummaryBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final total = controller.reportlist!.fold<double>(
      0,
      (sum, e) => sum + (double.tryParse(e.totalammount ?? '0') ?? 0),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kOrange,_kRed, ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _kRed.withOpacity(0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long_outlined,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.reportlist!.length} Records',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            indianRupeeFormat(total),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SALES CARD
// ═══════════════════════════════════════════════════════════════

class _SalesCard extends StatelessWidget {
  final dynamic report;
  final VoidCallback onTap;

  const _SalesCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(report.totalammount ?? '0') ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── TOP ROW ──
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Red-orange left accent bar
                  Container(
                    width: 4,
                    height: 44,
                    margin: const EdgeInsets.only(right: 10, top: 1),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_kRed, _kOrange],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // Party name + voucher type
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.partyName ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          report.vouchertype ?? '',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount + view pill
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        indianRupeeFormat(amount),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      ],
                  ),
                ],
              ),
            ),

            // ── DIVIDER ──
            Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey.shade200),

            // ── BOTTOM META ROW ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  _MetaChip(
                    icon: Icons.receipt_outlined,
                    label: report.invoiceno ?? '—',
                  ),
                  const SizedBox(width: 12),
                  _MetaChip(
                    icon: Icons.calendar_today_outlined,
                    label: report.date ?? '—',
                  ),
                  const SizedBox(width: 12),
                  _MetaChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Qty: ${report.totalqty ?? 0}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// META CHIP
// ═══════════════════════════════════════════════════════════════

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: _kOrange),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_report_controller.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_entry_screen.dart';
// import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
// import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
// import 'package:trina_grid/trina_grid.dart';

// //pratiksha p add
// class SalesRegister extends StatelessWidget {
//   final String vchType;
//   const SalesRegister({super.key, required this.vchType});

//   @override
//   Widget build(BuildContext context) {
//     if (Get.isRegistered<SalesReportController>()) {
//       Get.delete<SalesReportController>(force: true);
//     }

//     final SalesReportController controller = Get.put(
//       SalesReportController(vchType: vchType),
//     );

//     Size size = MediaQuery.of(context).size;
//     // controller.salesRegisterRepAPI();
//     return Scaffold(
//       appBar: SfaCustomAppbar(
//         title: '$vchType Report',
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   CalendarSingleView(
//                     fromDate: Utility.selectedFromDateOfDateController!,
//                     toDate: Utility.selectedToDateOfDateController!,
//                     function: () async {
//                       await selectDateRange(
//                         Utility.selectedFromDateOfDateController!,
//                         Utility.selectedToDateOfDateController!,
//                       ).then((dateTimeRange) {
//                         Utility.selectedFromDateOfDateController =
//                             dateTimeRange.start;
//                         Utility.selectedToDateOfDateController =
//                             dateTimeRange.end;
//                         controller.salesRegisterRepAPI();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: size.height * 0.01),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingButton(
//         isExtended: false,
//         icon: const Icon(Icons.add),
//         title: null,
//         function: () async {
//           await Get.to(
//             () => SalesCreateScreen(vchType: 'Sales', isEdit: false),
//           );
//           // controller.checkApiDet();
//         },
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (controller.isDataLoad.value == 0) {
//                 return Center(
//                   child: Platform.isIOS
//                       ? CupertinoActivityIndicator()
//                       : CircularProgressIndicator(),
//                 ); //pratiksha p 09-04-2026 //Utility.processLoadingWidget());
//               } else if (controller.isDataLoad.value == 2) {
//                 return Center(
//                   child: NoDataFound(
//                     //pratiksha p 30-03-2026 add
//                     //  message: 'No $vchType Data Found !!',
//                     //  showTitle: true,
//                   ),
//                 );
//               } else {
//                 return ListView.builder(
//                   itemCount: controller.reportlist!.length,
//                   padding: const EdgeInsets.all(2),
//                   itemBuilder: (context, i) {
//                     final reportvalue = controller.reportlist![i];

//                     return Column(
//   children: [
//     InkWell(
//       onTap: () {
//         Get.to(
//           () => SalesCreateScreen(
//             hedId: reportvalue.uniqueid,
//             vchType: vchType,
//             isEdit: true,
//           ),
//         );
//       },
//       child: Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 3,
//             horizontal: 6,
//           ),
//           child: Row(
//             children: [
//               /// LEFT SIDE
//               Expanded(
//                 flex: 6,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(reportvalue.partyName ?? '', style: kTxtStl13B),
//                     commonAlignedText("Invoice No", "${reportvalue.invoiceno}"),
//                     commonAlignedText("Date", "${reportvalue.date}"),
//                     commonAlignedText("Voucher Type", "${reportvalue.vouchertype}"),
//                     commonAlignedText("Qty", "${reportvalue.totalqty}"),
//                   ],
//                 ),
//               ),

//               /// RIGHT SIDE
//               Expanded(
//                 flex: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       indianRupeeFormat(
//                         double.tryParse(reportvalue.totalammount ?? '0') ?? 0,
//                       ),
//                       style: kTxtStl13B,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//         const Divider(
//       thickness: 0.3,
//       color: Colors.grey,
//       height: 1,
//     ),
//   ],
// );
//                   },
//                 );            }
//             }),
//           ),
//         ],
//       ),
//     );
//   }

// Widget commonAlignedText(String label, String value) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       SizedBox(
//         width: 90,
//         child: Text(label, style: kTxtStl13GreyN),
//       ),
//        Text(" : ", style: kTxtStl13GreyN),
//       Text(value, style: kTxtStl13GreyN),
//     ],
//   );
// }
// }
