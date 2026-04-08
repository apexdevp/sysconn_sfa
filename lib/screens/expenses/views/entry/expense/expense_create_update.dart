import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/user/employee_master_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/expense_create_update_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

class ExpenseCreateUpdate extends StatelessWidget {
  final String? expRptHedId;
  const ExpenseCreateUpdate({super.key, this.expRptHedId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final controller = Get.put(ExpenseCreateUpdateController());
    final controller = Get.put(
      ExpenseCreateUpdateController(expRptHedId: expRptHedId),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: controller.onWillPop,
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: 'Expense ${expRptHedId == null ? 'Claim' : 'Update'}',
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
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
                            'Cancel',
                            style: kTxtStl16BlackB,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (expRptHedId == null) {
                          // expensesHeadId != ''
                          Utility.showAlertYesNo(
                            iconData: Icons.help_outline_rounded,
                            iconcolor: Colors.blueAccent,
                            title: 'Alert',
                            msg: 'Do you want to discard expense data ?',
                            yesBtnFun: () async {
                              await controller.deleteExpenseButtonClicked();
                            },
                            noBtnFun: () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: ResponsiveButton(
                      title: 'Save',
                      function: () async {
                        Utility.showCircularLoadingWid(context);
                        await controller.doneButtonClicked();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body:
            //  controller.dataLoad.isFalse
            //     ? Utility.processLoadingWidget()
            //     :
            //       // _expList(controller, size, context),
            //       Column(
            //         children: [
            //           Expanded(child: _expList(controller, size, context)),
            //           SizedBox(height: size.height * 0.1),
            //         ],
            //       ),
            Obx(() {
              if (controller.dataLoad.isFalse) {
                return Center(child: Utility.processLoadingWidget());
              }
              return Column(
                children: [
                  Expanded(child: _expList(controller, size, context)),
                  SizedBox(height: size.height * 0.1),
                ],
              );
            }),
      ),
    );
  }

  Widget _expList(
    ExpenseCreateUpdateController controller,
    Size size,
    BuildContext context,
  ) {
    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Total Amount', style: kTxtStl14B),
                Obx(
                  () => Text(
                    indianRupeeFormat(controller.receiptledgeramttotal.value),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: kAppColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_outlined),
                  SizedBox(width: 10.0),

                  Text(
                    'Expense ${expRptHedId == null ? 'Claim' : 'Update'}',
                    style: kTxtStlB,
                  ),
                  // Text('Expense Claim', style: kTxtStlB),
                ],
              ),
              expRptHedId != null
                  ? // && approvalStatus =='Pending'
                    Container(
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
                            iconData: Icons.help_outline_rounded,
                            iconcolor: Colors.blueAccent,
                            title: 'Alert',
                            msg: 'Do you want to delete this Expense ?',
                            yesBtnFun: () async {
                              Navigator.of(context).pop();
                              Utility.showCircularLoadingWid(context);
                              await controller.deleteExpenseButtonClicked();
                            },
                            noBtnFun: () {
                              // Navigator.of(context).pop();
                              Get.back();
                            },
                          );
                        },
                      ),
                    )
                  : Container(),
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
                    CustomTextFormFieldView(
                      // enabled: widget.expRptHedId == null,
                      keyboardType: TextInputType.datetime,
                      controller: controller.dateCntrl,
                      title: 'Date',
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectDateSingle(
                          dateSelected: DateFormat(
                            'dd/MM/yyyy',
                          ).parse(controller.dateCntrl.text), //selectedDate,
                          firstDate: DateTime.now().subtract(
                            Duration(days: 60),
                          ),
                          lastDate: DateTime.now(),
                        ).then((date) {
                          controller.dateCntrl.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(date);

                          controller.loadVoucherType();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.currency_rupee_outlined),
                  SizedBox(width: 10.0),

                  Text('Expense Ledger', style: kTxtStlB),
                ],
              ),
              GestureDetector(
                onTap: () {
                  controller.navigateExpenseLedger(null);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red.shade300,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: controller.expensesHeaderEntityList.value != null
              ? controller.expensesHeaderEntityList.value!.ledger!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: controller
                              .expensesHeaderEntityList
                              .value!
                              .ledger!
                              .length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${controller.expensesHeaderEntityList.value!.ledger![i].ledgerName}',
                                            style: kTxtStl13N,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.3,
                                      child: Text(
                                        (controller
                                            .expensesHeaderEntityList
                                            .value!
                                            .ledger![i]
                                            .ledgerAmount!),
                                        style: kTxtStl13N,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                // _navigateExpenseLedger(expensesHeaderEntityList!.ledger![i]);
                                controller.navigateExpenseLedger(
                                  controller
                                      .expensesHeaderEntityList
                                      .value!
                                      .ledger![i],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text('No Ledger Added.', style: kTxtStl13N),
                      )
              : Container(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Upload Receipt', style: kTxtStl14B),
              GestureDetector(
                onTap: () {
                  controller.navigateDocument('Upload Receipt', null);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red.shade300,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              if (controller.expensesHeaderEntityList.value != null)
                controller.expensesHeaderEntityList.value!.document!.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller
                            .expensesHeaderEntityList
                            .value!
                            .document!
                            .length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Document ${i + 1}'),
                                        Text(
                                          'Remark : ${controller.expensesHeaderEntityList.value!.document![i].remark}',
                                        ), //snehal 28-07-2025 add
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              controller.navigateDocument(
                                'Update Document',
                                controller
                                    .expensesHeaderEntityList
                                    .value!
                                    .document![i],
                              );
                            },
                          );
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text('No Document Added.', style: kTxtStl13N),
                      ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.assignment_outlined),
              SizedBox(width: 10.0),
              Text('Approver', style: kTxtStlB),
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
                    CustomAutoCompleteFieldView(
                      optionsBuilder: (TextEditingValue value) {
                        return controller.empListItem
                            .where(
                              (UserEntity userlistEntity) => userlistEntity
                                  .username!
                                  .toLowerCase()
                                  .contains(value.text.toLowerCase()),
                            )
                            .toList();
                      },
                      displayStringForOption: (UserEntity userlistEntity) {
                        return userlistEntity.username!;
                      },
                      // title: 'Approval Person Name',
                      title:
                          'Select Approver', // Manisha // 13-11-2025 // change title
                      controllerValue: controller.approvername.value,
                      isCompulsory: true,
                      closeControllerFun: () {
                        controller.approvedById.value = '';
                        controller.approvalFcmToken.value = '';
                        controller.approvalMobNo.value = '';
                        controller.approvername.value = '';
                      },
                      onSelected: (UserEntity userEntity) {
                        FocusScope.of(context).requestFocus(FocusNode());

                        controller.approvedById.value = userEntity.emailid!;
                        // controller.approvalFcmToken.value =
                        //     userEntity.fcmToken!;
                        // controller.approvalMobNo.value = userEntity.mobileNo!;
                        controller.approvername.value = userEntity.username!;
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.remarkCntrl,
                      title: 'Remark',
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomAutoCompleteFieldView(
                      enabled:
                          (controller
                              .expensesHeaderEntityList
                              .value ==
                          null),
                      title: 'Voucher Name',
                      optionsBuilder: (value) => controller.vchEntityList
                          .where(
                            (e) => e.vchTypeName!.toLowerCase().contains(
                              value.text.toLowerCase(),
                            ),
                          )
                          .toList(),
                      controllerValue: controller.vchSelectedName.value,
                      closeControllerFun: () => controller.clearVoucher(),
                      displayStringForOption: (v) => v.vchTypeName!,
                      onSelected: (v) => controller.setVoucher(v),
                    ),
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
