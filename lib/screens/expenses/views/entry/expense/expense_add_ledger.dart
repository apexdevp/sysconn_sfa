import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/expense_add_ledger_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

class ExpenseAddLedgers extends StatelessWidget {
  final String? headerUniqueId;
  final ExpensesLedgerEntity? expensesLedgerEntity;
  // ExpenseAddLedgers({
  //   super.key,
  //   this.headerUniqueId,
  //   this.expensesLedgerEntity,
  // });
  
//   // late final ExpenseAddLedgersController controller;
//   // final ExpenseAddLedgersController controller =
//   //  Get.put(
//   //   ExpenseAddLedgersController(
//   //     headerUniqueId: Get.arguments?['headerUniqueId'],
//   //     expensesLedgerEntity: Get.arguments?['expensesLedgerEntity'],
//   //   ),
//   // );



//  final ExpenseAddLedgersController controller =
//       Get.put(
//         ExpenseAddLedgersController(
//           headerUniqueId: headerUniqueId,
//           expensesLedgerEntity: expensesLedgerEntity,
//         ),
//       );

 late final ExpenseAddLedgersController controller;

  ExpenseAddLedgers({
    super.key,
    this.headerUniqueId,
    this.expensesLedgerEntity,
  }) {
    controller = Get.put(
      ExpenseAddLedgersController(
        headerUniqueId: headerUniqueId,
        expensesLedgerEntity: expensesLedgerEntity,
      ),
      tag: headerUniqueId, // ✅ prevents duplicate controllers
    );
  }
  @override
  Widget build(BuildContext context) {
    //   controller = Get.put(
    //   ExpenseAddLedgersController(
    //     headerUniqueId: headerUniqueId,
    //     expensesLedgerEntity: expensesLedgerEntity,
    //   ),
    //   tag: headerUniqueId, // ✅ prevents duplication
    // );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar( title: 'Create Ledger'),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.expensesLedgerEntity == null
                  ? SizedBox(
                      width: size.width * 0.4,
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade700),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Add More',
                              style: kTxtStl16BlackB,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () async {
                          // controller.isAddMoreClk.value = true;

                          // Utility.showCircularLoadingWid(context);
                          // await controller.doneButtonClicked().then((value) {
                          //   if (context.mounted) {
                          //     scaffoldMessageBar(
                          //       'Ledger Added.',
                          //       isError: false,
                          //     );
                          //   }
                          //   controller.amountTextEditingControllerBlank();
                          // });
                          //  controller.isAddMoreClk.value = true;
                          // Utility.showCircularLoadingWid(context);
                          // await controller.doneButtonClicked();
                          // controller.amountTextEditingControllerBlank();
                           controller.isAddMoreClk.value = true;
  Utility.showCircularLoadingWid(context);
  await controller.doneButtonClicked();
  scaffoldMessageBar('Ledger Added.', isError: false);
  controller.amountTextEditingControllerBlank();
                          
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: size.width * 0.45,
                  child: ResponsiveButton(
                    title: 'Submit',
                    function: () async {
                      // // controller.isAddMoreClk.value = false;
                
                      // // Utility.showCircularLoadingWid(context);
                      // // await controller.doneButtonClicked();
                      //  controller.isAddMoreClk.value = false;
                      // Utility.showCircularLoadingWid(context);
                      // await controller.doneButtonClicked();
                    //                 controller.isAddMoreClk.value = false;
                    // Utility.showCircularLoadingWid(context); // show loader
                
                    // await controller.doneButtonClicked();
                    // // controller.doneButtonClicked() now closes loader and pops page if successful
                
                      controller.isAddMoreClk.value = false; // Submit mode
                      Utility.showCircularLoadingWid(context);
                      await controller.doneButtonClicked(); // Save ledger
                      // page will pop inside controller after successful save
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(children: [Expanded(child: _myListView(size, context))]),
    );
  }

  Widget _myListView(Size size, BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          // width: size.width,
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.leaderboard),
                  SizedBox(width: 10.0),
                  Text('Ledger', style: kTxtStlB),
                ],
              ),
              controller.expensesLedgerEntity == null
                  ? Container()
                  : Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kGreyColor,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 19,
                        ),
                        onPressed: () {
                          Utility.showAlertYesNo(
                            title: 'Alert',
                            msg: 'Do you want to delete this Ledger ?',
                            yesBtnFun: () async {
                              Navigator.pop(context);
                              await controller.deleteExpenseLedger();
                            },
                            noBtnFun: () => Navigator.pop(context),
                          );
                        },
                      ),
                    ),
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
                  //  Obx(() =>
                     CustomAutoCompleteFieldView(
                      optionsBuilder: (TextEditingValue value) {
                        return controller.ledgerNameList
                            .where(
                              (LedgerMasterEntity ledgerEntity) => ledgerEntity
                                  .ledgerName!
                                  .toLowerCase()
                                  .contains(value.text.toLowerCase()),
                            )
                            .toList();
                      },
                      displayStringForOption:
                          (LedgerMasterEntity ledgerEntity) {
                            return ledgerEntity.ledgerName!;
                          },

                      title: 'Type of Expenses',
                      controllerValue: controller.ledgerName.value,

                      isCompulsory: true,
                      closeControllerFun: () {
                        controller.ledgerId.value = '';
                        controller.ledgerName.value = '';
                      },
                      onSelected: (LedgerMasterEntity ledgerEntity) {
                        controller.ledgerId.value = ledgerEntity.ledgerId!;

                        controller.ledgerName.value = ledgerEntity.ledgerName!;
                      },
                    )
                    // ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    // Obx(() => 
                     CustomTextFormFieldView(
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: controller.amountTextController,

                      title: 'Amount',
                      onChanged: (text) {
                        if (text.trim().isNotEmpty) {
                          controller.claimedAmount.value = double.parse(text);
                        }
                      },
                    )
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
