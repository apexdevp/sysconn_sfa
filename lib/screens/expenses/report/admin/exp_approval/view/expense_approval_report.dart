import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/calendar_range_view.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/controller/exp_approval_rpt_controller.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/controller/exp_approval_view_controller.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/view/expenses_approval_view.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/search_textfield.dart';

class ExpensesApprovalReport extends StatelessWidget {
  ExpensesApprovalReport({super.key});
  final controller = Get.put(ExpensesApprovalReportController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: 'Team Expense Requests',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CalendarRangeView(
                    function: () async {
                      controller.checkApiDet();
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => Card(
          color: Colors.blueGrey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total', style: kTxtStl13B),
                  ),
                ),
                Expanded(
                  child: Text(
                    '₹ ${controller.expTotal.value}',
                    style: kTxtStl13B,
                    textAlign: TextAlign.right,
                  ),
                ),
                // SizedBox(width: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          SearchTextfield(
            onChanged: controller.searchExpense,
            closeFunction: controller.checkApiDet,
          ),
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
              controller: controller.expApproveTabController,
              tabs: controller.expApproveTabList
                  .map((e) => Tab(text: e))
                  .toList(),
            ),
            // ),
          ),
          Expanded(child: Obx(() {
             if (controller.isDataLoad.value == 0) {
                return Center(child: Utility.processLoadingWidget());
              }
              if (controller.isDataLoad.value == 2) {
                return NoDataFound();
              }
              return ListView.builder(
                 itemCount:
                    controller.expnsesReprtDataList.length,
                //     itemBuilder:  (_, i) {
                //   final item =
                //       controller.expnsesReprtDataList[i];

                //   return InkWell(
                //     onTap: () =>
                //         controller.onItemTap(item),
                //     child: buildExpenseCard(item, size),
                //   );
                // },
                  itemBuilder: (context, i) {
                       final item =
                      controller.expnsesReprtDataList[i];
              return InkWell(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateCalendar(date: item.date!),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(item.employeeName!,style: kTxtStl13N,),
                              Text('${item.vchprefix}${item.maxNo}',style: kTxtStl13B,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text('Claimed : ${indianRupeeFormat(expnsesReprtDataList[i].claimedAmount!)}',style: kTxtStl13N,),
                                     item.approvalStatus !='Pending' &&item.rejectAmount !=0?
                                      Row(
                                        children: [
                                          
                                          Text('Rejected : ${indianRupeeFormat(item.rejectAmount?.toDouble() ?? 0.0)}',style: kTxtStl13N,),
                                        ],
                                      )
                                      :Container()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        item.approvalStatus =='Approved'?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Approved ',style: kTxtStl13GreyN,),
                            Text(indianRupeeFormat(item.approvedamt?.toDouble() ?? 0.0),style: kTxtStl15B,),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Claimed ',style: kTxtStl13GreyN,),
                            Text(indianRupeeFormat(item.claimedAmount?.toDouble() ?? 0.0),style: kTxtStl15B,),
                          ],
                        ),
                        // Container(),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
                ),
                onTap: () async{
              // add tally download filled condition // bzce not edit required
                  if (item.istallydownload != 'Yes') {
                  //   await Navigator.of(context).push(MaterialPageRoute(builder:(context) => 
                  //   ExpensesApprovalView(expensesHedId: expnsesReprtDataList[i].uniqueId,),),);
                    
                  // //  controller.getExpensesApprovalReportAPI();
                   Get.to(
                          () =>  ExpensesApprovalView(),
                          binding: BindingsBuilder(() {
                            Get.put(
                              ExpensesApprovalViewController(item.uniqueId),
                            );
                          }),
                        );
                  }
                  else{   // Manisha 06-08-2025
                    scaffoldMessageBar('Editing is disabled because this record has been downloaded to tally.',);
                  }
                },
              );
            },
                );
          }))
        ],
      ),
    );
  }
}
