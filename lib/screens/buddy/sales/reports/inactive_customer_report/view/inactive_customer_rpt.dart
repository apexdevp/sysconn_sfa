import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/inactive_customer_report/controller/inactive_customer_controller.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class InactiveCustomerReport extends StatelessWidget {
  const InactiveCustomerReport({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(InactiveCustomerController());
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Inactive Customer Report'),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Inactive Days '),
                  SizedBox(
                    width: size.width * 0.2,
                    child: Card(
                      elevation: 3.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: controller.inactivecustomerController,
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          controller.inactivecustomerController.text = text;
                          Utility().cursorPosition(
                            controller.inactivecustomerController,
                            controller.inactivecustomerController.text,
                          );

                          controller.getUnbillItemReportAPI();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(size.height * 0.01),
                  child: Text('Name & Closing', style: kTxtStl13B),
                ),
              ),
              SizedBox(
                width: size.width * 0.3,
                child: Text('Last Sale Date', style: kTxtStl13B),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                );
              }

              if (controller.isDataLoad.value == 2) {
                return NoDataFound();
              }
              return ListView.builder(
                itemCount: controller.unbillItemDataList.isEmpty
                    ? 0
                    : controller.unbillItemDataList.length,
                itemBuilder: (context, i) {
                  final item = controller.unbillItemDataList[i];
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name!, style: kTxtStl13B),
                                Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.35,
                                      child: Text(
                                        'Outstanding Amount',
                                        style: kTxtStl13GreyN,
                                      ),
                                    ),
                                    Text(':', style: kTxtStl13GreyN),
                                    Expanded(
                                      child: Text(
                                        num.parse(
                                          item.amount!,
                                        ).round().toString(),
                                        style: kTxtStl13GreyN,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.3,
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('d MMM y')
                                      .format(DateTime.parse(item.date!))
                                      .toString(),
                                  style: kTxtStl13GreyN,
                                ),
                                Text(
                                  '(${DateTime.now().difference(DateTime.parse(item.date!)).inDays.toString()} Days)',
                                  style: kTxtStl13GreyN,
                                ),
                              ],
                            ),
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
    );
  }
}
