import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/controller/so_additional_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/controller/so_create_controller.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart';

class SoAdditionalDetails extends StatelessWidget {
  final CreateSoController socontroller;

  SoAdditionalDetails({super.key, required this.socontroller});

  @override
  Widget build(BuildContext context) {
    final SOAdditionalDetailsController controller = Get.put(
      SOAdditionalDetailsController(),

    );
    controller.loadEntityOnce(socontroller.salesOrderHeaderEntity.value);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Additional Details'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_city),
                      SizedBox(width: 10.0),
                      Text('Billed To', style: kTxtStlB),
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
                              controller: controller.partyNameController,
                              title: "Party Name",
                              enabled: false,
                              // countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  controller.addressBilledLine1Controller,
                              title: "Address Line 1",
                              // countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  controller.addressBilledLine2Controller,
                              title: "Address Line 2",
                              // countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.gstinBilledController,
                              maxLength: 15,
                              title: "GSTIN",
                              countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomAutoCompleteFieldView(
                              title: 'State',
                              // countertext: true,
                              optionsBuilder: (TextEditingValue value) {
                                return Utility.stateDropdownlist
                                    .where(
                                      (element) => element
                                          .toLowerCase()
                                          .contains(value.text.toLowerCase()),
                                    )
                                    .toList();
                              },
                              controllerValue:
                                  controller.stateBilledController.text,
                              closeControllerFun: () {
                                controller.stateBilledController.text = '';
                              },

                              onSelected: (text) {
                                controller.stateBilledController.text = text;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_city),
                      SizedBox(width: 10.0),
                      Text('Shipped To', style: kTxtStlB),
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
                              controller: controller.consigneeNameController,
                              title: "Consignee Name",
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  controller.addressShippedLine1Controller,
                              title: "Address Line 1",
                              // countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  controller.addressShippedLine2Controller,
                              title: "Address Line 2",
                              // countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.gstinShippedController,
                              title: "GSTIN",
                              maxLength: 15,
                              countertext: true,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomAutoCompleteFieldView(
                              title: 'State',
                              // countertext: true,
                              optionsBuilder: (TextEditingValue value) {
                                return Utility.stateDropdownlist
                                    .where(
                                      (element) => element
                                          .toLowerCase()
                                          .contains(value.text.toLowerCase()),
                                    )
                                    .toList();
                              },
                              controllerValue:
                                  controller.stateShippedController.text,
                              closeControllerFun: () {
                                controller.stateShippedController.text = '';
                              },

                              onSelected: (text) {
                                controller.stateShippedController.text = text;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.assignment_outlined),
                      SizedBox(width: 10.0),
                      Text('Other Details', style: kTxtStlB),
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
                              controller: controller.dateController,
                              keyboardType: TextInputType.datetime,
                              title: 'LR Date',
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());
                                selectDateSingle(
                                  dateSelected: controller.selectedDate.value,
                                  firstDate: controller.selectedDate.value
                                      .subtract(const Duration(days: 12)),
                                  lastDate: DateTime(
                                    controller.selectedDate.value.year + 1,
                                  ),
                                ).then((date) {
                                  // debugPrint(date);
                                  controller.selectedDate.value = date;
                                  controller.dateController.text = controller
                                      .dateFormat
                                      .format(date);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.vehicleNameController,
                              keyboardType: TextInputType.text,
                              title: 'Vehicle Name',
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.dispatchController,
                              keyboardType: TextInputType.text,
                              title: 'Dispatched Through',
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.mailingNameController,
                              keyboardType: TextInputType.name,
                              title: 'Mailing Name',
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: controller.remarkController,
                              keyboardType: TextInputType.name,
                              title: 'Remark',
                              maxLines: 3,
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
          Container(
            width: size.width * 0.6,
              padding: const EdgeInsets.all(4),
            child: ResponsiveButton(
              title: 'Save',
              function: () async {
                controller.updateFromControllers();
                await controller.postSOHeaderBillTo();
                await socontroller.loadSalesOrderForEdit();
              },
            ),
          ),
        ],
      ),
    );
  }
}
