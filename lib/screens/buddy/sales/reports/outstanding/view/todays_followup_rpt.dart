import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/todays_followup_controller.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class TodayFollowupReport extends StatelessWidget {
  final String? mobileno;
  final String? fromdate;
  final String? todate;
  TodayFollowupReport({super.key, this.fromdate, this.mobileno, this.todate});

  Row payfollowDetTitleRow(String title, String value, Size size) {
    return Row(
      children: [
        Container(
          width: size.width * 0.4,
          child: Text(title, style: kTxtStl13GreyN),
        ),
        Text(': ', style: kTxtStl13GreyN),
        Flexible(
          child: Column(children: [Text(value, style: kTxtStl13GreyN)]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TodayFollowupController(
        mobileno: mobileno,
        fromdate: fromdate,
        todate: todate,
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Payment Followup Details'),
      drawer: const DrawerForAll(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  );
                }
            
                if (controller.isDataLoad.value == 2) {
                  return Center(child: NoDataFound());
                }
                return ListView.builder(
                  itemCount: controller.paymentFollowupDataList.isEmpty
                      ? 0
                      : controller.paymentFollowupDataList.length,
                  itemBuilder: (context, i) {
                    final item = controller.paymentFollowupDataList[i];
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.partyName!, style: kTxtStl13B),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              children: [
                                DateCalendar(date: item.date!),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Column(
                                    children: [
                                      payfollowDetTitleRow(
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
                                      payfollowDetTitleRow(
                                        'Remark',
                                        item.remarks!,
                                        size,
                                      ),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }
}
