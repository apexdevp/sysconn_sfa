import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/payment_followup_create_controller.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

import '../../../../../../widgetscustome/dropdowncontroller.dart';

class PaymentFollowUpCreate extends StatelessWidget {
  final String? partyId;
  final PartyEntity? partyEntity;
  const PaymentFollowUpCreate({super.key, this.partyEntity, this.partyId});

  Row customerDetails(Size size, String maintitle, String subtitle) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.4,
          child: Text(maintitle, style: kTxtStl12N),
        ),
        Text(': ', style: kTxtStl12N),
        Expanded(child: Text(subtitle, style: kTxtStl12N)),
      ],
    );
  }

  Future<void> showTimePick(
    BuildContext context,
    PaymentFollowUpCreateController controller,
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();

      final selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      String formattedTime = DateFormat('HH:mm:ss').format(selectedTime);

      controller.nextTimeController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PaymentFollowUpCreateController(partyId!, partyEntity),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Payment Followup Create'),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(partyEntity!.mailingname!, style: kTxtStl13B),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        partyEntity!.contactPerson! != ''
                            ? Row(
                                children: [
                                  Icon(Icons.person, color: Colors.grey),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    partyEntity!.contactPerson!,
                                    style: kTxtStl12N,
                                  ),
                                ],
                              )
                            : Container(),
                        partyEntity!.contactNo! != ''
                            ? Row(
                                children: [
                                  Icon(Icons.call, color: Colors.grey),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    partyEntity!.contactNo!,
                                    style: kTxtStl12N,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    customerDetails(
                      size,
                      'Customer Classification',
                      partyEntity!.customerClassification ?? '',
                    ),
                    customerDetails(
                      size,
                      'Payment Terms',
                      partyEntity!.creditdays.toString(),
                    ),
                    customerDetails(
                      size,
                      'Credit Limit',
                      partyEntity!.creditlimit!.toString(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              'Last Payment Followup',
                              style: kTxtStlB,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.all(size.height * 0.01),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          'Last followup date',
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                      Text(': ', style: kTxtStl12GreyN),
                                      Expanded(
                                        child: Text(
                                          controller.lastFollowupDate.value,
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          'Payment Done With',
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                      Text(': ', style: kTxtStl12GreyN),
                                      Expanded(
                                        child: Text(
                                          controller.lastPayDoneWith.value,
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          'Remark',
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                      Text(': ', style: kTxtStl12GreyN),
                                      Expanded(
                                        child: Text(
                                          controller.lastRemark.value,
                                          style: kTxtStl12GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Todays Follow Up Details',
                                      style: kTxtStlB,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller:
                                              controller.outstandingController,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            labelText: "Outstanding",
                                            hintText: "Outstanding",
                                            contentPadding: EdgeInsets.fromLTRB(
                                              10,
                                              4,
                                              4,
                                              4,
                                            ),
                                            labelStyle: kTxtStl13N,
                                          ),
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.1),
                                      Flexible(
                                        child: TextField(
                                          controller: controller
                                              .overdueAmountController,
                                          enabled: false,
                                          decoration: InputDecoration(
                                            labelText: "Overdue Amount",
                                            hintText: "Overdue Amount",
                                            contentPadding: EdgeInsets.fromLTRB(
                                              10,
                                              4,
                                              4,
                                              4,
                                            ),
                                            labelStyle: kTxtStl13N,
                                          ),
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      right: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              //  Obx(
                                              //   () =>
                                              DropdownCustomList(
                                                title: 'Followup Type',

                                                items: controller
                                                    .followuptypeForItem
                                                    .map<
                                                      DropdownMenuItem<String>
                                                    >((String statusForvalue) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: statusForvalue,
                                                        child: Text(
                                                          statusForvalue,
                                                          style: kTxtStl13N,
                                                        ),
                                                      );
                                                    })
                                                    .toList(),

                                                selectedValue: controller
                                                    .followupForSelected,
                                                onChanged:
                                                    (
                                                      String?
                                                      statusForSelectedValue,
                                                    ) {
                                                      controller
                                                              .followupForSelected
                                                              .value =
                                                          statusForSelectedValue!;
                                                    },
                                              ),
                                        ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    children: [
                                      CustomTextFormFieldView(
                                        controller:
                                            controller.followdoneWithController,
                                        title: 'FollowUp Done With',
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      CustomTextFormFieldView(
                                        keyboardType: TextInputType.number,
                                        controller:
                                            controller.followUpAmountController,
                                        title: 'FollowUp Amount',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),

                                  Row(
                                    children: [
                                      CustomTextFormFieldView(
                                        keyboardType: TextInputType.datetime,
                                        controller:
                                            controller.nextDateController,
                                        title: 'Next Followup Date',
                                        // onTap: () {
                                        //   FocusScope.of(
                                        //     context,
                                        //   ).requestFocus(new FocusNode());
                                        //   selectDateSingle(

                                        //     dateSelected: DateTime.now(),
                                        //     lastDate: DateTime(
                                        //       DateTime.now().year + 2,
                                        //     ),
                                        //   ).then((date) {

                                        //        controller.dateTimeNotifier.value = date;
                                        //        controller.nextDateController.text =
                                        //           DateFormat(
                                        //             'dd/MM/yyyy',
                                        //           ).format(date);

                                        //   });
                                        // },
                                        onTap: () {
                                          FocusScope.of(context).unfocus();

                                          selectDateSingle(
                                            dateSelected: DateTime.now(),
                                            lastDate: DateTime(
                                              DateTime.now().year + 2,
                                            ),
                                          ).then((date) {
                                            controller.dateTimeNotifier.value =
                                                date;
                                            controller.nextDateController.text =
                                                DateFormat(
                                                  'dd/MM/yyyy',
                                                ).format(date);
                                          });
                                        },
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      CustomTextFormFieldView(
                                        controller:
                                            controller.nextTimeController,
                                        title: 'Time',
                                        onTap: () {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(FocusNode());
                                          showTimePick(context, controller);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
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
                    ResponsiveButton(
                      title: 'Submit',
                      function: () async {
                        Utility.showCircularLoadingWid(context);
                        await controller.postPaymentFollowupAPi();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
