import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/my_customer_list/controller/my_customer_list_controller.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:trina_grid/trina_grid.dart';

class MyCustomerList extends StatefulWidget {
  final String partyGroup;
  MyCustomerList({super.key, required this.partyGroup});

  @override
  State<MyCustomerList> createState() => _MyCustomerListState();
}

class _MyCustomerListState extends State<MyCustomerList> {
  late final MyCustomerListController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(
      MyCustomerListController(partyGroup: widget.partyGroup),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'My Customer List'),
      body: Column(
        children: [
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
                return Center(child: const NoDataFound());
              }

              return trinaCustomTheme(
                context: context,
                iscolumnsize: true,
                columns: [
                  gridColumnRpt(field: 'state', title: 'STATE'),
                  gridColumnRpt(
                    field: 'party_code',
                    title: '${widget.partyGroup.toUpperCase()} CODE',
                  ),
                  gridColumnRpt(
                    field: 'party_name',
                    title: '${widget.partyGroup.toUpperCase()} NAME',
                  ),
                  gridColumnRpt(field: 'constitution', title: 'CONSTITUTION'),
                  gridColumnRpt(
                    field: 'active',
                    title: 'ACTIVE',
                    // renderer: (rendererContext) {
                    //   final cells = rendererContext.row.cells;
                    //   final status =
                    //       cells['active']?.value?.toString() ?? 'Inactive';
                    //   final isActive = status.toLowerCase() == 'active';
                    //   final textColor = Colors.black;
                    //   final borderColor = isActive ? Colors.green : Colors.red;
                    //   final backgroundColor = isActive
                    //       ? Color(0xFFE8F5E9)
                    //       : Color(0xFFFDECEA);
                    //   return Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 8,
                    //       vertical: 4,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: backgroundColor,
                    //       borderRadius: BorderRadius.circular(5),
                    //       border: Border.all(color: borderColor, width: 1),
                    //     ),
                    //     child: Text(
                    //       status,
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         fontSize: 11,
                    //         fontWeight: FontWeight.w600,
                    //         color: textColor,
                    //       ),
                    //     ),
                    //   );
                    // },
                  ),
                  gridColumnRpt(field: 'group', title: 'GROUP'),
                  gridColumnRpt(field: 'isbilled', title: 'IS BILLED'),
                  gridColumnRpt(field: 'pricelist', title: 'PRICE LIST'),
                  gridColumnRpt(field: 'city', title: 'CITY'),
                  gridColumnRpt(field: 'area', title: 'AREA'),
                  gridColumnRpt(field: 'locality', title: 'LOCALITY'),
                  gridColumnRpt(field: 'gst_no', title: 'GST NO.'),
                  gridColumnRpt(field: 'pan_no', title: 'PAN NO.'),
                  gridColumnRpt(
                    field: 'incorporation_date',
                    title: 'INCORPORATION DATE',
                  ),
                  gridColumnRpt(field: 'reffered_by', title: 'REFFERED BY'),

                  gridColumnRpt(
                    field: 'tallystatus',
                    title: 'SYNC',
                    // width: 135,
                  ),
                  gridColumnRpt(
                    field: 'tallysyncdate',
                    title: 'DOWNLOAD DATE',
                    // width: 130,
                  ),
                ].obs,
                rows: controller.rows,
                onLoaded: (event) {
                  controller.stateManager = event.stateManager;
                },
                onselected: (event) async {},

                select: TrinaGridMode.selectWithOneTap,
              );
            }),
          ),
        ],
      ),
    );
  }
}
