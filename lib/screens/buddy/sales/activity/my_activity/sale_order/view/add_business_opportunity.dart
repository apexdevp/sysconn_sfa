import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/sale_order/controller/business_opportunity_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/sale_order/controller/so_create_controller.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart'
    show ResponsiveButton;
import 'package:trina_grid/trina_grid.dart';

class BusinessTrackingScreen extends StatefulWidget {
  final CreateSoController controller;
  const BusinessTrackingScreen({super.key, required this.controller});

  @override
  State<BusinessTrackingScreen> createState() => _BusinessTrackingScreenState();
}

class _BusinessTrackingScreenState extends State<BusinessTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final bOcontroller = Get.put(
      BusinessTrackingController(
        widget.controller.salesOrderHeaderEntity.value!,
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Business Tracking'),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (bOcontroller.isLoading.value) {
                return Center(child: Utility.processLoadingWidget());
              }

              if (bOcontroller.salesOrderValue.isEmpty) {
                return const Center(child: NoDataFound());
              }
              return trinaCustomTheme(
                iscolumnsize: false,
                isPagination: false,
                configuration: const TrinaGridConfiguration(),
                rowHeight: 30,
                columnHeight: 40,
                context: context,
                select: TrinaGridMode.select,
                columns: [
                  gridColumnRpt(
                    field: 'check',
                    title: '',
                    enableRowChecked: true,
                    width: size.width * 0.05,
                  ),
                  gridColumnRpt(
                    field: 'item_code',
                    title: 'Item Id',
                    width: size.width * 0.1,
                  ),
                  gridColumnRpt(
                    field: 'item_name',
                    title: 'Item Name',
                    width: size.width * 0.5,
                  ),
                  gridColumnRpt(
                    field: 'qty',
                    title: 'Qty',
                    width: size.width * 0.07,
                    istext: false,
                  ),
                  gridColumnRpt(
                    field: 'rate',
                    title: 'Rate',
                    width: size.width * 0.07,
                    istext: false,
                    iscurrency: true,
                  ),
                  gridColumnRpt(
                    field: 'value',
                    title: 'Total Value',
                    width: size.width * 0.07,
                    istext: false,
                    iscurrency: true,
                  ),
                  gridColumnRpt(
                    field: 'business',
                    title: 'Business Oppourtunity',
                    width: size.width * 0.1,
                    hide: true,
                  ),
                ].obs,
                rows: bOcontroller.trinaRows,
                onLoaded: (event) {
                  bOcontroller.stateManager = event.stateManager;
                },
                onRowChecked: (event) {
                  final row = event.row;
                  if (row == null) return;

                  final id = row.cells['business']?.value;

                  final item = bOcontroller.salesOrderValue.firstWhere(
                    (e) => e.businessOpportunityId == id,
                  );

                  if (event.isChecked == true) {
                    bOcontroller.addToSelected(item);
                  } else {
                    bOcontroller.removeSelected(item);
                  }
                },
              );
            }),
          ),
          Container(
            width: size.width * 0.6,
            padding: const EdgeInsets.all(4),
            child: ResponsiveButton(
              title: 'Save',
              function: () async {
                await bOcontroller.save();
                widget.controller.loadSalesOrderForEdit();
              },
            ),
          ),
        ],
      ),
    );
  }
}
