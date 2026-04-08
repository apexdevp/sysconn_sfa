// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/app_colors.dart';
// import 'package:sysconn_sfa/Utility/calendar_range_view.dart';
// import 'package:sysconn_sfa/Utility/date_calendar.dart';
// import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/screens/expenses/report/user/controller/expense_rpt_controller.dart';
// import 'package:sysconn_sfa/screens/expenses/views/entry/expense/expense_create_update.dart';
// import 'package:sysconn_sfa/widgets/custom_appbar.dart';
// import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';

// class MyExpensesReport extends StatelessWidget {
//   MyExpensesReport({super.key});
//   final controller = Get.put(ExpensesReportController());
//   Column customeexpensetotalval({
//     required Size size,
//     required String title,
//     required String value,
//     IconData? icon,
//     Color? color,
//   }) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 09, color: color),
//             Text(title, style: kTxtStl11N),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.all(1.0),
//           child: Text(value, style: kTxtStl13B),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: customAppbar(
//         context: context,
//         title: 'Expense Requests',
//           // bottom: PreferredSize(
//           //   preferredSize: Size.fromHeight(size.height * 0.18),
//           //   child: Column(
//           //     mainAxisAlignment: MainAxisAlignment.start,
//           //     children: [
//           //       Row(
//           //         mainAxisAlignment: MainAxisAlignment.end,
//           //         children: [
//           //           CalendarRangeView(
//           //             function: () async {
//           //              controller.checkApiDet();
//           //             },
//           //           ),
//           //         ],
//           //       ),
//           //       SizedBox(height: size.height * 0.01),
//           //       Align(
//           //         alignment: Alignment.center,
//           //         child: Container(
//           //           width: size.width * 0.9,
//           //           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           //           decoration: BoxDecoration(
//           //             color: Colors.white,
//           //             borderRadius: BorderRadius.circular(8),
//           //           ),
//           //           child: Row(
//           //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //             children: [
//           //               customeexpensetotalval(
//           //                 size: size,
//           //                 title: 'Total Expenses',
//           //                 value: controller.expTotal.value.toString(),
//           //               ),
//           //               VerticalDivider(
//           //                 thickness: 1,
//           //                 width: 1,
//           //                 color: Colors.black,
//           //               ),
//           //               customeexpensetotalval(
//           //                 size: size,
//           //                 title: 'Pending',
//           //                 value:controller.expenseModel.value!.pending ?? '0.00',
//           //                     // (controller
//           //                     //         .expenseModel
//           //                     //         .value!
//           //                     //         .pending
//           //                     //         ?.isNotEmpty ==
//           //                     //     true)
//           //                     // ? double.parse(
//           //                     //     controller.expenseModel.value!.pending!,
//           //                     //   ).toStringAsFixed(2)
//           //                     // : '0.00',
//           //                 icon: Icons.circle,
//           //                 color: Colors.red,
//           //               ),
//           //               VerticalDivider(thickness: 1, color: Colors.grey),
//           //               customeexpensetotalval(
//           //                 size: size,
//           //                 title: 'Approved',
//           //                 value:controller.expenseModel.value!.approved ?? '0.00',
//           //                     // (controller
//           //                     //         .expenseModel
//           //                     //         .value!
//           //                     //         .pending
//           //                     //         ?.isNotEmpty ==
//           //                     //     true)
//           //                     // ? double.parse(
//           //                     //     controller.expenseModel.value!.approved!,
//           //                     //   ).toStringAsFixed(2)
//           //                     // : '0.00',
//           //                 icon: Icons.circle,
//           //                 color: Colors.green,
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ),
//           //       SizedBox(height: size.height * 0.02),
//           //     ],
//           //   ),
//           // ),
//           bottom: PreferredSize(
//   // preferredSize: Size.fromHeight(200),
//    preferredSize: Size.fromHeight(size.height * 0.17),
//   child: Obx(() {
//     final model = controller.expenseModel.value;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//         // mainAxisSize: MainAxisSize.min, 
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             CalendarRangeView(
//               function: () async {
//                 controller.checkApiDet();
//               },
//             ),
//           ],
//         ),
//         SizedBox(height: size.height * 0.01),
//         Align(
//           alignment: Alignment.center,
//           child: Container(
//             width: size.width * 0.9,
//             padding: const EdgeInsets.symmetric(vertical: 2.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 customeexpensetotalval(
//                   size: size,
//                   title: 'Total Expenses',
//                   value: controller.expTotal.value.toStringAsFixed(2),
//                 ),
//                 const VerticalDivider(thickness: 1),
//                 customeexpensetotalval(
//                   size: size,
//                   title: 'Pending',
//                   value: model?.pending ?? '0.00',
//                   icon: Icons.circle,
//                   color: Colors.red,
//                 ),
//                 const VerticalDivider(thickness: 1),
//                 customeexpensetotalval(
//                   size: size,
//                   title: 'Approved',
//                   value: model?.approved ?? '0.00',
//                   icon: Icons.circle,
//                   color: Colors.green,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // SizedBox(height: size.height * 0.02),
//       ],
//     );
//   }),
// ),

//       ),

//       floatingActionButton: FloatingButton(
//         isExtended: false,
//         icon: const Icon(Icons.add),
//         title: null,
//         function: () async {
//           await Get.to(() => ExpenseCreateUpdate());
//           // controller.checkApiDet();
//         },
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),

