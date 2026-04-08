import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/advance_requistion_entry_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/dropdownlist.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

class AdvanceRequisitionEntry extends StatelessWidget {
  final AdvExpensesEntity? expenseData;
  const AdvanceRequisitionEntry({super.key, this.expenseData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(AdvanceRequisitionController());
    
    if (expenseData != null) {
      controller.expenseData = expenseData; // pass object
      // controller.expenseUniqueId.value = expenseData!.uniqueId!; // ensure ID
      controller.setRowEditValues(); // fill UI
    }
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Advance Request'),
      floatingActionButton: Container(
        //width: size.width * 0.4,
        padding: const EdgeInsets.all(8),
        child: ResponsiveButton(
          title: 'Save',
          function: () async {
            await controller.postAdvanceExpenses();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assignment_outlined),
                          SizedBox(width: 10.0),
                          Text('Advance Requisition Expense', style: kTxtStlB),
                        ],
                      ),
                      expenseData != null
                          ? Container(
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
                                    msg: 'Do you want to delete this Expense ?',
                                    yesBtnFun: () async {
                                      Navigator.pop(context);
                                      Utility.showCircularLoadingWid(context);
                                      await controller.deleteAdvanceExpensApi();
                                    },
                                    noBtnFun: () => Navigator.pop(context),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.dateController,
                              keyboardType: TextInputType.datetime,
                              title: 'Date',
                              onTap: () async {
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());
                                await selectDateSingle(
                                  dateSelected: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year),
                                  lastDate: DateTime(DateTime.now().year + 2),
                                ).then((date) {
                                  //  print(date);
                                  controller.dateController.text = DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(date);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Obx(
                              () => DropdownCustomList(
                                title: 'Type of Advance',
                                items:
                                    //  controller.categoryItem
                                    //     .map((e) =>
                                    //         DropdownMenuItem(value: e, child: Text(e)))
                                    //     .toList(),
                                    controller.categoryItem.map((
                                      categoryValue,
                                    ) {
                                      return DropdownMenuItem(
                                        value: categoryValue,
                                        child: Text(
                                          categoryValue,
                                          style: kTxtStl13N,
                                        ),
                                      );
                                    }).toList(),
                                value: controller.categorySelected.value,
                                onChanged: (categorySelectedValue) {
                                  // setState(() {
                                  controller.categorySelected.value =
                                      categorySelectedValue!;
                                  // });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.whatAndWhenExpnsController,
                              title: 'Description',
                              maxLines: 3,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Obx(
                          () => Row(
                            children: [
                              CustomAutoCompleteFieldView(
                                optionsBuilder: (TextEditingValue value) {
                                  return controller.empEntityList
                                      .where(
                                        (e) => e.username!
                                            .toLowerCase()
                                            .contains(value.text.toLowerCase()),
                                      )
                                      .toList();
                                },

                                displayStringForOption: (UserEntity e) {
                                  return e.username ?? '';
                                },

                                title: 'Approver',

                                /// ✅ SAFE VALUE
                                controllerValue:
                                    controller.approvedByName.value ?? '',

                                isCompulsory: true,

                                closeControllerFun: () {
                                  controller.approvedById.value = '';
                                  controller.approvedByName.value = null;
                                  controller.approvalFcmToken.value = null;
                                  controller.approvalMobNo.value = null;
                                },

                                onSelected: (UserEntity e) {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  controller.approvedById.value =
                                      e.emailid ?? '';
                                  controller.approvedByName.value = e.username;
                                  // controller.approvalFcmToken.value =
                                  //     e.fcmToken;
                                  controller.approvalMobNo.value = e.mobileno;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(2),
                          color: Colors.grey.shade200,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 20.0,
                                ),
                                child: Text('₹', style: kTxtStl14B),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,

                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: controller.amountController,
                                    decoration: InputDecoration(
                                      hintText: 'Amount',
                                      labelStyle: kTxtStl13GreyN,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 14,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    style: kTxtStl13N,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.15),
        ],
      ),
    );
  }
}
