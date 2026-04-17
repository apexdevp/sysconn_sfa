import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/os_recpay_bill_details.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:trina_grid/trina_grid.dart';

import '../controller/os_party_group_ledger_controller.dart';

class OutstandingPartyGroupLedgerDashboard extends StatelessWidget {
  final String? dashboardtypename;
  final String? groupId;
  final String? groupName;
  final String? ageBy;
  final String? osType;
  const OutstandingPartyGroupLedgerDashboard({
    super.key,
    this.ageBy,
    this.dashboardtypename,
    this.groupId,
    this.groupName,
    this.osType,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OutstandingPartyGroupLedgerController(ageBy: ageBy, osType: osType),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Outstanding Receivable Dashboard'),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), //(12, 8, 12, 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                groupName!,
                style: kTxtStlB,
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: ExpansionTile(
                title: Text("${dashboardtypename!} Summary", style: kTxtStl12B),
                initiallyExpanded: true,
                iconColor: Colors.black,
                textColor: Colors.black,
                collapsedTextColor: Colors.grey,
                children: [
                  Container(
                    color: Colors.white,
                    child: Obx(() {
                      return controller.isDataLoad.value != 1
                          ? Center(
                              child: controller.isDataLoad.value == 0
                                  ? Utility.processLoadingWidget()
                                  : Text('No Data'),
                            )
                          : Container(
                              height: size.height * 0.3,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieResponse) {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieResponse == null ||
                                              pieResponse.touchedSection ==
                                                  null) {
                                            controller.touchedIndex.value = -1;
                                            return;
                                          }
                                          controller.touchedIndex.value =
                                              pieResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                        },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  sectionsSpace: 2,

                                  centerSpaceRadius: 20,
                                  sections: controller.showsections(
                                    controller.touchedIndex.value,
                                  ),
                                ),
                              ),
                            );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Obx(() {
                  if (controller.isDataLoad.value != 1) {
                    return Center(
                      child: controller.isDataLoad.value == 0
                          ? Utility.processLoadingWidget()
                          : NoDataFound(),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: trinaCustomTheme(
                          context: context,
                          columns: [
                            gridColumnRpt(field: 'name', title: 'Name'),
                            gridColumnRpt(
                              field: 'date',
                              title: 'Date ',
                              hide:
                                  dashboardtypename == 'Outstanding Receivable'
                                  ? false
                                  : true,
                            ),
                            gridColumnRpt(
                              field: 'amount',
                              title: 'Amount',
                              istext: false,
                            ),
                            gridColumnRpt(field: 'id', title: 'Id', hide: true),
                            gridColumnRpt(
                              field: 'followup_type',
                              title: 'followup_type',
                              hide: true,
                            ),
                          ].obs,
                          onLoaded: (TrinaGridOnLoadedEvent event) {
                            event.stateManager.setShowColumnFilter(true);
                             controller.stateManager = event.stateManager;
                            event.stateManager.pageSize;
                          },
                          onselected: (TrinaGridOnSelectedEvent event) {
                            if (event.row != null) {
                              final selectedRow = event.row!;
                              final selectedname = selectedRow
                                  .cells['name']!
                                  .value
                                  .toString();
                              final selectedid = selectedRow.cells['id']!.value
                                  .toString();

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OutstandingRecPayBillDetails(
                                        partyId: selectedid,
                                        partyName: selectedname,
                                      ),
                                ),
                              );
                            }
                          },
                          select: TrinaGridMode.select,
                          configuration: const TrinaGridConfiguration(),
                          rows: controller.rows,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
