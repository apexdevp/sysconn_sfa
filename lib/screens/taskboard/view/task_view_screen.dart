import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/taskboard/audit_log_model.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/task_bicopportunity_create_controller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/view/pinscreen.dart';
import 'package:sysconn_sfa/screens/taskboard/view/sales_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/support_task_create.dart';
import 'package:sysconn_sfa/screens/taskboard/view/task_bizoppotunity_create.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class SupportTaskView extends StatelessWidget {
  final Map<String, dynamic>? rowData;

  final SupportTaskEditController supportTaskController =
      Get.find<SupportTaskEditController>();
  final SalesTaskEditController salesTaskController =
      Get.find<SalesTaskEditController>();
  final TaskController taskcontroller = Get.find<TaskController>();

  SupportTaskView({super.key, this.rowData}) {
    //  DEBUG - print screenType when view opens
    print(
      "🖥️ SupportTaskView opened - screenType: ${taskcontroller.screenType}",
    );
    print("🖥️ TaskController hashCode: ${taskcontroller.hashCode}");
    taskcontroller.isPinnedPanelOpen.value = false;
    taskcontroller.activeTab.value = "overview";

    if (rowData != null) {
      if (taskcontroller.screenType == "support") {
        supportTaskController.editingRowData.value = rowData;
        supportTaskController.getSupportTaskBizOpList();
      } else {
        salesTaskController.editingRowData.value = rowData;
        salesTaskController.getSalesTaskBizOpList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenType = taskcontroller.screenType;
    // Size size = MediaQuery.of(context).size;
    // return AuthGuard(
    //   child: DefaultLayout(
    //     appBar: AppBarCustom(
    // title: 'Support Task',
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: taskcontroller.screenType == "support"
            ? "Support Task View"
            : "Sales Task",
      ),
      // dateChangeFunction: () {
      //   controller.getSupportTaskData();
      // },
      // dateChangeFunction: () {
      //   if (controller.screenType == "support") {
      //     controller.getSupportTaskData();
      //   } else {
      //     controller.getSalesTaskData();
      //   }
      // },
      //   excelExportFunction: () {
      //     if (taskcontroller.stateManager == null) {
      //       Utility.showAlert(
      //         icon: Icons.warning,
      //         iconColor: Colors.orange,
      //         title: 'Please Wait',
      //         message: 'Grid is still loading...',
      //       );
      //       return;
      //     }
      //     final isFilterActive =
      //         taskcontroller.stateManager?.hasFilter ?? false;

      //     Utility.exportToCsv(
      //       reportTitle: 'Support Task',
      //       columns: taskcontroller.stateManager!.columns,
      //       allRows: isFilterActive
      //           ? taskcontroller.stateManager!.refRows.filteredList
      //           : taskcontroller.stateManager!.refRows.originalList,
      //     );
      //   },
      // ),
      body: Obx(() {
        // final row = taskcontroller.screenType == "support"
        //     ? supportTaskController.editingRowData.value
        //     : salesTaskController.editingRowData.value;

        return Stack(
          children: [
            /// ✅ YOUR EXISTING UI (UNCHANGED)
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ), // ✅ space between appbar and header card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ), // ✅ same horizontal padding as left panel
                    child: Obx(() {
                      final row = taskcontroller.screenType == "support"
                          ? supportTaskController.editingRowData.value
                          : salesTaskController.editingRowData.value;

                      if (row == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      const statusMap = {
                        '0': 'Pending',
                        '1': 'In Progress',
                        '2': 'Completed',
                        '3': 'On Hold',
                        '4': 'Cancelled',
                        '5': 'FTC',
                      };

                      final statusValue = row['status']?.toString() ?? '0';
                      final statusLabel = statusMap[statusValue] ?? 'Unknown';

                      return TaskHeaderCard(
                        title: row['title'] ?? '',
                        taskId: row['privateid']?.toString() ?? '',
                        createdAt: row['created_at'] ?? '',
                        assignedTo: row['assigned_to'] ?? '',
                        status: statusLabel,
                        statusvalue: statusValue,
                        screenType: screenType,
                        rowData: row,
                      );
                    }),
                  ),

                  const SizedBox(height: 8),

                  TaskLinksRow(
                    active: taskcontroller.activeTab.value,
                    controller: taskcontroller,
                  ),

                  const SizedBox(height: 6),

                  /// 👉 KEEP YOUR EXISTING OVERVIEW/AUDIT CODE SAME HERE
                  Obx(() {
                    final activeTab = taskcontroller.activeTab.value;

                    if (activeTab == "overview") {
                      // return LayoutBuilder(
                      //   builder: (context, constraints) {
                      // bool isMobile = constraints.maxWidth < 800;

                      final screenWidth = MediaQuery.of(context).size.width;
                      final bool isMobile = screenWidth < 600;

                      if (isMobile) {
                        return Column(
                          children: [
                            _LeftPanel(
                              supportTaskController,
                              salesTaskController,
                              screenType,
                            ),
                            const SizedBox(height: 12),
                            _RemarkPanel(
                              supportTaskController,
                              salesTaskController,
                              screenType,
                            ),
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _LeftPanel(
                                supportTaskController,
                                salesTaskController,
                                screenType,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _RemarkPanel(
                                supportTaskController,
                                salesTaskController,
                                screenType,
                              ),
                            ),
                          ),
                        ],
                      );
                      //   },
                      // );
                    } else if (activeTab == "audit-log") {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuditLogTab(
                              supportController: supportTaskController,
                              salesController:
                                  salesTaskController, // ← add this
                              screenType: screenType, // ← add this
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            ///  DARK BACKGROUND
            // if (taskcontroller.isPinnedPanelOpen.value)
            //   GestureDetector(
            //     onTap: () => taskcontroller.isPinnedPanelOpen.value = false,
            //     child: Container(color: Colors.black.withOpacity(0.2)),
            //   ),
            // Obx(() {
            //   if (!taskcontroller.isPinnedPanelOpen.value)
            //     return const SizedBox.shrink();
            //   return GestureDetector(
            //     onTap: () => taskcontroller.isPinnedPanelOpen.value = false,
            //     child: Container(color: Colors.black.withOpacity(0.2)),
            //   );
            // }),
            Obx(() {
              final row = taskcontroller.screenType == "support"
                  ? supportTaskController.editingRowData.value
                  : salesTaskController.editingRowData.value;

              return PinnedTaskDrawer(
                row: row ?? {},
                isOpen: taskcontroller.isPinnedPanelOpen,
                screenType: taskcontroller.screenType,
              );
            }),
          ],
        );
      }),
    );
    //   ),
    // );
  }
}

/// ------------------ TASK HEADER CARD ------------------
class TaskHeaderCard extends StatelessWidget {
  final String title;
  final String taskId;
  final String createdAt;
  final String assignedTo;
  final String status;
  final String statusvalue;
  final String screenType;
  final Map<String, dynamic> rowData;

  const TaskHeaderCard({
    super.key,
    required this.title,
    required this.taskId,
    required this.createdAt,
    required this.assignedTo,
    required this.status,
    required this.statusvalue,
    required this.screenType,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          //#CID${row['customer_id'] ?? "0"}
          "Task ID: $taskId\nCreated At: $createdAt\nAssign To: $assignedTo",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );

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

    final actionSection = Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: const Size(0, 32),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // _iconBox(Icons.push_pin),
        // _iconBox(Icons.access_alarm),
        // _iconBox(
        //   Icons.push_pin,
        //   tooltip: "Pin Task",
        //   onTap: () {
        //     print("Pin clicked");
        //   },
        // ),
        _iconBox(
          Icons.push_pin,
          tooltip: "Pin Task",
          onTap: () {
            final controller = Get.find<TaskController>();
            controller.isPinnedPanelOpen.value = true;
          },
        ),
        // _iconBox(
        //   Icons.access_alarm,
        //   tooltip: "Add Folloup Task",
        //   onTap: () {
        //     print("Alarm clicked");
        //     if (screenType == "support") {
        //       final editController = Get.put(SupportTaskEditController());
        //       editController.clearFields();
        //       Get.dialog(SupportTaskCreateDialog(size));
        //     } else {
        //       final editController = Get.put(SalesTaskEditController());
        //       editController.clearFields();
        //       Get.dialog(SalesTaskStatusCreateDialog(size));
        //     }
        //   },
        // ),
        // _iconBox(
        //   Icons.access_alarm,
        //   tooltip: "Add Follow-up Task",
        //   onTap: () {
        //     print("Alarm clicked");

        //     // if (screenType == "support") {
        //     //   Get.dialog(SupportTaskCreateDialog(size));
        //     // } else {
        //     //   Get.dialog(SalesTaskCreateDialog(size));
        //     // }

        //     Get.dialog(
        //       screenType == "support"
        //           ? SupportTaskCreateDialog(size, followUpTask: true)
        //           : SalesTaskCreateDialog(size, followUpTask: true),
        //     );
        //   },
        // ),
        _iconBox(
          Icons.access_alarm,
          tooltip: "Add Follow-up Task",
          onTap: () {
            Get.dialog(
              screenType == "support"
                  ? SupportTaskCreateDialog(size, followUpTask: true) // ✅
                  : SalesTaskCreateDialog(size, followUpTask: true), // ✅
            );
          },
        ),
        _iconBox(
          Icons.edit,
          tooltip: "Edit Task",
          onTap: () {
            if (screenType == "support") {
              // Get.dialog(SupportTaskCreateDialog(size, rowData: rowData));
              Get.to(() => SupportTaskCreateDialog(size, rowData: rowData));
            } else {
              // Get.dialog(SalesTaskCreateDialog(size, rowData: rowData));
              Get.to(() => SalesTaskCreateDialog(size, rowData: rowData));
            }
          },
        ),
        if (isToday(rowData['created_at']?.toString()))
        _iconBox(
          Icons.delete,
          tooltip: "Delete Task",
          onTap: () {
            final controller = Get.find<TaskController>();
            Utility.showAlertYesNo(
              iconData: Icons.warning_amber_rounded,
              iconcolor: Colors.red,
              title: "Delete Item",
              msg: "Are you sure you want to delete?",
              yesBtnFun: () async {
                final id = rowData['id']?.toString() ?? '';
                
                if (screenType == "support") {
                  await controller.deleteSupportTaskApi(supportTaskId: id);
                } else {
                  await controller.deleteSalesTaskApi(salesTaskId: id);
                }
              },
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black, size: 20),
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            if (statusvalue == '0' || statusvalue == '1')
              ActionMenuItem(
                value: 'hold',
                icon: Icons.pause_circle_filled,
                text: 'Mark Hold',
                iconColor: Colors.grey,
                onTap: () async {
                  if (screenType == "support") {
                    print("Hold clicked (support screen)");
                    final controller = Get.find<SupportTaskEditController>();
                    await controller.updateStatusOnly('3');
                  } else {
                    print("Hold clicked (support screen)");
                    final controller = Get.find<SalesTaskEditController>();
                    await controller.updateSalesStatusOnly('3');
                  }
                },
              ),

            if (statusvalue == '0' || statusvalue == '1')
              ActionMenuItem(
                value: 'cancel',
                icon: Icons.delete,
                text: 'Mark Cancel',
                iconColor: Colors.grey,
                onTap: () async {
                  if (screenType == "support") {
                    print("Cancel clicked (screen support)");
                    final controller = Get.find<SupportTaskEditController>();
                    await controller.updateStatusOnly('4');
                  } else {
                    print("Hold clicked (support screen)");
                    final controller = Get.find<SalesTaskEditController>();
                    await controller.updateSalesStatusOnly('4');
                  }
                },
              ),

            // const PopupMenuDivider(),
            // ActionMenuItem(
            //   value: 'edit',
            //   icon: Icons.edit,
            //   text: 'Edit Task',
            //   iconColor: Colors.grey,
            //   onTap: () {
            //     print("Edit clicked");

            //     try {
            //       if (screenType == "support") {
            //         final controller = Get.find<SupportTaskEditController>();

            //         controller.loadTaskForEdit(rowData); // ✅ DIRECT USE

            //         Get.dialog(
            //           SupportTaskCreateDialog(
            //             MediaQuery.of(context).size,
            //             rowData: rowData,
            //             hideCustomerSourceBiz: true,
            //           ),
            //         );
            //       } else {
            //         final controller = Get.find<SalesTaskEditController>();
            //         controller.loadTaskForEdit(rowData); // ✅ DIRECT USE

            //         Get.dialog(
            //           SalesTaskCreateDialog(
            //             MediaQuery.of(context).size,
            //             rowData: rowData,
            //             hideCustomerSourceBiz: true,
            //           ),
            //         );
            //       }
            //     } catch (e, st) {
            //       debugPrint("Error loading task for edit: $e\n$st");
            //       Get.snackbar("Error", "Failed to load task for edit");
            //     }
            //   },
            // ),
            // ActionMenuItem(
            //   value: 'delete',
            //   icon: Icons.delete,
            //   text: 'Delete Task',
            //   iconColor: Colors.grey,
            //   onTap: () {
            //     // Your delete logic
            //     print("Delete clicked");
            //   },
            // ),
          ],
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      // margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleSection,
                const SizedBox(height: 12),
                actionSection,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleSection),
                const SizedBox(width: 12),
                actionSection,
              ],
            ),
    );
    //   },
    // );
  }

  Widget _iconBox(
    IconData icon, {
    required String tooltip,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip, // 👈 THIS shows hover text
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

/// ------------------ TASK LINKS ROW ------------------
class TaskLinksRow extends StatelessWidget {
  final String active;
  // final String companyId;
  // final String taskId;
  final TaskController controller;

  const TaskLinksRow({
    super.key,
    required this.active,
    // required this.companyId,
    // required this.taskId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // <--- This ensures left alignment
      child: Container(
        // Grey line under the entire nav
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // only as wide as nav links
          children: [
            _navLink("overview", "Overview"),
            _navLink("audit-log", "Audit Logs"),
          ],
        ),
      ),
    );
  }

  Widget _navLink(String key, String label) {
    return Obx(() {
      final bool isActive = key == controller.activeTab.value;

      return GestureDetector(
        onTap: () {
          controller.activeTab.value = key;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: isActive
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 2),
                  ),
                )
              : null,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    });
  }
}

