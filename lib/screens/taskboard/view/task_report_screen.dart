import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
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

class TaskReport extends StatelessWidget {
  TaskReport({super.key});

  final TaskController controller = _initController();

  static TaskController _initController() {
    if (Get.isRegistered<TaskController>()) {
      Get.delete<TaskController>(force: true);
    }
    // showAll defaults to false via Get.arguments in onInit
    return Get.put(TaskController());
  }

  final SalesTaskEditController salesEditController = _initSalesController();
  static SalesTaskEditController _initSalesController() {
    if (!Get.isRegistered<SalesTaskEditController>()) {
      return Get.put(SalesTaskEditController());
    }
    return Get.find<SalesTaskEditController>();
  }

  final SupportTaskEditController supportEditController =
      _initSupportController();
  static SupportTaskEditController _initSupportController() {
    if (!Get.isRegistered<SupportTaskEditController>()) {
      return Get.put(SupportTaskEditController());
    }
    return Get.find<SupportTaskEditController>();
  }

  // ── Status config ──
  static const List<String> _labels = [
    'Pending',
    'In Progress',
    'Completed',
    'On Hold',
    'Cancelled',
    'FTC',
  ];

  static const List<Color> _colors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.grey,
    Colors.red,
    Colors.purple,
  ];

  String _statusLabel(String? value) {
    final i = int.tryParse(value ?? '') ?? 0;
    return (i >= 0 && i < _labels.length) ? _labels[i] : '';
  }

  Color _statusColor(String? value) {
    final i = int.tryParse(value ?? '') ?? 0;
    return (i >= 0 && i < _colors.length) ? _colors[i] : Colors.grey;
  }

  bool isToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;
    try {
      final d = DateTime.parse(createdAt);
      final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    } catch (_) {
      return false;
    }
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search by customer name...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (text) {
        if (text.isEmpty) {
          controller.isSearch.value = false;
          controller.onSearchTextChanged('');
        } else {
          controller.isSearch.value = true;
          controller.onSearchTextChanged(text);
        }
      },
    );
  }

  List<Widget> _buildActions() {
    if (controller.isSearch.value) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: controller.clearSearch,
        ),
      ];
    }
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => controller.isSearch.value = true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageList.appbarImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Obx(
          () => controller.isSearch.value
              ? _buildSearchField()
              : Text(
                  controller.screenType == "support"
                      ? "Support Task"
                      : "Sales Task",
                ),
        ),
        actions: [Obx(() => Row(children: _buildActions()))],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
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
                        } else {
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
      floatingActionButton: FloatingButton(
        isExtended: false,

        icon: Icon(Icons.add),
        function: () async {
          if (controller.screenType == "support") {
            supportEditController.clearFields();
            // Get.dialog(SupportTaskCreateDialog(size));
            Get.to(() => SupportTaskCreateDialog(size));
          } else if (controller.screenType == "sales") {
            salesEditController.clearFields();
            // Get.dialog(SalesTaskCreateDialog(size));
            Get.to(() => SalesTaskCreateDialog(size));
          } else {
            Utility.showAlert(
              icons: Icons.error_outline_outlined,
              iconcolor: Colors.redAccent,
              title: 'Alert',
              msg: "Oops there is an error!",
            );
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            /// ── ADD BUTTON ──
            // MakeEntryButton(
            //   title: 'Add',
            //   onTap: () async {
            //     if (controller.screenType == "support") {
            //       supportEditController.clearFields();
            //       Get.dialog(SupportTaskCreateDialog(size));
            //     } else if (controller.screenType == "sales") {
            //       salesEditController.clearFields();
            //       Get.dialog(SalesTaskCreateDialog(size));
            //     } else {
            //       Utility.showAlert(
            //         icons: Icons.error_outline_outlined,
            //         iconcolor: Colors.redAccent,
            //         title: 'Alert',
            //         msg: "Oops there is an error!",
            //       );
            //     }
            //   },
            // ),
            /// ── CUSTOMER SEARCH DROPDOWN ──
            /// ── SEARCH BAR ──
            // SearchFilterBar(
            //   allRows: controller.rows,
            //   filteredRows: controller.filteredRows,
            //   selectStatus: controller.selectStatus,
            //   searchColumns: const [
            //     SearchColumn(label: 'Customer Name', fieldKey: 'customer_name'),
            //     SearchColumn(label: 'Assigned User', fieldKey: 'assigned_to'),
            //     SearchColumn(label: 'Task ID',       fieldKey: 'privateid'),
            //     SearchColumn(label: 'Title',         fieldKey: 'title'),
            //     SearchColumn(label: 'Event',         fieldKey: 'event_name'),
            //   ],
            // ),
            // UniversalSearchFilterBar<TrinaRow>(
            //   allData: controller.rows,
            //   filteredData: controller.filteredRows,
            //   valueExtractor: (row, fieldKey) =>
            //       row.cells[fieldKey]?.value?.toString() ?? '',
            //   baseFilter: (row) {
            //     final statusIndex = int.tryParse(controller.selectStatus.value);
            //     if (statusIndex == null ||
            //         controller.selectStatus.value.isEmpty) {
            //       return true;
            //     }
            //     final cellValue = row.cells['status']?.value;
            //     if (cellValue is int) return cellValue == statusIndex;
            //     return int.tryParse(cellValue?.toString() ?? '') == statusIndex;
            //   },
            //   searchColumns: const [
            //     SearchColumn(label: 'Customer Name', fieldKey: 'customer_name'),
            //     SearchColumn(label: 'Assigned User', fieldKey: 'assigned_to'),
            //     SearchColumn(label: 'Task ID', fieldKey: 'privateid'),
            //     SearchColumn(label: 'Title', fieldKey: 'title'),
            //     SearchColumn(label: 'Event', fieldKey: 'event_name'),
            //   ],
            // ),

            /// ── STATUS SUMMARY CARDS ──
            IntrinsicHeight(
              child: Obx(() {
                return Align(
                  alignment: Alignment.centerLeft,
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
                              padding: const EdgeInsets.all(4),
                              child: _buildSummaryCard(
                                index,
                                count,
                                _labels[index],
                                _colors[index],
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

            /// ── LIST ──
            Expanded(
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator()
                        : const CircularProgressIndicator(),
                  );
                }

                if (controller.filteredRows.isEmpty) {
                  return const Center(child: NoDataFound());
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.filteredRows.length,
                  itemBuilder: (context, i) {
                    final cells = controller.filteredRows[i].cells;

                    final id = cells['id']?.value?.toString() ?? '';
                    final privateId =
                        cells['privateid']?.value?.toString() ?? '';
                    final customerName =
                        cells['customer_name']?.value?.toString() ?? '';
                    final assignedTo =
                        cells['assigned_to']?.value?.toString() ?? '';
                    final statusValue =
                        cells['status']?.value?.toString() ?? '0';
                    final todoDate = cells['tododate']?.value?.toString() ?? '';
                    final dueDate = cells['duedate']?.value?.toString() ?? '';
                    final title = cells['title']?.value?.toString() ?? '';
                    final description =
                        cells['description']?.value?.toString() ?? '';
                    final eventName =
                        cells['event_name']?.value?.toString() ?? '';
                    final createdAt =
                        cells['created_at']?.value?.toString() ?? '';
                    final updatedAt =
                        cells['updated_at']?.value?.toString() ?? '';

                    final statusLabel = _statusLabel(statusValue);
                    final statusColor = _statusColor(statusValue);

                    final rowData = cells.map(
                      (key, cell) => MapEntry(key, cell.value ?? ''),
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          try {
                            if (controller.screenType == "support") {
                              await Get.find<SupportTaskEditController>()
                                  .loadTaskForEdit(rowData);
                            } else {
                              await Get.find<SalesTaskEditController>()
                                  .loadTaskForEdit(rowData);
                            }
                            Get.to(() => SupportTaskView());
                            // .then((_) {
                            //   controller.stateManager = null;
                            //   if (controller.screenType == "support") {
                            //     controller.getSupportTaskData();
                            //   } else {
                            //     controller.getSalesTaskData();
                            //   }
                            // });
                          } catch (e) {
                            Get.snackbar("Error", e.toString());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ── ROW 1: Title + Status badge ──
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title.isNotEmpty ? title : '—',
                                      style: kTxtStl13B,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: statusColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              /// ── ROW 2: Task ID + Customer ──
                              // _infoRow(
                              //   Icons.tag,
                              //   '$privateId  •  $customerName',
                              // ),
                              infoRow(
                                "Task Id",
                                privateId.toString(),
                                size: size.width * 0.25,
                              ),

                              // const SizedBox(height: 4),
                              infoRow(
                                "Customer Name",
                                customerName.toString(),
                                size: size.width * 0.25,
                              ),

                              // const SizedBox(height: 4),

                              /// ── ROW 3: Event ──
                              // if (eventName.isNotEmpty)
                              //   _infoRow(Icons.event, eventName),
                              infoRow(
                                "Event",
                                eventName.toString(),
                                size: size.width * 0.25,
                              ),

                              // const SizedBox(height: 4),

                              /// ── ROW 4: Assigned To ──
                              // _infoRow(Icons.person_outline, assignedTo),
                              infoRow(
                                "Assigned User",
                                assignedTo.toString(),
                                size: size.width * 0.25,
                              ),

                              // const SizedBox(height: 4),
                              infoRow(
                                "Todo Date",
                                todoDate.toString(),
                                size: size.width * 0.25,
                              ),

                              // const SizedBox(height: 4),
                              infoRow(
                                "Due Date",
                                dueDate.toString(),
                                size: size.width * 0.25,
                              ),

                              /// ── ROW 5: Dates ──
                              // Row(
                              //   children: [
                              //     _infoChip(
                              //       Icons.calendar_today,
                              //       'Todo: $todoDate',
                              //     ),
                              //     const SizedBox(width: 10),
                              //     _infoChip(
                              //       Icons.event_available,
                              //       'Due: $dueDate',
                              //     ),
                              //   ],
                              // ),

                              // if (description.isNotEmpty) ...[
                              //   const SizedBox(height: 6),
                              //   Text(
                              //     description,
                              //     style: const TextStyle(
                              //       fontSize: 12,
                              //       color: Colors.black54,
                              //     ),
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ],

                              // const Divider(height: 14),

                              /// ── ROW 6: Actions ──
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     /// EDIT
                              //     _actionButton(
                              //       icon: Icons.edit,
                              //       label: 'Edit',
                              //       color: Colors.blue,
                              //       onTap: () {
                              //         if (controller.screenType == "support") {
                              //           Get.dialog(
                              //             SupportTaskCreateDialog(
                              //               size,
                              //               rowData: rowData,
                              //             ),
                              //           );
                              //         } else {
                              //           Get.dialog(
                              //             SalesTaskCreateDialog(
                              //               size,
                              //               rowData: rowData,
                              //             ),
                              //           );
                              //         }
                              //       },
                              //     ),

                              //     const SizedBox(width: 8),

                              //     /// DELETE (today only)
                              //     if (isToday(createdAt))
                              //       _actionButton(
                              //         icon: Icons.delete,
                              //         label: 'Delete',
                              //         color: Colors.red,
                              //         onTap: () {
                              //           Utility.showAlertYesNo(
                              //             iconData:
                              //                 Icons.warning_amber_rounded,
                              //             iconcolor: Colors.red,
                              //             title: "Delete Item",
                              //             msg:
                              //                 "Are you sure you want to delete?",
                              //             yesBtnFun: () async {
                              //               if (controller.screenType ==
                              //                   "support") {
                              //                 await controller
                              //                     .deleteSupportTaskApi(
                              //                       supportTaskId: id,
                              //                     );
                              //               } else {
                              //                 await controller
                              //                     .deleteSalesTaskApi(
                              //                       salesTaskId: id,
                              //                     );
                              //               }
                              //             },
                              //           );
                              //         },
                              //       ),
                              //   ],
                              // ),
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
      ),
    );
  }

  Widget infoRow(String title, String value, {double? size}) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        children: [
          SizedBox(
            width: size,
            child: Text(title, style: kTxtStl13N),
          ),
          Text(': ', style: kTxtStl13GreyN),
          Expanded(
            child: Text(
              value,
              style: kTxtStl13N,
              // textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int index, String count, String label, Color color) {
    const double width = 100;
    return Obx(
      () => InkWell(
        onTap: () => controller.filterByStatus(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          decoration: BoxDecoration(
            color: controller.selectStatus.value == index.toString()
                ? color.withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: controller.selectStatus.value == index.toString()
                  ? color
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
// import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
// import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';
// import 'package:sysconn_sfa/screens/taskboard/view/sales_task_create.dart';
// import 'package:sysconn_sfa/screens/taskboard/view/support_task_create.dart';
// import 'package:sysconn_sfa/screens/taskboard/view/task_view_screen.dart';
// import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
// import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
// import 'package:sysconn_sfa/widgetscustome/custom_popup_list_Item.dart';
// import 'package:sysconn_sfa/widgetscustome/entry_button.dart';
// import 'package:trina_grid/trina_grid.dart';

// class TaskReport extends StatelessWidget {
//   TaskReport({super.key});

//   final TaskController controller = Get.find<TaskController>();

//   //Register SalesTaskEditController when TaskReport is created
//   final SalesTaskEditController salesEditController = _initSalesController();

//   static SalesTaskEditController _initSalesController() {
//     if (!Get.isRegistered<SalesTaskEditController>()) {
//       return Get.put(SalesTaskEditController());
//     }
//     return Get.find<SalesTaskEditController>();
//   }

//   //Register SupportTaskEditController when TaskReport is created
//   final SupportTaskEditController supportEditController =
//       _initSupportController();

//   static SupportTaskEditController _initSupportController() {
//     if (!Get.isRegistered<SupportTaskEditController>()) {
//       return Get.put(SupportTaskEditController());
//     }
//     return Get.find<SupportTaskEditController>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: SfaCustomAppbar(
//         title: controller.screenType == "support"
//             ? "Support Task"
//             : "Sales Task",
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Obx(
//                     () => CalendarSingleView(
//                       fromDate: controller.fromDate.value,
//                       toDate: controller.toDate.value,
//                       function: () async {
//                         await selectDateRange(
//                           controller.fromDate.value,
//                           controller.toDate.value,
//                         ).then((dateTimeRange) {
//                           controller.fromDate.value = dateTimeRange.start;
//                           controller.toDate.value = dateTimeRange.end;
//                         });
//                         if (controller.screenType == "support") {
//                           controller.getSupportTaskData();
//                         } else if (controller.screenType == "sales") {
//                           controller.getSalesTaskData();
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: size.height * 0.01),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           MakeEntryButton(
//             title: 'Add',
//             onTap: () async {
//               if (controller.screenType == "support") {
//                 supportEditController.clearFields();
//                 Get.dialog(SupportTaskCreateDialog(size));
//               } else if (controller.screenType == "sales") {
//                 salesEditController.clearFields();
//                 Get.dialog(SalesTaskCreateDialog(size));
//               } else {
//                 Utility.showAlert(
//                   icons: Icons.error_outline_outlined,
//                   iconcolor: Colors.redAccent,
//                   title: 'Alert',
//                   msg: "Oops there is an error!",
//                 );
//               }
//               // support will be added later
//             },
//           ),
//           // SizedBox(
//           //   height: 100,
//           IntrinsicHeight(
//             child: Obx(() {
//               final labels = [
//                 'Pending',  
//                 'In Progress',
//                 'Completed',
//                 'On Hold',
//                 'Cancelled',
//                 'FTC',
//               ];

//               return Align(
//                 alignment: Alignment.centerLeft, // Left align the Card
//                 child: Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: List.generate(6, (index) {
//                           final count = controller.statusCounts[index]
//                               .toString();
//                           return Padding(
//                             // padding: const EdgeInsets.only(right: 8),
//                             padding: const EdgeInsets.all(4),

//                             child: _buildSummaryCard(
//                               index,
//                               count,
//                               labels[index],
//                               controller,
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           // const SizedBox(height: 8),
//           //----------------------------
//           Expanded(
//             child: Obx(() {
//               if (controller.isDataLoad.value == 0) {
//                 return Center(
//                   child: Platform.isIOS
//                       ? CupertinoActivityIndicator()
//                       : CircularProgressIndicator(),
//                 );
//               } else if (controller.filteredRows.isEmpty) {
//                 return Center(child: const NoDataFound());
//               } else {
//                 return trinaCustomTheme(
//                   key: ValueKey('grid_${controller.selectStatus.value}'),
//                   context: context,
//                   select: TrinaGridMode.select,
//                   iscolumnsize: true,
//                   columns: [
//                     gridColumnRpt(
//                       field: 'action',
//                       title: 'Action',
//                       isstartcolumn: true,
//                       // width: 120,
//                       renderer: (rendererContext) {
//                         return Padding(
//                           padding: const EdgeInsets.all(4),
//                           child: CustomPopupMenuButton(
//                             screenSize: size,
//                             menuItems: [
//                               PopupMenuItemModel(
//                                 value: 'view',
//                                 icon: Icons.remove_red_eye,
//                                 title: 'View',
//                                 onTap: () async {
//                                   try {
//                                     final rowData = rendererContext.row.cells
//                                         .map(
//                                           (key, cell) =>
//                                               MapEntry(key, cell.value ?? ''),
//                                         );

//                                     if (controller.screenType == "support") {
//                                       final controllerview =
//                                           Get.find<SupportTaskEditController>();
//                                       await controllerview.loadTaskForEdit(
//                                         rowData,
//                                       );
//                                     } else {
//                                       final controllerview =
//                                           Get.find<SalesTaskEditController>();
//                                       await controllerview.loadTaskForEdit(
//                                         rowData,
//                                       );
//                                     }

//                                     /// SAME VIEW FOR BOTH
//                                     Get.to(() => SupportTaskView());
//                                   } catch (e, st) {
//                                     debugPrint("ERROR: $e\n$st");

//                                     Get.snackbar(
//                                       "Error",
//                                       e.toString(),
//                                       duration: const Duration(seconds: 5),
//                                     );
//                                   }
//                                 },
//                               ),
//                               PopupMenuItemModel(
//                                 value: 'edit',
//                                 icon: Icons.edit,
//                                 title: 'Edit',
//                                 onTap: () async {
//                                   try {
//                                     if (controller.screenType == "support") {
//                                       final rowData = rendererContext.row.cells
//                                           .map(
//                                             (key, cell) =>
//                                                 MapEntry(key, cell.value),
//                                           );

//                                       Get.dialog(
//                                         SupportTaskCreateDialog(
//                                           size,
//                                           rowData: rowData,
//                                         ),
//                                       );
//                                     } else if (controller.screenType ==
//                                         "sales") {
//                                       final rowData = rendererContext.row.cells
//                                           .map(
//                                             (key, cell) =>
//                                                 MapEntry(key, cell.value),
//                                           );

//                                       Get.dialog(
//                                         SalesTaskCreateDialog(
//                                           size,
//                                           rowData: rowData,
//                                         ),
//                                       );
//                                     }
//                                   } catch (e, st) {
//                                     debugPrint(
//                                       "Error loading task for edit: $e\n$st",
//                                     );
//                                     Get.snackbar(
//                                       "Error",
//                                       "Failed to load task for edit",
//                                     );
//                                   }
//                                 },
//                               ),
//                               if (isToday(
//                                 rendererContext.row.cells['created_at']?.value
//                                     ?.toString(),
//                               ))
//                                 PopupMenuItemModel(
//                                   value: 'delete',
//                                   icon: Icons.delete,
//                                   title: 'Delete',
//                                   onTap: () async {
//                                     await Future.delayed(
//                                       const Duration(milliseconds: 100),
//                                     );

//                                     final rowData = rendererContext.row.cells
//                                         .map(
//                                           (key, cell) =>
//                                               MapEntry(key, cell.value),
//                                         );

//                                     Utility.showAlertYesNo(
//                                       // Get.context!,
//                                       iconData: Icons.warning_amber_rounded,
//                                       iconcolor: Colors.red,
//                                       title: "Delete Item",
//                                       msg: "Are you sure you want to delete",
//                                       yesBtnFun: () async {
//                                         if (controller.screenType ==
//                                             "support") {
//                                           await controller.deleteSupportTaskApi(
//                                             supportTaskId:
//                                                 rowData['id']?.toString() ?? '',
//                                           );
//                                         } else if (controller.screenType ==
//                                             "sales") {
//                                           await controller.deleteSalesTaskApi(
//                                             salesTaskId:
//                                                 rowData['id']?.toString() ?? '',
//                                           );
//                                         }
//                                       },
//                                       // noBtnFun: () {
//                                       //   Get.back();
//                                       // },
//                                     );
//                                   },
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     gridColumnRpt(
//                       field: 'id', //its autogenerate for table
//                       title: 'ID',
//                       // width: size.width * 0.1,
//                       hide: true,
//                     ),
//                     gridColumnRpt(
//                       //added for only show as per ustomer id generte
//                       field: 'privateid',
//                       title: 'Task ID',
//                       // width: size.width * 0.1,
//                     ),
//                     gridColumnRpt(
//                       field: 'customer_name',
//                       title: 'Customer Name',
//                       // width: size.width * 0.15,
//                     ),
//                     gridColumnRpt(
//                       field: 'customer_id',
//                       title: 'CUSTOMER ID',
//                       // width: size.width * 0.15,
//                       hide: true,
//                     ),

//                     gridColumnRpt(
//                       field: 'assigned_to',
//                       title: 'Assigned User',
//                       // width: size.width * 0.1,
//                     ),
//                     gridColumnRpt(
//                       field: 'assigned_to_id',
//                       title: 'ASSIGNED USER EMAIL',
//                       // width: size.width * 0.1,
//                       hide: true,
//                     ),
//                     // gridColumnRpt(
//                     //   field: 'status',
//                     //   title: 'Status',
//                     //   width: 135,
//                     // ),
//                     gridColumnRpt(
//                       field: 'status',
//                       title: 'Status',
//                       // width: 135,
//                       renderer: (rendererContext) {
//                         final cells = rendererContext.row.cells;
//                         final statusValue =
//                             cells['status']?.value?.toString() ?? '0';

//                         // Map numeric status to label
//                         const labels = [
//                           'Pending',
//                           'In Progress',
//                           'Completed',
//                           'On Hold',
//                           'Cancelled',
//                           'FTC',
//                         ];

//                         // Map numeric status to colors
//                         const colors = [
//                           Colors.orange, // Pending
//                           Colors.blue, // In Progress
//                           Colors.green, // Completed
//                           Colors.grey, // On Hold
//                           Colors.red, // Cancelled
//                           Colors.purple, // FTC
//                         ];

//                         int index = int.tryParse(statusValue) ?? 0;
//                         if (index < 0 || index >= labels.length) index = 0;

//                         final label = labels[index];
//                         final color = colors[index];

//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: color.withOpacity(0.15), // light background
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(color: color, width: 1),
//                           ),
//                           child: Text(
//                             label,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     gridColumnRpt(
//                       field: 'tododate',
//                       title: 'ToDo Date',
//                       // width: 135,
//                     ),
//                     gridColumnRpt(
//                       field: 'duedate',
//                       title: 'Due Date',
//                       // width: 135,
//                     ),
//                     gridColumnRpt(
//                       field: 'title',
//                       title: 'Title',
//                       // width: size.width * 0.1,
//                     ),
//                     gridColumnRpt(
//                       field: 'description',
//                       title: 'Description',
//                       // width: 135,
//                     ),
//                     gridColumnRpt(
//                       field: 'event_name',
//                       title: 'Event Name',
//                       // width: size.width * 0.15,
//                     ),
//                     gridColumnRpt(
//                       field: 'event_id',
//                       title: 'EVENT ID',
//                       // width: size.width * 0.15,
//                       hide: true,
//                     ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'query_category_id',
//                         title: 'QUERY CATEGORY ID',
//                         // width: 135,
//                         hide: true,
//                       ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'query_category_name',
//                         title: 'Query',
//                         // width: 135,
//                       ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'subquery_category_id',
//                         title: 'SUBQUERY CATEGORY ID',
//                         // width: 135,
//                         hide: true,
//                       ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'subquery_category_name',
//                         title: 'Subquery',
//                         // width: 135,
//                       ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'ownership_category_id',
//                         title: 'OWNERSHIP CATEGORY ID',
//                         // width: 135,
//                         hide: true,
//                       ),
//                     if (controller.screenType == "support")
//                       gridColumnRpt(
//                         field: 'ownership_category_name',
//                         title: 'Pending Ownership',
//                         // width: 135,
//                       ),

//                     //-------------------------------------------------
//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'source',
//                         title: 'Source',
//                         // width: 135,
//                       ),

//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'business_opportunity_id',
//                         title: 'Business Opportunity ID',
//                         hide: true,
//                         // width: 135,
//                       ),

//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'business_opportunity_name',
//                         title: 'Business Opportunity',
//                         // width: 135,
//                       ),

//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'division_category',
//                         title: 'Division Category',
//                         // width: 135,
//                       ),
//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'target_category_id',
//                         title: 'Target Category ID',
//                         hide: true,
//                         // width: 135,
//                       ),
//                     if (controller.screenType != "support")
//                       gridColumnRpt(
//                         field: 'target_categoty_name',
//                         title: 'Target Category',
//                         // width: 135,
//                       ),
//                     gridColumnRpt(
//                       field: 'rating',
//                       title: 'Rating',
//                       // width: 135,
//                       hide: true,
//                     ),
//                     gridColumnRpt(
//                       field: 'created_at',
//                       title: 'Creted At',
//                       // width: 135,
//                     ),
//                     gridColumnRpt(
//                       field: 'updated_at',
//                       title: 'Updated At',
//                       // width: 135,
//                     ),
//                   ].obs,
//                   // rows: controller.rows,
//                   rows: controller.filteredRows,
//                   onLoaded: (event) {
//                     controller.stateManager = event.stateManager;
//                   },
//                 );
//               }
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   bool isToday(String? createdAt) {
//     if (createdAt == null || createdAt.isEmpty) return false;

//     try {
//       final createdDate = DateTime.parse(createdAt);
//       final now = DateTime.now();

//       return createdDate.year == now.year &&
//           createdDate.month == now.month &&
//           createdDate.day == now.day;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Widget _buildSummaryCard(
//   //   int index,
//   //   String count,
//   //   String label,
//   //   TaskController controller,
//   // ) {
//   //   double width = 120; //180

//   //   return Obx(
//   //     () => InkWell(
//   //       onTap: () {
//   //         controller.filterByStatus(index);
//   //       },
//   //       child: AnimatedContainer(
//   //         duration: const Duration(milliseconds: 200),
//   //         width: width,
//   //         decoration: BoxDecoration(
//   //           color: controller.selectStatus.value == index.toString()
//   //               ? Colors.black.withOpacity(0.1)
//   //               : Colors.white,
//   //           borderRadius: BorderRadius.circular(4),
//   //           border: Border.all(
//   //             color: controller.selectStatus.value == index.toString()
//   //                 ? Colors.black
//   //                 : Colors.grey.shade300,
//   //           ),
//   //         ),
//   //         padding: const EdgeInsets.all(10),
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             Text(
//   //               count,
//   //               style: const TextStyle(
//   //                 fontSize: 20,
//   //                 // fontWeight: FontWeight.w500,
//   //                 // color: Colors.black,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: Colors.black,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 2),
//   //             Row(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 const Icon(
//   //                   Icons.grid_view_rounded,
//   //                   size: 13,
//   //                   color: Colors.black,
//   //                 ),
//   //                 const SizedBox(width: 4),
//   //                 Text(
//   //                   label,
//   //                   style: const TextStyle(
//   //                     fontSize: 13,
//   //                     fontWeight: FontWeight.normal,
//   //                     color: Colors.black,
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildSummaryCard(
//     int index,
//     String count,
//     String label,
//     TaskController controller,
//   ) {
//     const double width = 120;
//     // final double width = (MediaQuery.of(Get.context!).size.width - 40) / 3;

//     return Obx(
//       () => InkWell(
//         onTap: () => controller.filterByStatus(index),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           width: width,
//           //  No fixed height — grows with content
//           decoration: BoxDecoration(
//             color: controller.selectStatus.value == index.toString()
//                 ? Colors.black.withOpacity(0.1)
//                 : Colors.white,
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(
//               color: controller.selectStatus.value == index.toString()
//                   ? Colors.black
//                   : Colors.grey.shade300,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, //  shrink to content
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FittedBox(
//                 fit: BoxFit.scaleDown, // shrinks count if too large
//                 child: Text(
//                   count,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.grid_view_rounded,
//                     size: 12,
//                     color: Colors.black,
//                   ),
//                   const SizedBox(width: 3),
//                   Flexible(
//                     // ✅ allows label to wrap if needed
//                     child: Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.black,
//                       ),
//                       overflow: TextOverflow.ellipsis, // ✅ no overflow
//                       maxLines: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
