// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sysconn_sfa/Utility/activity_button.dart';
// import 'package:sysconn_sfa/Utility/report_menu.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/screens/expenses/controllers/expenses_menu_controller.dart';
// import 'package:sysconn_sfa/screens/expenses/report/admin/adv_exp_approval/view/adv_expenses_approval_rpt.dart';
// import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/view/expense_approval_report.dart';
// import 'package:sysconn_sfa/screens/expenses/report/user/view/advance_requisition_report.dart';
// import 'package:sysconn_sfa/screens/expenses/report/user/view/expense_report.dart';
// import 'package:sysconn_sfa/screens/expenses/views/entry/advance_requisition/advance_requisition_entry.dart';
// import 'package:sysconn_sfa/screens/expenses/views/entry/advance_requisition/submit_expense.dart';
// import 'package:sysconn_sfa/screens/expenses/views/entry/expense/expense_create_update.dart';
// import 'package:sysconn_sfa/widgets/custom_appbar.dart';

// class ExpensesMenuView extends StatelessWidget {
//   ExpensesMenuView({super.key});

//   final ExpensesMenuController controller = Get.put(ExpensesMenuController());

//   Widget activityButtonRow(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           ActivityButton(
//             title: 'Request Advance',
//             function: () {
//               if (Utility.isCmpEmp) {
//                 Get.to(() => const AdvanceRequisitionEntry());
//               } else {
//                 scaffoldMessageBar(
//                   'Reporting user not allow to apply expenses',
//                 );
//               }
//             },
//           ),
//           ActivityButton(
//             title: 'Claim Expense',
//             function: () {
//               if (Utility.isCmpEmp) {
//                 Get.to(() => ExpenseCreateUpdate());
//               } else {
//                 scaffoldMessageBar(
//                   'Reporting user not allow to apply expenses',
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget reportsTile(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         padding: const EdgeInsets.all(8),
//         children: [
//           ReportMenu(
//             title: 'Advance Requests',
//             function: () {
//               // if (Utility.isCmpEmp) {
//               Get.to(() => MyAdvanceRequisitionReport());
//               // } else {
//               //   scaffoldMessageBar(context,
//               //       'Reporting user not allow to open my advance request');
//               // }
//             },
//           ),
//           Utility.cmpusertype == 'Employee' ||
//                   Utility.cmpusertype.toUpperCase() == 'HR'
//               ? Container()
//               : ReportMenu(
//                   title: 'Team Advance Requests',
//                   function: () {
//                     Get.to(() => AdvExpensesApprovalReport());
//                   },
//                 ),
//           ReportMenu(
//             title: 'My Expense Requests',
//             function: () {
//               // if (Utility.isCmpEmp) {
//               Get.to(() => MyExpensesReport());
//               // } else {
//               //   scaffoldMessageBar(
//               //       context, 'Reporting user not allow to open my expenses');
//               // }
//             },
            
//           ),
//           Utility.cmpusertype == 'Employee' ||
//                   Utility.cmpusertype.toUpperCase() == 'HR'
//               ? Container()
//               : ReportMenu(
//                   title: 'Team Expense Requests',
//                   function: () {
//                     Get.to(() =>  ExpensesApprovalReport());
//                   },
//                 ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       // appBar: customAppbar(context: context, title: 'Expenses'),
//       //AppBar(title: Text('Expenses'),),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//           child: Obx(
//             () => controller.isDataLoad.value == false
//                 ? Utility.processLoadingWidget()
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Hi ${Utility.employeeName}', style: kTxtStl17N),
//                       SizedBox(height: size.height * 0.01),
//                       Text(
//                         '${DateFormat('d MMM yyyy | EEEE').format(DateTime.now())} | ${controller.timeString.value}',
//                         style: kTxtStl14GreyN,
//                       ),
//                       activityButtonRow(context),
//                       SizedBox(height: size.height * 0.03),
//                       reportsTile(context),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
