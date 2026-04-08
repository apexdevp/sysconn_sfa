import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/controller/exp_approval_document_controller.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/controller/exp_approval_view_controller.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/view/expense_approval_document.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/dropdownlist.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

// class ExpensesApprovalView extends StatelessWidget {
//    ExpensesApprovalView({super.key});
//   // final controller = Get.put(ExpensesApprovalViewController(expensesHedId));
class ExpensesApprovalView extends GetView<ExpensesApprovalViewController> {
  const ExpensesApprovalView({super.key});
 Widget  expDetRow({required BuildContext context,required String title, required String value}) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.24,
          child: Text(title, style: kTxtStl13GreyN),
        ),
        Text(': ', style: kTxtStl13GreyN),
        Expanded(child: Text(value, style: kTxtStl13GreyN)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Expense Approval'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ResponsiveButton(
          title: 'Submit',
          function: controller.updateExpensesApprovalStatusApi,
        ),
      ),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        if (!controller.apiload.value) {
          return Utility.processLoadingWidget();
        }
return
        Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Total Amount', style: kTxtStl14B),
                        Obx(() =>   Text(
                            indianRupeeFormat(controller.receiptledgeramttotal.value.toDouble()),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: kAppColor,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.indianRupeeSign),
                        SizedBox(width: 10),
                        Text('Expenses', style: kTxtStlB),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                            controller.expensesHeaderEntityList.value.employeeName!,
                              style: kTxtStl13GreyB,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 10,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: expDetRow(context: context,
                                    title: 'Voucher No.',
                                    value:
                                        '${   controller.expensesHeaderEntityList.value.vchprefix} ${   controller.expensesHeaderEntityList.value.maxNo}',
                                  ),
                                ),
                                VerticalDivider(color: Colors.grey),
                                Expanded(
                                  child: expDetRow(  context: context,
                                    title: 'Date',
                                    value: DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(
                                           controller.expensesHeaderEntityList.value.date!,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(,style: kTxtStl13GreyB,),
                                // Text(),style: kTxtStl13GreyB,),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          expDetRow(  context: context,
                            title: 'Remark',
                            value:    controller.expensesHeaderEntityList.value.remark!,
                          ),
                          expDetRow(  context: context,
                            title: 'Approved By',
                            value:    controller.expensesHeaderEntityList.value.approverName!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.leaderboard),
                        SizedBox(width: 10),
                        Text('Expenses Head', style: kTxtStlB),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Column(
                        children: [
                          // Header Row
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Expenses Head',
                                    style: kTxtStl13GreyB,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(
                                    'Approved Amt.',
                                    style: kTxtStl13GreyB,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(
                                    'Rejected Amt.',
                                    style: kTxtStl13GreyB,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ledger List
                          controller
                                  .expensesHeaderEntityList
                                  .value
                                  .ledger!
                                  .isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller
                                      .expensesHeaderEntityList
                                      .value
                                      .ledger!
                                      .length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final ledger = controller
                                        .expensesHeaderEntityList
                                        .value
                                        .ledger![i];
                                    return InkWell(
                                      onTap: () async {
                                      
                                        var resLedData =
                                            await showApprovedLedgerDialog(
                                              expensesLedgerEntity: ledger,
                                            );
                                        if (resLedData != null) {
                                          controller.getExpensesAllDetApi();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.1,
                                                    // child: CircleAvatar(
                                                    // backgroundColor: Colors.grey.shade100,
                                                    // radius: 18,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.red,
                                                      size: 19,
                                                    ),
                                                    // ),
                                                  ),
                                                  Text(
                                                    '${ledger.ledgerName}',
                                                    style: kTxtStl13N,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: Text(
                                                '${ledger.ledgerAmount}',
                                                style: kTxtStl13B,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: SizedBox(
                                                width: size.width * 0.2,
                                                child: Text(
                                                  '${ledger.rejectAmount}',
                                                  style: kTxtStl13B,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'No Expenses Head Added.',
                                    style: kTxtStl12GreyN,
                                  ),
                                ),
                          Divider(
                            color: Colors.grey,
                            height: 8,
                            indent: 10,
                            endIndent: 10,
                          ),
                          // Total Row
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: Text(
                                    'Total Amount',
                                    style: kTxtStl13N,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(
                                    indianRupeeFormat(
                                      double.parse(
                                        controller.receiptledgeramttotal
                                            .toString(),
                                      ),
                                    ),
                                    style: kTxtStl13B,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.2,
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    indianRupeeFormat(
                                      double.parse(
                                        controller.receiptRejectledamttotal
                                            .toString(),
                                      ),
                                    ),
                                    style: kTxtStl13B,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file),
                        SizedBox(width: 10),
                        Text('Attached Document', style: kTxtStlB),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              color: Colors.grey.shade200,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Document List', style: kTxtStl13B),
                              ],
                            ),
                          ),
                          controller
                                  .expensesHeaderEntityList
                                  .value
                                  .document!
                                  .isNotEmpty
                              ? ListView.builder(
                                  itemCount: controller
                                      .expensesHeaderEntityList
                                      .value
                                      .document!
                                      .length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final doc = controller
                                        .expensesHeaderEntityList
                                        .value
                                        .document![i];
                                    return InkWell(
                                      onTap: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         ExpApproveDocument(
                                        //           documentPath:
                                        //               doc.documentPath!,
                                        //         ),
                                        //   ),
                                        // );
                                         Get.to(
    () => const ExpApproveDocument(),
    binding: BindingsBuilder(() {
      Get.put(
        ExpApproveDocumentController(
          documentPath: doc.documentPath!,
        ),
      );
    }),
  );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Document ${i + 1}',
                                              style: kTxtStl13N,
                                            ),
                                            Text(
                                              '  Remark : ${doc.remark}',
                                              style: kTxtStl13N,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'No Document Added.',
                                    style: kTxtStl12GreyN,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.approval_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Approval Status',
                          style: kTxtStlB,
                        ), // Expenses Approval    // Expenses Approve
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => DropdownCustomList(
                                  title: 'Status',
                                  items: controller.statusItem.map((
                                    statusValue,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: statusValue,
                                      child: Text(
                                        statusValue,
                                        style: kTxtStl13N,
                                      ),
                                    );
                                  }).toList(),
                                  value: controller.statusSelected.value,
                                  onChanged: (String? newValue) {
                                    controller.statusSelected.value = newValue;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              CustomTextFormFieldView(
                                controller: controller.remarkController,
                                title: 'Remark',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.1),
          ],
        );
      }),
    );
  }

//   Future showApprovedLedgerDialog({required ExpensesLedgerEntity expensesLedgerEntity}) {
//   // Reactive variables
//   // final rejectAmt = (expensesLedgerEntity.rejectAmount ?? 0.0).obs;
//   // final approvedAmt = (expensesLedgerEntity.ledgerAmount != null
//   //         ? double.parse(expensesLedgerEntity.ledgerAmount!)
//   //         : expensesLedgerEntity.claimedAmount ?? 0.0)
//   //     .obs;

//   // final TextEditingController rejectAmtController =
//   //     TextEditingController(text: rejectAmt.value.toString());
//  final RxDouble rejectAmt = (expensesLedgerEntity .rejectAmount ?? 0.0).obs;

//     final double initialApprovedAmt = expensesLedgerEntity.ledgerAmount != null
//         ? double.tryParse(expensesLedgerEntity.ledgerAmount!) ?? (expensesLedgerEntity.claimedAmount ?? 0.0)
//         : (expensesLedgerEntity.claimedAmount ?? 0.0);

//     final RxDouble approvedAmt = initialApprovedAmt.obs;

//     final TextEditingController rejectAmtController = TextEditingController(text: rejectAmt.value.toString());

//   return Get.dialog(
//     AlertDialog(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('Ledger Details', style: kTxtStl16B),
//           SizedBox(
//             height: 19,
//             width: 19,
//             child: IconButton(
//               padding: EdgeInsets.all(0),
//               iconSize: 19,
//               onPressed: () {
//                 Get.back();
//               },
//               icon: Icon(Icons.close, color: Colors.red),
//             ),
//           )
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(color: Colors.grey),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IntrinsicHeight(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: Get.width * 0.2,
//                     child: Text(expensesLedgerEntity.ledgerName!, style: kTxtStl13N),
//                   ),
//                   VerticalDivider(color: Colors.grey),
//                   Column(
//                     children: [
//                       Text('Claimed Amount', style: kTxtStl13N),
//                       Text(indianRupeeFormat(double.parse(expensesLedgerEntity.claimedAmount!)),
//                           style: kTxtStl13N),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           CustomTextFormFieldView(
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             controller: rejectAmtController,
//             title: 'Reject Amount',
//             onChanged: (text) {
//               // num entered = text.trim().isEmpty ? 0 : num.parse(text);
//               // if (entered <= (expensesLedgerEntity.claimedAmount ?? 0)) {
//               //   rejectAmt.value = entered;
//               //   approvedAmt.value =
//               //       (expensesLedgerEntity.claimedAmount! - entered).toDouble();
//               //   expensesLedgerEntity.rejectAmount = entered;
//               //   expensesLedgerEntity.ledgerAmount = approvedAmt.value.toStringAsFixed(2);
//               // } else {
//               //   rejectAmtController.text = rejectAmt.value.toString();
//               //   scaffoldMessageBar( 'Reject amount should be less than claimed amount');
//               // }
//                 double entered = double.tryParse(text.trim()) ?? 0.0;
//   double claimed = double.tryParse(expensesLedgerEntity.claimedAmount ?? '0') ?? 0.0;
//   if (entered <= claimed) {
//     rejectAmt.value = entered;
//     approvedAmt.value = claimed - entered;
//     expensesLedgerEntity.rejectAmount = entered.toString();
//     expensesLedgerEntity.ledgerAmount = approvedAmt.value.toStringAsFixed(2);
//   } else {
//     rejectAmtController.text = rejectAmt.value.toStringAsFixed(2);
//     scaffoldMessageBar('Reject amount should be less than claimed amount');
//   }
//             },
//           ),
//           SizedBox(height: 10),
//           Obx(() => Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Column(
//                     children: [
//                       Text('Approved Amount', style: kTxtStl13B),
//                       Text(indianRupeeFormat(approvedAmt.value), style: kTxtStl13B),
//                     ],
//                   ),
//                 ],
//               )),
//         ],
//       ),
//       actions: [
//         ResponsiveButton(
//           title: 'Save',
//           function: () async {
//             Utility.showCircularLoadingWid(Get.context!);
//             await controller.expenseLedgerPostAPI(expensesLedgerPostEntity: expensesLedgerEntity);
//             Get.back(); // close dialog after save
//           },
//         ),
//       ],
//     ),
//     barrierDismissible: false,
//   );
// }

Future showApprovedLedgerDialog({
  required ExpensesLedgerEntity expensesLedgerEntity,
}) {
  // Reactive variables
  final RxDouble rejectAmt = (expensesLedgerEntity.rejectAmount != null
          ? double.tryParse(expensesLedgerEntity.rejectAmount!) ?? 0.0
          : 0.0)
      .obs;

  final double initialApprovedAmt = expensesLedgerEntity.ledgerAmount != null
      ? double.tryParse(expensesLedgerEntity.ledgerAmount!) ??
          (expensesLedgerEntity.claimedAmount != null
              ? double.tryParse(expensesLedgerEntity.claimedAmount!) ?? 0.0
              : 0.0)
      : (expensesLedgerEntity.claimedAmount != null
          ? double.tryParse(expensesLedgerEntity.claimedAmount!) ?? 0.0
          : 0.0);

  final RxDouble approvedAmt = initialApprovedAmt.obs;

  final TextEditingController rejectAmtController =
      TextEditingController(text: rejectAmt.value.toStringAsFixed(2));

  return Get.dialog(
    AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Ledger Details', style: kTxtStl16B),
          IconButton(
            padding: EdgeInsets.zero,
            iconSize: 19,
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.2,
                    child: Text(expensesLedgerEntity.ledgerName ?? '',
                        style: kTxtStl13N),
                  ),
                  VerticalDivider(color: Colors.grey),
                  Column(
                    children: [
                      Text('Claimed Amount', style: kTxtStl13N),
                      Text(
                        indianRupeeFormat(
                          double.tryParse(
                              expensesLedgerEntity.claimedAmount ?? '0')!,
                        ),
                        style: kTxtStl13N,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomTextFormFieldView(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: rejectAmtController,
            title: 'Reject Amount',
            onChanged: (text) {
              double entered = double.tryParse(text.trim()) ?? 0.0;
              double claimed =
                  double.tryParse(expensesLedgerEntity.claimedAmount ?? '0') ??
                      0.0;

              if (entered <= claimed) {
                rejectAmt.value = entered;
                approvedAmt.value = claimed - entered;
                expensesLedgerEntity.rejectAmount = entered.toStringAsFixed(2);
                expensesLedgerEntity.ledgerAmount =
                    approvedAmt.value.toStringAsFixed(2);
              } else {
                rejectAmtController.text = rejectAmt.value.toStringAsFixed(2);
                scaffoldMessageBar(
                    'Reject amount should be less than claimed amount');
              }
            },
          ),
          SizedBox(height: 10),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Approved Amount', style: kTxtStl13B),
                      Text(indianRupeeFormat(approvedAmt.value),
                          style: kTxtStl13B),
                    ],
                  ),
                ],
              )),
        ],
      ),
      actions: [
        ResponsiveButton(
          title: 'Save',
          function: () async {
            Utility.showCircularLoadingWid(Get.context!);
            await controller.expenseLedgerPostAPI(
              expensesLedgerPostEntity: expensesLedgerEntity,
            );
            Get.back(); // Close dialog after save
          },
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

}
