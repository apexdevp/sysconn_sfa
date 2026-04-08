import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/controllers/buddy/sales/additionaldetails_controller.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
class Additionaldetails extends StatelessWidget {
  final SalesHeaderEntity? salesHeaderEntity;

  const Additionaldetails({super.key, this.salesHeaderEntity});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdditionaldetailsController(salesHeaderEntity: salesHeaderEntity),
    );

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: 'Additional Details',
      ),
      body: Obx(() {
        if (controller.isDataLoad.value == 0) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: EdgeInsets.fromLTRB(9, 14, 9, 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            color: Colors.grey[50],
          ),
          child: Column(
            children: [
              Expanded(
                child: _buildListRow(size, controller, context),
              ),
              ResponsiveButton(
                title: 'Save',
                function: () async {
                  Utility.showCircularLoadingWid(context);
                  await controller.additionalDetPostApi();
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // ---------------- UI METHOD -----------------

  Widget _buildListRow(Size size, AdditionaldetailsController controller,
      BuildContext context) {
    DateTime selecttodate = DateTime.now();
    final dateFormat = DateFormat("dd/MM/yyyy");

    return ListView(
      children: <Widget>[
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

        // ---------- OTHER DETAILS CARD ----------
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.vehicleNameController,
                      title: 'Vehicle no',
                    ),
                    SizedBox(width: size.width * 0.02),
                    CustomTextFormFieldView(
                      keyboardType: TextInputType.datetime,
                      controller: controller.dateController,
                      title: 'Date',
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectDateSingle(
                          dateSelected: selecttodate,
                          lastDate: DateTime(
                              (selecttodate.month >= 1 &&
                                      selecttodate.month <= 3)
                                  ? selecttodate.year
                                  : selecttodate.year + 1,
                              3,
                              31),
                        ).then((date) {
                          selecttodate = date;
                          controller.dateController.text =
                              dateFormat.format(selecttodate);
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.dispatchcntrl,
                      title: 'Despatched through',
                    ),
                    SizedBox(width: size.width * 0.02),
                    CustomTextFormFieldView(
                      controller: controller.mailingNamecntrl,
                      keyboardType: TextInputType.name,
                      title: 'Mailing Name',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ---------- BILLED TO ----------
        Container(
          width: size.width,
          padding: EdgeInsets.all(8.0),
          child: Row(children: [
            Icon(Icons.location_city),
            SizedBox(width: 10.0),
            Text('Billed To', style: kTxtStlB),
          ]),
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
                      keyboardType: TextInputType.name,
                      title: 'Party Name',
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.addressBilledTextController,
                      title: 'Address',
                    ),
                  ],
                ),
                
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.gstinBilledTextController,
                      title: 'GSTIN',
                      maxLength: 15,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomAutoCompleteFieldView(
                      optionsBuilder: (value) {
                        return Utility.stateDropdownlist
                            .where((element) =>
                                element.toLowerCase().contains(
                                    value.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (option) => option,
                      title: 'State',
                      controllerValue:
                          controller.stateBilledTextController.text,
                      closeControllerFun: () {
                        controller.stateBilledTextController.text = '';
                      },
                      onSelected: (stateSelected) {
                        controller.stateBilledTextController.text =
                            stateSelected;
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        // ---------- SHIPPED TO ----------
        Container(
          width: size.width,
          padding: EdgeInsets.all(8.0),
          child: Row(children: [
            Icon(Icons.location_city),
            SizedBox(width: 10.0),
            Text('Shipped To', style: kTxtStlB),
          ]),
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.cosigneeNameShippedTextController,
                      title: 'Cosignee Name',
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.address01ShippedTextController,
                      title: 'Address',
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.gstinShippedTextController,
                      title: 'GSTIN',
                      maxLength: 15,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomAutoCompleteFieldView(
                      optionsBuilder: (value) {
                        return Utility.stateDropdownlist
                            .where((element) =>
                                element.toLowerCase().contains(
                                    value.text.toLowerCase()))
                            .toList();
                      },
                      displayStringForOption: (option) => option,
                      title: 'State',
                      isCompulsory: true,
                      controllerValue:
                          controller.stateShippedTextController.text,
                      closeControllerFun: () {
                        controller.stateShippedTextController.text = '';
                      },
                      onSelected: (stateSelected) {
                        controller.stateShippedTextController.text =
                            stateSelected;
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