//             child: TabBar(
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey,

//               labelStyle: kTxtStl13B,
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14.0),
//                 border: Border.all(color: kAppColor),
//               ),
//               controller: controller.tabController,
//               tabs:
//                   // [
//                   //   Tab(child: Text(expApproveTabList[0])),
//                   //   Tab(child: Text(expApproveTabList[1])),
//                   //   Tab(child: Text(expApproveTabList[2])),
//                   // ],
//                   controller.expApproveTabList
//                       .map((e) => Tab(text: e))
//                       .toList(),
//             ),
//             // ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return Center(child: Utility.processLoadingWidget());
//               }
//               final list = controller.expenseModel.value?.expense ?? [];

//               if (list.isEmpty) {
//                 return const NoDataFound();
//               }
//               return ListView.builder(
//                 itemCount: list.length,
//                 itemBuilder: (context, i) {
//                   final item = list[i];
//                   return InkWell(
//                     onTap: item.approvalStatus == 'Pending'
//                         ? () async {
//                             await Get.to(
//                               () => ExpenseCreateUpdate(
//                                 expRptHedId: item.uniqueId!,
//                               ),
//                             );
//                             // controller.checkApiDet();
//                           }
//                         : null,
//                          child: Card(
//                         child: Container(
//                           padding: EdgeInsets.all(4.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
                            
//                               DateCalendar(date:item.date!),
//                               SizedBox(
//                                 width: size.width * 0.02,
//                               ),
                             
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text('${item.vchprefix}${item.maxNo}',style: kTxtStl13B,),
//                                     SizedBox(
//                                       height: size.height * 0.01,
//                                     ),
//                                     item.approvalStatus !='Pending' &&item.rejectAmount !=0?
//                                     IntrinsicHeight(
//                                       child: Row(
//                                         mainAxisAlignment:MainAxisAlignment.center,
//                                         children: [
                                         
//                                           Text('Rejected :',style: kTxtStl13N,),
//                                           Text(indianRupeeFormat(item.rejectAmount!.toDouble()),style: TextStyle(fontSize: 13,color: Colors.red),)
                                         
//                                         ],
//                                       ),
//                                     ):Container(),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: size.width * 0.02,
//                               ),
//                             controller.expenseModel.value!.expense![i].approvalStatus == 'Approved'?
//                               Column(
//                                 children: [
//                                   Text('Approved ',style: kTxtStl13GreyN,),
//                                   Text(indianRupeeFormat( controller.expenseModel.value!.expense![i].approvedamt!.toDouble()),style: kTxtStl15B,),
//                                 ],
//                               )
//                               :Column(
//                                 children: [
//                                   Text('Claimed ',style: kTxtStl13GreyN,),
//                                   Text(indianRupeeFormat( controller.expenseModel.value!.expense![i].claimedAmount!.toDouble()),style: kTxtStl15B,),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
