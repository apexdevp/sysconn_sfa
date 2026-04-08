import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/adv_exp_approval/controller/adv_exp_approval_status_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/dropdownlist.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

class AdvExpenseApprView extends StatelessWidget {
  final AdvExpensesEntity expenseDetList;

  AdvExpenseApprView({super.key, required this.expenseDetList});

  late final AdvExpenseApprController controller = Get.put(
    AdvExpenseApprController(expenseDetList),
  );

  Row expDetRow(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    Size size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.2,
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
      appBar: customAppbar(context: context, title: 'Advanced Approval'),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ResponsiveButton(
          title: 'Submit',
          function: () async {
            Utility.showCircularLoadingWid(context);
            await controller.postExpensesStatusApi();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
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
                        Text(
                          indianRupeeFormat(
                            num.parse(expenseDetList.amount!).toDouble(),
                          ),
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: kAppColor,
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
                      Icon(FontAwesomeIcons.indianRupeeSign),
                      SizedBox(width: 10),
                      Text('Advance Requisition', style: kTxtStlB),
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
                            expenseDetList.empname!,
                            style: kTxtStl13GreyB,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(color: Colors.grey, indent: 10, endIndent: 10),
                        SizedBox(height: size.height * 0.01),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: expDetRow(
                                  context,
                                  title: 'Date',
                                  value: DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(expenseDetList.date!),
                                  ),
                                ),
                              ),
                              VerticalDivider(color: Colors.grey),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: expDetRow(
                                  context,
                                  title: 'Type',
                                  value: expenseDetList.category!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        expDetRow(
                          context,
                          title: 'Description',
                          value: expenseDetList.expensesDetails!,
                        ), // Expense Details
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.approval_rounded),
                      SizedBox(width: 10.0),
                      Text('Approval Status', style: kTxtStlB),
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
                                items: controller.statusItem.map((statusValue) {
                                  return DropdownMenuItem<String>(
                                    value: statusValue,
                                    child: Text(statusValue, style: kTxtStl13N),
                                  );
                                }).toList(),
                                value: controller.statusSelected.value,
                                onChanged: (String? statusSelectedValue) {
                                  controller.statusSelected.value =
                                      statusSelectedValue!;
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
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }
}
