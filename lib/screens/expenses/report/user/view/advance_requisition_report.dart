import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/calendar_range_view.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/expenses/report/user/controller/adv_req_report_controller.dart';
import 'package:sysconn_sfa/screens/expenses/views/entry/advance_requisition/advance_requisition_entry.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class MyAdvanceRequisitionReport extends StatelessWidget {
  MyAdvanceRequisitionReport({super.key});
  final controller = Get.put(AdvanceRequisitionReportController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Advance Requests',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CalendarRangeView(
                    function: () async {
                      // initCallFun();
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingButton(
        isExtended: false,
        icon: const Icon(Icons.add),
        title: null, //'Request Advance',
        function: () async {
          await Get.to(() => AdvanceRequisitionEntry());
          // getAdvExpensesDataAPI();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: kTxtStl13B,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: kAppColor),
              ),
              controller: controller.tabController,
              tabs: controller.advApproveTabList
                  .map((e) => Tab(text: e))
                  .toList(),
              // [
              //   Tab(child: Text(advApproveTabList[0])),
              //   Tab(child: Text(advApproveTabList[1])),
              //   Tab(child: Text(advApproveTabList[2])),
              // ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(child: Utility.processLoadingWidget());
              }

              if (controller.isDataLoad.value == 2) {
                return const NoDataFound();
              }
              return ListView.builder(
                itemCount: controller.expensesAdvDataList.length,
                itemBuilder: (context, i) {
                  final item = controller.expensesAdvDataList[i];

                  return InkWell(
                      onTap: item.approvalStatus == 'Pending'
                        ? () async {
                            await Get.to(() =>
                                AdvanceRequisitionEntry(
                                  expenseData: item,
                                ));
                            controller
                                .getAdvExpensesDataAPI();
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              DateCalendar(
                                date: controller.expensesAdvDataList[i].date!,
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${controller.expensesAdvDataList[i].category}',
                                      style: kTxtStl13B,
                                    ),
                                    Text(
                                      '${controller.expensesAdvDataList[i].expensesDetails}',
                                      style: kTxtStl13N,
                                    ),
                                    Text(
                                      indianRupeeFormat(
                                        double.parse(
                                          controller
                                              .expensesAdvDataList[i]
                                              .amount!,
                                        ),
                                      ),
                                      style: kTxtStl13B,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color:
                                      controller
                                              .expensesAdvDataList[i]
                                              .approvalStatus ==
                                          'Pending'
                                      ? Colors.grey.shade50
                                      : Colors.orange.shade50,
                                ),
                                child: Text(
                                  controller
                                      .expensesAdvDataList[i]
                                      .approvalStatus
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        controller
                                                .expensesAdvDataList[i]
                                                .approvalStatus ==
                                            'Pending'
                                        ? Colors.black
                                        : kAppColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
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
