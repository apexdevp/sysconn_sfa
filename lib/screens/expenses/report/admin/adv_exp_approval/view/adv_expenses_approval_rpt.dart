import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/calendar_range_view.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/adv_exp_approval/controller/adv_exp_approval_controller.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/adv_exp_approval/view/adv_exp_approval_view.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class AdvExpensesApprovalReport extends StatelessWidget {
  AdvExpensesApprovalReport({super.key});
  final controller = Get.put(AdvExpensesApprovalController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Team Advance Requests',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CalendarRangeView(
                    function: () async {
                      controller.getAdvExpensesDataAPI();
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,

              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey, // .shade700
              labelStyle: kTxtStl13B,
              indicator: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(color: kAppColor),
              ),
              controller: controller.tabController,
              tabs:
                  // [
                  //   Tab(
                  //     child: Text(expenseApprovalTabList[0],),
                  //   ),
                  //   Tab(
                  //     child: Text(expenseApprovalTabList[1],),
                  //   ),
                  //   Tab(
                  //     child: Text(expenseApprovalTabList[2],),
                  //   ),
                  // ],
                  controller.expenseApprovalTabList
                      .map((e) => Tab(text: e))
                      .toList(),
            ),
            // ),
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
                itemCount: controller.expensesApprDataList.length,
                itemBuilder: (context, i) {
                  final item = controller.expensesApprDataList[i];
                  return InkWell(
                    onTap: () async {
                      await Get.to(
                        () => AdvExpenseApprView(expenseDetList: item),
                      );
                      controller.getAdvExpensesDataAPI();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DateCalendar(date: item.date!),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(item.empname!, style: kTxtStl13N),
                                  SizedBox(height: size.height * 0.01),
                                  Text(item.category!, style: kTxtStl13N),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text('Amount ', style: kTxtStl13N),
                                Text(
                                  indianRupeeFormat(double.parse(item.amount!)),
                                  style: kTxtStl15B,
                                ),
                              ],
                            ),
                          ],
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
