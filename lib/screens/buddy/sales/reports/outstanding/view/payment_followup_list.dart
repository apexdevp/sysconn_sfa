import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/payment_followup_list_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/payment_folowup_create.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PaymentFollowupList extends StatelessWidget {
  final String? partyId;
  const PaymentFollowupList({super.key, this.partyId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentFollowupController(partyId));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Payment Followup List'),
      drawer: const DrawerForAll(),
      floatingActionButton: FloatingButton(
        title: 'Create Followup',
        icon: Icon(Icons.add),
        function: () async {
         
          if (controller.partyEntityvalue.value != null) {
            Get.to(
              () => PaymentFollowUpCreate(
                partyEntity: controller.partyEntityvalue.value,
                partyId: partyId,
              ),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Obx(
          () => Column(
            children: [
              Container(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text(controller.customerName.value, style: kTxtStlB),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.contactPerson.value != ''
                              ? Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.grey),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      controller.contactPerson.value,
                                      style: kTxtStl12N,
                                    ),
                                  ],
                                )
                              : Container(),
                          controller.contactno.value != ''
                              ? Row(
                                  children: [
                                    Icon(Icons.call, color: Colors.grey),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      controller.contactno.value,
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
                        controller.customerClassification.value,
                      ),
                      customerDetails(
                        size,
                        'Payment Terms',
                        controller.paymentTerm.value,
                      ),
                      customerDetails(
                        size,
                        'Credit Limit',
                        controller.creditLimit.value.toString(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Expanded(
                child: Obx(() {
                  if (controller.isDataLoad.value == 0) {
                    return Center(
                      child: Utility.processLoadingWidget()
                    );
                  }

                  if (controller.isDataLoad.value == 2) {
                    return NoDataFound();
                  }
                  return ListView.builder(
                    itemCount: controller.paymentFollowupDataList.isEmpty
                        ? 0
                        : controller.paymentFollowupDataList.length,
                    itemBuilder: (context, i) {
                      final item = controller.paymentFollowupDataList[i];
                      return Card(
                        elevation: 2,
                        child: Container(
                          padding: EdgeInsets.all(size.height * 0.01),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [DateCalendar(date: item.date!)],
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: Column(
                                  children: [
                                    payfollowListTitleRow(
                                      'Next Followup Date',
                                      '${item.nextFollowUpDate}' != ''
                                          ? DateFormat('dd-MM-yyyy')
                                                .format(
                                                  DateTime.parse(
                                                    item.nextFollowUpDate!,
                                                  ),
                                                )
                                                .toString()
                                          : '',
                                      size,
                                    ),
                                    payfollowListTitleRow(
                                      'Followup By',
                                      item.followUpBy!,
                                      size,
                                    ),
                                    payfollowListTitleRow(
                                      'Remark',
                                      item.remarks!,
                                      size,
                                    ), // komal // remark added
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    indianRupeeFormat(
                                      double.parse(item.followUpAmount!),
                                    ),
                                    style: kTxtStl13B,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row customerDetails(Size size, String maintitle, String subtitle) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.4,
          child: Text(maintitle, style: kTxtStl12N),
        ),
        Text(':', style: kTxtStl12N),
        Expanded(child: Text(subtitle, style: kTxtStl12N)),
      ],
    );
  }

  Row payfollowListTitleRow(String title, String value, Size size) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.25,
          child: Text(title, style: kTxtStl13GreyN),
        ),
        Text(': ', style: kTxtStl13GreyN),
        Expanded(child: Text(value, style: kTxtStl13GreyN)),
      ],
    );
  }
}