//==================Show menu helper=================
class ActionMenuItem extends PopupMenuItem<String> {
  ActionMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    EdgeInsets? padding,
    Color iconColor = Colors.black,
    Key? key,
  }) : super(
         onTap: onTap,
         key: key,
         value: value,
         padding:
             padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
         height: 36,
         child: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             Icon(icon, size: 13, color: iconColor),
             const SizedBox(width: 6),
             Text(text, style: const TextStyle(fontSize: 13)),
           ],
         ),
       );
}

/// ------------------ LEFT PANEL (Customer + BizOp) ------------------
class _LeftPanel extends StatelessWidget {
  final SupportTaskEditController controller;
  final SalesTaskEditController taskcontroller;
  final String screenType;
  const _LeftPanel(this.controller, this.taskcontroller, this.screenType);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      final row = screenType == "support"
          ? controller.editingRowData.value
          : taskcontroller.editingRowData.value;

      if (row == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // ------------------- CUSTOMER DETAILS CARD -------------------
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Details:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  // Customer Name (hardcoded if not available)
                  InkWell(
                    onTap: () {
                      // Navigate to customer details page if you implement
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            // text: "John Doe", // replace with controller.showData.people?.name
                            text: row['customer_name'] ?? "N/A",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " ⭐ (${row['rating'] ?? "0"})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    // "(#PID12345)", // replace with privateId
                    "Customer ID: ${row['customer_id'] ?? "0"}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),
                  _rowItem(
                    "Task Type:",
                    screenType == "support"
                        ? "Support Activity"
                        : "Sales Activity",
                  ),
                  _rowItem("Category Type:", row['event_name'] ?? "N/A"),
                  if (screenType == "support")
                    _rowItem("Query:", row['query_category_name'] ?? "N/A"),
                  if (screenType == "support")
                    _rowItem(
                      "Subquery:",
                      row['subquery_category_name'] ?? "N/A",
                    ),

                  _rowItem("Todo Date:", row['tododate'] ?? "N/A"),
                  _rowItem("Due Date:", row['duedate'] ?? "N/A"),
                  const Divider(),

                  // Row(
                  //   children: [
                  //     const SizedBox(
                  //       width: 100,
                  //       child: Text(
                  //         "Support Query:",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  if (screenType == "support")
                    _rowItem(
                      "Ownership:",
                      row['ownership_category_name'] ?? "N/A",
                    ),
                  if (screenType != "support")
                    _rowItem("Division:", row['division_category'] ?? "N/A"),
                  if (screenType != "support")
                    _rowItem("Target:", row['target_categoty_name'] ?? "N/A"),

                  const Divider(),

                  Text(
                    "Last Updated At: ${row['updated_at'] ?? "N/A"}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          /// ------------------- HUNTED BIZ OP CARD -------------------
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SizedBox(
              // width: screenWidth,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hunted BizOp:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// OBSERVE BIZ OP LIST
                    Obx(() {
                      final isLoading = screenType == "support"
                          ? controller.isBizOpLoading.value
                          : taskcontroller.isBizOpLoading.value;

                      final bizOpList = screenType == "support"
                          ? controller.bizOpList
                          : taskcontroller.bizOpList;

                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (bizOpList.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "No Opportunities Found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Column(
                        children: bizOpList.map((item) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Product
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Product",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${item.productCode} - ${item.productDesc}",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              /// Rate × Qty
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Rate & Qty",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    // "${item.rate} × ${item.qty}",
                                    "${(double.tryParse(item.rate ?? '0') ?? 0).toStringAsFixed(2)} × ${item.qty}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              /// Total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "₹${item.total}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 0.3),
                            ],
                          );
                        }).toList(),
                      );
                    }),

                    // Dynamic Grand Total
                    Obx(() {
                      final bizOpList = screenType == "support"
                          ? controller.bizOpList
                          : taskcontroller.bizOpList;

                      double grandTotal = bizOpList.fold(
                        0,
                        (sum, item) =>
                            sum + (double.tryParse(item.total ?? "0") ?? 0),
                      );

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Grand Total:"),
                          Text(
                            "₹${grandTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),

                    // Add Biz Opportunity Button
                    InkWell(
                      onTap: () {
                        final row = screenType == "support"
                            ? controller.editingRowData.value
                            : taskcontroller.editingRowData.value;
                        if (row == null) return;

                        final retailerCode = row['customer_id']?.toString();
                        final taskid = row['id']?.toString();

                        final controllerBiz = Get.put(
                          TaskBizOpportunitiesCreateController(),
                        );
                        controllerBiz.clearFields();
                        controllerBiz.taskId = taskid;
                        controllerBiz.screenTypeMove = screenType;

                        Get.dialog(
                          TaskBizOpportunitiesCreate(
                            size,
                            retailerCode: retailerCode,
                            taskid: taskid,
                            isCustomerReadOnly: true,
                          ),
                          barrierDismissible: false,
                        ).then((value) {
                          if (screenType == "support") {
                            controller.getSupportTaskBizOpList();
                          } else {
                            taskcontroller.getSalesTaskBizOpList();
                          }
                        });

                        controllerBiz.preselectCustomer(retailerCode);
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Add Biz Opportunity',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ RIGHT PANEL (Auto-update Description with Debounce + Save Indicator) ------------------
class _RemarkPanel extends StatefulWidget {
  final SupportTaskEditController controller;
  final SalesTaskEditController taskcontroller;
  final String screenType;

  const _RemarkPanel(this.controller, this.taskcontroller, this.screenType);

  @override
  State<_RemarkPanel> createState() => _RemarkPanelState();
}

class _RemarkPanelState extends State<_RemarkPanel> {
  late final TextEditingController _descController;
  Timer? _debounceTimer;
  String? _currentRowId;
  RxString saveStatus = "Saved".obs;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController();

    final row = widget.screenType == "support"
        ? widget.controller.editingRowData.value
        : widget.taskcontroller.editingRowData.value;

    if (row != null) {
      _descController.text = row['description']?.toString() ?? '';
      _currentRowId = row['id']?.toString();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _descController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged(String value) {
    if (value.trim().isEmpty) return;

    // Immediately show "Saving..." when user starts typing
    saveStatus.value = "Saving...";

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      // Call API after typing stops
      if (widget.screenType == "support") {
        await widget.controller.updateDescriptionOnly(value.trim());
      } else {
        await widget.taskcontroller.updateSalesDescriptionOnly(value.trim());
      }

      saveStatus.value = "Saved";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // final row = widget.controller.editingRowData.value;
      final row = widget.screenType == "support"
          ? widget.controller.editingRowData.value
          : widget.taskcontroller.editingRowData.value;
      if (row == null) return const Center(child: CircularProgressIndicator());

      final rowId = row['id']?.toString();

      final newDescription = row['description']?.toString() ?? '';
      // if (_currentRowId != rowId) {
      //   _descController.text = row['description']?.toString() ?? '';
      //   _currentRowId = rowId;
      //   saveStatus.value = "Saved";
      // }

      if (_currentRowId != rowId) {
        // Different task opened - update everything
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _descController.text = newDescription;
          saveStatus.value = "Saved";
        });
        _currentRowId = rowId;
      } else if (_descController.text != newDescription &&
          saveStatus.value == "Saved") {
        // Same task but description updated externally (after edit submit)
        // Only update if user is NOT currently typing (saveStatus == "Saved")
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _descController.text = newDescription;
        });
      }

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Task Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Enter remark...",
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black, // black color
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
              onChanged: _onDescriptionChanged,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => Text(
                  saveStatus.value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black, // black color
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AuditLogTab extends StatefulWidget {
  final SupportTaskEditController supportController;
  final SalesTaskEditController salesController;
  final String screenType;

  const AuditLogTab({
    super.key,
    required this.supportController,
    required this.salesController,
    required this.screenType,
  });

  @override
  State<AuditLogTab> createState() => _AuditLogTabState();
}

class _AuditLogTabState extends State<AuditLogTab> {
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLogs();

      if (widget.screenType == "support") {
        _worker = ever(
          widget.supportController.editingRowData,
          (_) => _fetchLogs(),
        );
      } else {
        _worker = ever(
          widget.salesController.editingRowData,
          (_) => _fetchLogs(),
        );
      }
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    super.dispose();
  }

  void _fetchLogs() {
    if (widget.screenType == "support") {
      widget.supportController.getAuditLogs(
        model: 'support_task',
        modelId:
            widget.supportController.editingRowData.value?['id']?.toString() ??
            '',
      );
    } else {
      widget.salesController.getAuditLogs(
        model: 'sales_task',
        modelId:
            widget.salesController.editingRowData.value?['id']?.toString() ??
            '',
      );
    }
  }

  /// Parse "dd-MM-yyyy HH:mm:ss" or "dd-MM-yyyy"
  DateTime _parseDate(String raw) {
    final dateOnly = raw.split(' ')[0].trim(); // "03-04-2026"
    final parts = dateOnly.split('-'); // ["03", "04", "2026"]
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }

  Map<String, List<Log>> _groupByDate(List<Log> logs) {
    final Map<String, List<Log>> grouped = {};
    for (final log in logs) {
      final dateKey = log.createdDate.split(' ')[0].trim(); // "03-04-2026"
      grouped.putIfAbsent(dateKey, () => []).add(log);
    }
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.createdTime.compareTo(a.createdTime));
    }
    return grouped;
  }

  String _formatDateHeader(String rawDate) {
    try {
      return DateFormat('dd MMM yyyy').format(_parseDate(rawDate));
    } catch (e) {
      return rawDate;
    }
  }

  Color _getActivityColor(String activity) {
    final a = activity.toLowerCase();
    if (a.contains('task created')) return Colors.green;
    if (a.contains('task status updated')) return Colors.purple;
    if (a.contains('task updated') || a.contains('edit')) return Colors.blue;
    if (a.contains('deleted') || a.contains('cancel')) return Colors.red;
    if (a.contains('hold')) return Colors.orange;
    if (a.contains('completed')) return Colors.teal;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.screenType == "support"
          ? widget.supportController.isLoading.value
          : widget.salesController.isLoading.value;

      final logs = widget.screenType == "support"
          ? widget.supportController.indexData
          : widget.salesController.indexData;

      if (isLoading) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (logs.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No audit logs available",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }

      final grouped = _groupByDate(logs);
      final dates = grouped.keys.toList()
        ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: dates.length,
        itemBuilder: (context, dateIndex) {
          final date = dates[dateIndex];
          final dateLogs = grouped[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date Chip Header ──
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDateHeader(date),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                  ],
                ),
              ),

              // ── Timeline Cards ──
              ...dateLogs.asMap().entries.map((entry) {
                final index = entry.key;
                final log = entry.value;
                final isLast = index == dateLogs.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline dot + line
                      SizedBox(
                        width: 32,
                        child: Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(top: 14),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Log Card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Activity badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getActivityColor(
                                          log.activity,
                                        ).withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log.activity,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: _getActivityColor(
                                            log.activity,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Time
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          log.createdTime,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Card Body — Description
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Text(
                                  log.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      );
    });
  }
}
