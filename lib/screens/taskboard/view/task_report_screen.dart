import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/view/sales_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/support_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/task_view_screen.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:sysconn_sfa/widgetscustome/custom_popup_list_Item.dart';
import 'package:sysconn_sfa/widgetscustome/entry_button.dart';
import 'package:trina_grid/trina_grid.dart';

class TaskReport extends StatelessWidget {
  TaskReport({super.key});

  final TaskController controller = Get.find<TaskController>();

  //Register SalesTaskEditController when TaskReport is created
  final SalesTaskEditController salesEditController = _initSalesController();

  static SalesTaskEditController _initSalesController() {
    if (!Get.isRegistered<SalesTaskEditController>()) {
      return Get.put(SalesTaskEditController());
    }
    return Get.find<SalesTaskEditController>();
  }

  //Register SupportTaskEditController when TaskReport is created
  final SupportTaskEditController supportEditController =
      _initSupportController();

  static SupportTaskEditController _initSupportController() {
    if (!Get.isRegistered<SupportTaskEditController>()) {
      return Get.put(SupportTaskEditController());
    }
    return Get.find<SupportTaskEditController>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: controller.screenType == "support"
            ? "Support Task"
            : "Sales Task",
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        if (controller.screenType == "support") {
                          controller.getSupportTaskData();
                        } else if (controller.screenType == "sales") {
                          controller.getSalesTaskData();
                        }
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
          MakeEntryButton(
            title: 'Add',
            onTap: () async {
              if (controller.screenType == "support") {
                supportEditController.clearFields();
                Get.dialog(SupportTaskCreateDialog(size));
              } else if (controller.screenType == "sales") {
                salesEditController.clearFields();
                Get.dialog(SalesTaskCreateDialog(size));
              } else {
                Utility.showAlert(
                  icons: Icons.error_outline_outlined,
                  iconcolor: Colors.redAccent,
                  title: 'Alert',
                  msg: "Oops there is an error!",
                );
              }
              // support will be added later
            },
          ),
          // SizedBox(
          //   height: 100,
          IntrinsicHeight(
            child: Obx(() {
              final labels = [
                'Pending',  
                'In Progress',
                'Completed',
                'On Hold',
                'Cancelled',
                'FTC',
              ];

              return Align(
                alignment: Alignment.centerLeft, // Left align the Card
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(6, (index) {
                          final count = controller.statusCounts[index]
                              .toString();
                          return Padding(
                            // padding: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(4),

                            child: _buildSummaryCard(
                              index,
                              count,
                              labels[index],
                              controller,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          // const SizedBox(height: 8),
          //----------------------------
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                );
              } else if (controller.filteredRows.isEmpty) {
                return Center(child: const NoDataFound());
              } else {
                return trinaCustomTheme(
                  key: ValueKey('grid_${controller.selectStatus.value}'),
                  context: context,
                  select: TrinaGridMode.select,
                  iscolumnsize: true,
                  columns: [
                    gridColumnRpt(
                      field: 'action',
                      title: 'Action',
                      isstartcolumn: true,
                      // width: 120,
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: CustomPopupMenuButton(
                            screenSize: size,
                            menuItems: [
                              PopupMenuItemModel(
                                value: 'view',
                                icon: Icons.remove_red_eye,
                                title: 'View',
                                onTap: () async {
                                  try {
                                    final rowData = rendererContext.row.cells
                                        .map(
                                          (key, cell) =>
                                              MapEntry(key, cell.value ?? ''),
                                        );

                                    if (controller.screenType == "support") {
                                      final controllerview =
                                          Get.find<SupportTaskEditController>();
                                      await controllerview.loadTaskForEdit(
                                        rowData,
                                      );
                                    } else {
                                      final controllerview =
                                          Get.find<SalesTaskEditController>();
                                      await controllerview.loadTaskForEdit(
                                        rowData,
                                      );
                                    }

                                    /// SAME VIEW FOR BOTH
                                    Get.to(() => SupportTaskView());
                                  } catch (e, st) {
                                    debugPrint("ERROR: $e\n$st");

                                    Get.snackbar(
                                      "Error",
                                      e.toString(),
                                      duration: const Duration(seconds: 5),
                                    );
                                  }
                                },
                              ),
                              PopupMenuItemModel(
                                value: 'edit',
                                icon: Icons.edit,
                                title: 'Edit',
                                onTap: () async {
                                  try {
                                    if (controller.screenType == "support") {
                                      final rowData = rendererContext.row.cells
                                          .map(
                                            (key, cell) =>
                                                MapEntry(key, cell.value),
                                          );

                                      Get.dialog(
                                        SupportTaskCreateDialog(
                                          size,
                                          rowData: rowData,
                                        ),
                                      );
                                    } else if (controller.screenType ==
                                        "sales") {
                                      final rowData = rendererContext.row.cells
                                          .map(
                                            (key, cell) =>
                                                MapEntry(key, cell.value),
                                          );

                                      Get.dialog(
                                        SalesTaskCreateDialog(
                                          size,
                                          rowData: rowData,
                                        ),
                                      );
                                    }
                                  } catch (e, st) {
                                    debugPrint(
                                      "Error loading task for edit: $e\n$st",
                                    );
                                    Get.snackbar(
                                      "Error",
                                      "Failed to load task for edit",
                                    );
                                  }
                                },
                              ),
                              if (isToday(
                                rendererContext.row.cells['created_at']?.value
                                    ?.toString(),
                              ))
                                PopupMenuItemModel(
                                  value: 'delete',
                                  icon: Icons.delete,
                                  title: 'Delete',
                                  onTap: () async {
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );

                                    final rowData = rendererContext.row.cells
                                        .map(
                                          (key, cell) =>
                                              MapEntry(key, cell.value),
                                        );

                                    Utility.showAlertYesNo(
                                      // Get.context!,
                                      iconData: Icons.warning_amber_rounded,
                                      iconcolor: Colors.red,
                                      title: "Delete Item",
                                      msg: "Are you sure you want to delete",
                                      yesBtnFun: () async {
                                        if (controller.screenType ==
                                            "support") {
                                          await controller.deleteSupportTaskApi(
                                            supportTaskId:
                                                rowData['id']?.toString() ?? '',
                                          );
                                        } else if (controller.screenType ==
                                            "sales") {
                                          await controller.deleteSalesTaskApi(
                                            salesTaskId:
                                                rowData['id']?.toString() ?? '',
                                          );
                                        }
                                      },
                                      // noBtnFun: () {
                                      //   Get.back();
                                      // },
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    gridColumnRpt(
                      field: 'id', //its autogenerate for table
                      title: 'ID',
                      // width: size.width * 0.1,
                      hide: true,
                    ),
                    gridColumnRpt(
                      //added for only show as per ustomer id generte
                      field: 'privateid',
                      title: 'Task ID',
                      // width: size.width * 0.1,
                    ),
                    gridColumnRpt(
                      field: 'customer_name',
                      title: 'Customer Name',
                      // width: size.width * 0.15,
                    ),
                    gridColumnRpt(
                      field: 'customer_id',
                      title: 'CUSTOMER ID',
                      // width: size.width * 0.15,
                      hide: true,
                    ),

                    gridColumnRpt(
                      field: 'assigned_to',
                      title: 'Assigned User',
                      // width: size.width * 0.1,
                    ),
                    gridColumnRpt(
                      field: 'assigned_to_id',
                      title: 'ASSIGNED USER EMAIL',
                      // width: size.width * 0.1,
                      hide: true,
                    ),
                    // gridColumnRpt(
                    //   field: 'status',
                    //   title: 'Status',
                    //   width: 135,
                    // ),
                    gridColumnRpt(
                      field: 'status',
                      title: 'Status',
                      // width: 135,
                      renderer: (rendererContext) {
                        final cells = rendererContext.row.cells;
                        final statusValue =
                            cells['status']?.value?.toString() ?? '0';

                        // Map numeric status to label
                        const labels = [
                          'Pending',
                          'In Progress',
                          'Completed',
                          'On Hold',
                          'Cancelled',
                          'FTC',
                        ];

                        // Map numeric status to colors
                        const colors = [
                          Colors.orange, // Pending
                          Colors.blue, // In Progress
                          Colors.green, // Completed
                          Colors.grey, // On Hold
                          Colors.red, // Cancelled
                          Colors.purple, // FTC
                        ];

                        int index = int.tryParse(statusValue) ?? 0;
                        if (index < 0 || index >= labels.length) index = 0;

                        final label = labels[index];
                        final color = colors[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15), // light background
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: color, width: 1),
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    gridColumnRpt(
                      field: 'tododate',
                      title: 'ToDo Date',
                      // width: 135,
                    ),
                    gridColumnRpt(
                      field: 'duedate',
                      title: 'Due Date',
                      // width: 135,
                    ),
                    gridColumnRpt(
                      field: 'title',
                      title: 'Title',
                      // width: size.width * 0.1,
                    ),
                    gridColumnRpt(
                      field: 'description',
                      title: 'Description',
                      // width: 135,
                    ),
                    gridColumnRpt(
                      field: 'event_name',
                      title: 'Event Name',
                      // width: size.width * 0.15,
                    ),
                    gridColumnRpt(
                      field: 'event_id',
                      title: 'EVENT ID',
                      // width: size.width * 0.15,
                      hide: true,
                    ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'query_category_id',
                        title: 'QUERY CATEGORY ID',
                        // width: 135,
                        hide: true,
                      ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'query_category_name',
                        title: 'Query',
                        // width: 135,
                      ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'subquery_category_id',
                        title: 'SUBQUERY CATEGORY ID',
                        // width: 135,
                        hide: true,
                      ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'subquery_category_name',
                        title: 'Subquery',
                        // width: 135,
                      ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'ownership_category_id',
                        title: 'OWNERSHIP CATEGORY ID',
                        // width: 135,
                        hide: true,
                      ),
                    if (controller.screenType == "support")
                      gridColumnRpt(
                        field: 'ownership_category_name',
                        title: 'Pending Ownership',
                        // width: 135,
                      ),

                    //-------------------------------------------------
                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'source',
                        title: 'Source',
                        // width: 135,
                      ),

                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'business_opportunity_id',
                        title: 'Business Opportunity ID',
                        hide: true,
                        // width: 135,
                      ),

                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'business_opportunity_name',
                        title: 'Business Opportunity',
                        // width: 135,
                      ),

                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'division_category',
                        title: 'Division Category',
                        // width: 135,
                      ),
                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'target_category_id',
                        title: 'Target Category ID',
                        hide: true,
                        // width: 135,
                      ),
                    if (controller.screenType != "support")
                      gridColumnRpt(
                        field: 'target_categoty_name',
                        title: 'Target Category',
                        // width: 135,
                      ),
                    gridColumnRpt(
                      field: 'rating',
                      title: 'Rating',
                      // width: 135,
                      hide: true,
                    ),
                    gridColumnRpt(
                      field: 'created_at',
                      title: 'Creted At',
                      // width: 135,
                    ),
                    gridColumnRpt(
                      field: 'updated_at',
                      title: 'Updated At',
                      // width: 135,
                    ),
                  ].obs,
                  // rows: controller.rows,
                  rows: controller.filteredRows,
                  onLoaded: (event) {
                    controller.stateManager = event.stateManager;
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  bool isToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;

    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();

      return createdDate.year == now.year &&
          createdDate.month == now.month &&
          createdDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

  // Widget _buildSummaryCard(
  //   int index,
  //   String count,
  //   String label,
  //   TaskController controller,
  // ) {
  //   double width = 120; //180

  //   return Obx(
  //     () => InkWell(
  //       onTap: () {
  //         controller.filterByStatus(index);
  //       },
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 200),
  //         width: width,
  //         decoration: BoxDecoration(
  //           color: controller.selectStatus.value == index.toString()
  //               ? Colors.black.withOpacity(0.1)
  //               : Colors.white,
  //           borderRadius: BorderRadius.circular(4),
  //           border: Border.all(
  //             color: controller.selectStatus.value == index.toString()
  //                 ? Colors.black
  //                 : Colors.grey.shade300,
  //           ),
  //         ),
  //         padding: const EdgeInsets.all(10),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               count,
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 // fontWeight: FontWeight.w500,
  //                 // color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 2),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Icon(
  //                   Icons.grid_view_rounded,
  //                   size: 13,
  //                   color: Colors.black,
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   label,
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.normal,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSummaryCard(
    int index,
    String count,
    String label,
    TaskController controller,
  ) {
    const double width = 120;
    // final double width = (MediaQuery.of(Get.context!).size.width - 40) / 3;

    return Obx(
      () => InkWell(
        onTap: () => controller.filterByStatus(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          //  No fixed height — grows with content
          decoration: BoxDecoration(
            color: controller.selectStatus.value == index.toString()
                ? Colors.black.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: controller.selectStatus.value == index.toString()
                  ? Colors.black
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min, //  shrink to content
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown, // shrinks count if too large
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.grid_view_rounded,
                    size: 12,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    // ✅ allows label to wrap if needed
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis, // ✅ no overflow
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
