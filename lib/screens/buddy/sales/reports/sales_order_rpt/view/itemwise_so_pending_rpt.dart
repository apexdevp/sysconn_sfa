import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/sales_order_rpt/controller/itemwise_so_pending_controller.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:trina_grid/trina_grid.dart';

class ItemWiseSOPendingReport extends StatelessWidget {
  ItemWiseSOPendingReport({super.key});
  final SOItemDetailsController controller = Get.put(SOItemDetailsController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Item Wise SO Pending',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
      //             IconButton(
      //               // tooltip: 'Download',
      //               onPressed: () {
      //                   final isFilterActive = controller.stateManager!.hasFilter;
      //  Utility.exportToCsv(
      //       reportTitle: 'Sales Order Register',
      //       columns: controller.stateManager!.columns,
      //       allRows: isFilterActive
      //           ? controller.stateManager!.refRows.filteredList
      //           : controller.stateManager!.refRows.originalList,
      //     );
      //               },
      //               icon: const Icon(
      //                 Icons.file_download_outlined,
      //                 size: 20,
      //                 color: Colors.black,
      //               ),
      //             ),
                  Obx(
                    () => CalendarSingleView(
                      fromDate: controller.fromDate.value,
                      toDate: controller.toDate.value,
                      function: () async {
                        await selectDateRange(
                          controller.fromDate.value,
                          controller.toDate.value,
                        ).then((dateTimeRange) {
                          controller.fromDate.value = dateTimeRange.start;
                          controller.toDate.value = dateTimeRange.end;
                        });
                        controller.fetchSalesOrders();
                      },
                    ),
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
          Expanded(
            child: Obx(() {
              if (controller.loadState.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                );
              }
              if (controller.loadState.value == 2) {
                return Center(child: const NoDataFound());
              }

              return trinaCustomTheme(
                context: context,
                iscolumnsize: true,
                columns: _columns(context, size),
                rows: controller.rows,
                onLoaded: (e) => controller.stateManager = e.stateManager,
                select: TrinaGridMode.select,
              );
            }),
          ),
        ],
      ),
    );
  }

  RxList<TrinaColumn> _columns(BuildContext context, Size size) {
    return [
      // // gridColumnRpt(field: 'status', title: 'STATUS', width: 140),
      gridColumnRpt(field: 'date', title: 'DATE', width: 140),
      gridColumnRpt(field: 'order_no', title: 'ORDER NO'),
      gridColumnRpt(field: 'sales_person', title: 'SALES PERSON'),
      gridColumnRpt(field: 'party', title: 'PARTY', width: 220),
      gridColumnRpt(field: 'item_name', title: 'ITEM'),
      gridColumnRpt(
        field: 'quantity',
        title: 'ORDER QTY',
        istext: false,
        width: 130,
        isfooter: true,
      ),
      gridColumnRpt(
        field: 'salequantity',
        title: 'SALES QTY',
        istext: false,
        width: 130,
      ),
      gridColumnRpt(
        field: 'preclose',
        title: 'PRE CLOSE',
        istext: false,
        width: 130,
      ),
      gridColumnRpt(
        field: 'balancequantity',
        title: 'BALANCE QTY',
        istext: false,
        width: 130,
      ),
      gridColumnRpt(
        field: 'rate',
        title: 'RATE',
        istext: false,
        isfooter: true,
      ),
      gridColumnRpt(
        field: 'value',
        title: 'AMOUNT',
        istext: false,
        isfooter: true,
      ),
      gridColumnRpt(field: 'due_date', title: 'DUE DATE', width: 140),
    ].obs;
  }
}
