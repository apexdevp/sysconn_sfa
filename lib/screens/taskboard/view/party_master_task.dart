import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/view/sales_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/support_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/task_view_screen.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PartyMasterTask extends StatelessWidget {
  final String type;
  final String? partyid;
  final String? partyname;

  PartyMasterTask({
    super.key,
    required this.type,
    required this.partyid,
    required this.partyname,
  });

  late final TaskController controller = _init();

  final SalesTaskEditController salesEditController = _initSalesController();
  final SupportTaskEditController supportEditController =
      _initSupportController();

  static SalesTaskEditController _initSalesController() {
    if (!Get.isRegistered<SalesTaskEditController>()) {
      return Get.put(SalesTaskEditController());
    }
    return Get.find<SalesTaskEditController>();
  }

  static SupportTaskEditController _initSupportController() {
    if (!Get.isRegistered<SupportTaskEditController>()) {
      return Get.put(SupportTaskEditController());
    }
    return Get.find<SupportTaskEditController>();
  }

  TaskController _init() {
    if (Get.isRegistered<TaskController>()) {
      Get.delete<TaskController>(force: true);
    }
    Get.routing.args = {"type": type, "showAll": true}; // <-- uses passed type
    return Get.put(TaskController());
  }
  // final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // child: PartyLayout(
      //   key: UniqueKey(),
      //   enabledAppHeader: false,
      //   disabledHeaderTitle: false,
      //   header: ProfileHeader(),
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
      floatingActionButton: FloatingButton(
        isExtended: false,

        icon: Icon(Icons.add),
        function: () async {
          print("Customer ID: ${partyid ?? ''}");
          print("Customer Name: ${partyname ?? ''}");
          if (controller.screenType == "support") {
            supportEditController.editingRowData.value = {
              'customer_id': partyid ?? '',
              'customer_name': partyname ?? '',
            };
            // Get.dialog(SupportTaskCreateDialog(size, partyMasterTask: true));
            Get.to(() => SupportTaskCreateDialog(size, partyMasterTask: true));
          } else if (controller.screenType == "sales") {
            salesEditController.editingRowData.value = {
              'customer_id': partyid ?? '',
              'customer_name': partyname ?? '',
            };
            // Get.dialog(SalesTaskCreateDialog(size, partyMasterTask: true));
            Get.to(() => SalesTaskCreateDialog(size, partyMasterTask: true));
          }
        },
      ),

      // desktopBody: SingleChildScrollView(
      //   child:
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child:  Column(
        children: [
          // const CustomerLinksRow(active: "salestask"),
          // CustomerLinksRow(
          //   active: controller.screenType == "support"
          //       ? "supporttask"
          //       : "salestask",
          // ),
          // MakeEntryButton(
          //   title: 'Add',
          //   onTap: () async {
          //     // await contactController
          //     //     .showAddCustomerContactsDialog();
          //     print("Customer ID: ${partyid ?? ''}");
          //     print("Customer Name: ${partyname ?? ''}");
          //     if (controller.screenType == "support") {
          //       supportEditController.editingRowData.value = {
          //         'customer_id': partyid ?? '',
          //         'customer_name': partyname ?? '',
          //       };
          //       Get.dialog(SupportTaskCreateDialog(size, partyMasterTask: true));
          //     } else if (controller.screenType == "sales"){
          //       salesEditController.editingRowData.value = {
          //         'customer_id': partyid ?? '',
          //         'customer_name': partyname ?? '',
          //       };
          //       Get.dialog(SalesTaskCreateDialog(size, partyMasterTask: true));
          //     }
          //   },
          // ),
          // const Divider(height: 1, color: Colors.grey),
          // const SizedBox(height: 4),
          // Expanded(
          //   // height: 400,
          //   child: Obx(() {
          //     if (controller.isDataLoad.value == 0) {
          //       // return Center(
          //       //   child: Utility.processLoadingWidget(),
          //       // );
          //       return Center(child: LoadingIcon());
          //     } else if (controller.filteredRows.isEmpty) {
          //       return Center(child: const NoDataFound());
          //     } else {
          //       return trinaCustomTheme(
          //         context: context,
          //         select: TrinaGridMode.select,
          //         iscolumnsize: true,
          //         columns: [
          //           gridColumnRpt(
          //             field: 'action',
          //             title: 'Action',
          //             isstartcolumn: true,
          //             width: 120,
          //             renderer: (rendererContext) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(4),
          //                 child: CustomPopupMenuButton(
          //                   screenSize: size,
          //                   menuItems: [
          //                     PopupMenuItemModel(
          //                       value: 'view',
          //                       icon: Icons.remove_red_eye,
          //                       title: 'View',
          //                       onTap: () async {
          //                         try {
          //                           if (controller.screenType == "support") {
          //                             // Get or create controller
          //                             final controller = Get.put(
          //                               SupportTaskEditController(),
          //                             );

          //                             //  Extract row data
          //                             final rowData = rendererContext.row.cells
          //                                 .map(
          //                                   (key, cell) =>
          //                                       MapEntry(key, cell.value),
          //                                 );

          //                             //  Load task for edit safely
          //                             controller.loadTaskForEdit(rowData);

          //                             //  Open dialog after everything is set
          //                             Get.dialog(SupportTaskView());
          //                           } else {
          //                             final controller = Get.put(
          //                               SalesTaskEditController(),
          //                             );

          //                             //  Extract row data
          //                             final rowData = rendererContext.row.cells
          //                                 .map(
          //                                   (key, cell) =>
          //                                       MapEntry(key, cell.value),
          //                                 );

          //                             //  Load task for edit safely
          //                             controller.loadTaskForEdit(rowData);

          //                             //  Open dialog after everything is set
          //                             Get.dialog(SupportTaskView());
          //                           }
          //                         } catch (e, st) {
          //                           debugPrint(
          //                             "Error loading task for edit: $e\n$st",
          //                           );
          //                           Get.snackbar(
          //                             "Error",
          //                             "Failed to load task for edit",
          //                           );
          //                         }
          //                       },
          //                     ),
          //                     PopupMenuItemModel(
          //                       value: 'edit',
          //                       icon: Icons.edit,
          //                       title: 'Edit',
          //                       onTap: () async {
          //                         try {
          //                           if (controller.screenType == "support") {
          //                             // Get or create controller
          //                             final controller = Get.put(
          //                               SupportTaskEditController(),
          //                             );

          //                             //  Extract row data
          //                             final rowData = rendererContext.row.cells
          //                                 .map(
          //                                   (key, cell) =>
          //                                       MapEntry(key, cell.value),
          //                                 );

          //                             //  Load task for edit safely
          //                             controller.loadTaskForEdit(rowData);

          //                             //  Open dialog after everything is set
          //                             Get.dialog(
          //                               SupportTaskCreateDialog(
          //                                 size,
          //                                 rowData: rowData,
          //                               ),
          //                             );
          //                           } else {
          //                             // Get or create controller
          //                             final controller = Get.put(
          //                               SalesTaskEditController(),
          //                             );

          //                             //  Extract row data
          //                             final rowData = rendererContext.row.cells
          //                                 .map(
          //                                   (key, cell) =>
          //                                       MapEntry(key, cell.value),
          //                                 );

          //                             //  Load task for edit safely
          //                             controller.loadTaskForEdit(rowData);

          //                             //  Open dialog after everything is set
          //                             Get.dialog(
          //                               SalesTaskCreateDialog(
          //                                 size,
          //                                 rowData: rowData,
          //                               ),
          //                             );
          //                           }
          //                         } catch (e, st) {
          //                           debugPrint(
          //                             "Error loading task for edit: $e\n$st",
          //                           );
          //                           Get.snackbar(
          //                             "Error",
          //                             "Failed to load task for edit",
          //                           );
          //                         }
          //                       },
          //                     ),
          //                     if (isToday(
          //                       rendererContext.row.cells['created_at']?.value
          //                           ?.toString(),
          //                     ))
          //                       PopupMenuItemModel(
          //                         value: 'delete',
          //                         icon: Icons.delete,
          //                         title: 'Delete',
          //                         onTap: () async {
          //                           await Future.delayed(
          //                             const Duration(milliseconds: 100),
          //                           );

          //                           final rowData = rendererContext.row.cells
          //                               .map(
          //                                 (key, cell) =>
          //                                     MapEntry(key, cell.value),
          //                               );

          //                           Utility.showAlertYesNo(
          //                             // Get.context!,
          //                             iconData: Icons.warning_amber_rounded,
          //                             iconcolor: Colors.red,
          //                             title: "Delete Item",
          //                             msg: "Are you sure you want to delete",
          //                             yesBtnFun: () async {
          //                               if (controller.screenType ==
          //                                   "support") {
          //                                 await controller.deleteSupportTaskApi(
          //                                   supportTaskId:
          //                                       rowData['id']?.toString() ?? '',
          //                                 );
          //                               } else {
          //                                 await controller.deleteSalesTaskApi(
          //                                   salesTaskId:
          //                                       rowData['id']?.toString() ?? '',
          //                                 );
          //                               }
          //                             },
          //                             noBtnFun: () {
          //                               Get.back();
          //                             },
          //                           );
          //                         },
          //                       ),
          //                   ],
          //                 ),
          //               );
          //             },
          //           ),
          //           gridColumnRpt(
          //             field: 'id',
          //             title: 'ID',
          //             // width: size.width * 0.1,
          //             hide: true,
          //           ),
          //           gridColumnRpt(
          //             //added for only show as per ustomer id generte
          //             field: 'privateid',
          //             title: 'Task ID',
          //             // width: size.width * 0.1,
          //           ),
          //           gridColumnRpt(
          //             field: 'customer_name',
          //             title: 'Customer Name',
          //             // width: size.width * 0.15,
          //           ),
          //           gridColumnRpt(
          //             field: 'customer_id',
          //             title: 'CUSTOMER ID',
          //             // width: size.width * 0.15,
          //             hide: true,
          //           ),

          //           gridColumnRpt(
          //             field: 'assigned_to',
          //             title: 'Assigned User',
          //             // width: size.width * 0.1,
          //           ),
          //           gridColumnRpt(
          //             field: 'assigned_to_id',
          //             title: 'ASSIGNED USER EMAIL',
          //             // width: size.width * 0.1,
          //             hide: true,
          //           ),
          //           // gridColumnRpt(
          //           //   field: 'status',
          //           //   title: 'Status',
          //           //   width: 135,
          //           // ),
          //           gridColumnRpt(
          //             field: 'status',
          //             title: 'Status',
          //             // width: 135,
          //             renderer: (rendererContext) {
          //               final cells = rendererContext.row.cells;
          //               final statusValue =
          //                   cells['status']?.value?.toString() ?? '0';

          //               // Map numeric status to label
          //               const labels = [
          //                 'Pending',
          //                 'In Progress',
          //                 'Completed',
          //                 'On Hold',
          //                 'Cancelled',
          //                 'FTC',
          //               ];

          //               // Map numeric status to colors
          //               const colors = [
          //                 Colors.orange, // Pending
          //                 Colors.blue, // In Progress
          //                 Colors.green, // Completed
          //                 Colors.grey, // On Hold
          //                 Colors.red, // Cancelled
          //                 Colors.purple, // FTC
          //               ];

          //               int index = int.tryParse(statusValue) ?? 0;
          //               if (index < 0 || index >= labels.length) index = 0;

          //               final label = labels[index];
          //               final color = colors[index];

          //               return Container(
          //                 padding: const EdgeInsets.symmetric(
          //                   horizontal: 8,
          //                   vertical: 4,
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: color.withOpacity(0.15), // light background
          //                   borderRadius: BorderRadius.circular(5),
          //                   border: Border.all(color: color, width: 1),
          //                 ),
          //                 child: Text(
          //                   label,
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontSize: 11,
          //                     fontWeight: FontWeight.w600,
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //           gridColumnRpt(
          //             field: 'tododate',
          //             title: 'ToDo Date',
          //             // width: 135,
          //           ),
          //           gridColumnRpt(
          //             field: 'duedate',
          //             title: 'Due Date',
          //             // width: 135,
          //           ),
          //           gridColumnRpt(
          //             field: 'title',
          //             title: 'Title',
          //             // width: size.width * 0.1,
          //           ),
          //           gridColumnRpt(
          //             field: 'description',
          //             title: 'Description',
          //             // width: 135,
          //           ),
          //           gridColumnRpt(
          //             field: 'event_name',
          //             title: 'Event Name',
          //             // width: size.width * 0.15,
          //           ),
          //           gridColumnRpt(
          //             field: 'event_id',
          //             title: 'EVENT ID',
          //             // width: size.width * 0.15,
          //             hide: true,
          //           ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'query_category_id',
          //               title: 'QUERY CATEGORY ID',
          //               // width: 135,
          //               hide: true,
          //             ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'query_category_name',
          //               title: 'Query/Division',
          //               // width: 135,
          //             ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'subquery_category_id',
          //               title: 'SUBQUERY CATEGORY ID',
          //               // width: 135,
          //               hide: true,
          //             ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'subquery_category_name',
          //               title: 'Subquery/Target',
          //               // width: 135,
          //             ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'ownership_category_id',
          //               title: 'OWNERSHIP CATEGORY ID',
          //               // width: 135,
          //               hide: true,
          //             ),
          //           if (controller.screenType == "support")
          //             gridColumnRpt(
          //               field: 'ownership_category_name',
          //               title: 'Pending Ownership',
          //               // width: 135,
          //             ),

          //           //-------------------------------------------------
          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'source',
          //               title: 'Source',
          //               // width: 135,
          //             ),

          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'business_opportunity_id',
          //               title: 'Business Opportunity ID',
          //               hide: true,
          //               // width: 135,
          //             ),

          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'business_opportunity_name',
          //               title: 'Business Opportunity',
          //               // width: 135,
          //             ),

          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'division_category',
          //               title: 'Division Category',
          //               // width: 135,
          //             ),
          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'target_category_id',
          //               title: 'Target Category ID',
          //               hide: true,
          //               // width: 135,
          //             ),
          //           if (controller.screenType != "support")
          //             gridColumnRpt(
          //               field: 'target_categoty_name',
          //               title: 'Target Category',
          //               // width: 135,
          //             ),
          //           gridColumnRpt(
          //             field: 'rating',
          //             title: 'Rating',
          //             // width: 135,
          //             hide: true,
          //           ),
          //           gridColumnRpt(
          //             field: 'created_at',
          //             title: 'Creted At',
          //             // width: 135,
          //           ),
          //           gridColumnRpt(
          //             field: 'updated_at',
          //             title: 'Updated At',
          //             // width: 135,
          //           ),
          //         ].obs,
          //         // rows: controller.rows,
          //         rows: controller.filteredRows,
          //         onLoaded: (event) {
          //           controller.stateManager = event.stateManager;
          //         },
          //       );
          //     }
          //   }),
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
                  // horizontal: 12,
                  vertical: 8,
                ),
                itemCount: controller.filteredRows.length,
                itemBuilder: (context, i) {
                  final cells = controller.filteredRows[i].cells;

                  final id = cells['id']?.value?.toString() ?? '';
                  final privateId = cells['privateid']?.value?.toString() ?? '';
                  final customerName =
                      cells['customer_name']?.value?.toString() ?? '';
                  final assignedTo =
                      cells['assigned_to']?.value?.toString() ?? '';
                  final statusValue = cells['status']?.value?.toString() ?? '0';
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),),
      // ),
      // ),
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
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();

      return createdDate.year == now.year &&
          createdDate.month == now.month &&
          createdDate.day == now.day;
    } catch (e) {
      return false;
    }
  }
}
