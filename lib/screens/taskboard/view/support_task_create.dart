import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/taskboard/support_task_dropdown_model.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

// ignore: must_be_immutable
class SupportTaskCreateDialog extends StatelessWidget {
  final Size size;
  final Map<String, dynamic>? rowData;
  final bool hideCustomerSourceBiz;
  final bool followUpTask;
  final bool partyMasterTask;
  final SupportTaskEditController supportTaskController = Get.find();
  bool get isEdit => rowData != null;

  SupportTaskCreateDialog(
    this.size, {
    super.key,
    this.rowData,
    this.hideCustomerSourceBiz = false,
    this.followUpTask = false,
    this.partyMasterTask = false,
  }) {
    print(
      "Dialog Open → EditingRowData: ${supportTaskController.editingRowData.value}",
    );
    if (rowData != null) {
      // Edit
      supportTaskController.editingRowData.value = rowData;
      supportTaskController.loadTaskForEdit(rowData!);
    } else {
      // Add
      supportTaskController.clearFields(
        followUpTask: followUpTask,
        partyMasterTask: partyMasterTask,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: isEdit
            ? 'Update Support Task'
            : followUpTask
            ? 'Add Follow-up Support Task'
            : 'Add Support Task',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       if (!hideCustomerSourceBiz &&
                      //           !followUpTask &&
                      //           !partyMasterTask &&
                      //           !isEdit)
                      //         Obx(
                      //           () => DropdownCustomList<CustomerList>(
                      //             title: "Customer",
                      //             hint: "Select Customer",
                      //             isCompulsory: true,
                      //             items: supportTaskController.customerList
                      //                 .map(
                      //                   (item) =>
                      //                       DropdownMenuItem<CustomerList>(
                      //                         value: item,
                      //                         child: Text(
                      //                           item.retailerName ?? '',
                      //                         ),
                      //                       ),
                      //                 )
                      //                 .toList(),
                      //             selectedValue:
                      //                 supportTaskController.selectedCustomer,
                      //             onChanged: (value) {
                      //               supportTaskController
                      //                       .selectedCustomer
                      //                       .value =
                      //                   value;
                      //             },
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          if (!hideCustomerSourceBiz && !followUpTask && !partyMasterTask && !isEdit)

                            Obx(() {
                              final RxString displayName = RxString(
                                supportTaskController
                                        .selectedCustomer
                                        .value
                                        ?.retailerName ??
                                    '',
                              );

                              return DropdownCustomList<String>(
                                title: "Customer",
                                hint: "Search Customer",
                                isCompulsory: true,
                                items: const [],
                                selectedValue: displayName,

                                onSearchApi: (query) async {
                                  await supportTaskController.customerListData(
                                    query,
                                  );
                                  return supportTaskController.partyEntityList
                                      .map<DropdownMenuItem<String>>(
                                        (item) => DropdownMenuItem<String>(
                                          value: item.partyName,
                                          child: Text(item.partyName ?? ''),
                                        ),
                                      )
                                      .toList();
                                },

                                onChanged: (value) {
                                  if (value != null) {
                                    final customer = supportTaskController
                                        .partyEntityList
                                        .firstWhereOrNull(
                                          (e) => e.partyName == value,
                                        );

                                    if (customer != null) {
                                      supportTaskController
                                          .selectedCustomer
                                          .value = CustomerList(
                                        retailerName: customer.partyName,
                                        tallyRetailerCode: customer.partyId,
                                      );
                                    }
                                  }
                                },

                                onClear: () {
                                  supportTaskController.selectedCustomer.value =
                                      null;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<EventList>(
                                title: 'Event',
                                isCompulsory: true,
                                hint: "Select Event",
                                items: supportTaskController.eventList
                                    .map(
                                      (item) => DropdownMenuItem<EventList>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    supportTaskController.selectedEvent,
                                onChanged: (value) {
                                  supportTaskController.selectedEvent.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<String>(
                                title: "Status",
                                hint: "Select Status",
                                isCompulsory: true,
                                items: supportTaskController.statuslist
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value:
                                            item, // this is the name, e.g., "Pending"
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    supportTaskController.selectedstatus,
                                onChanged: (value) {
                                  // Set selectedstatus to the name of the status
                                  supportTaskController.selectedstatus.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<QueryCategory>(
                                title: "Query Category",
                                hint: "Select Category",
                                isCompulsory: true,
                                items: supportTaskController.queryCategoryList
                                    .map(
                                      (item) => DropdownMenuItem<QueryCategory>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    supportTaskController.selectedQueryCategory,
                                onChanged: supportTaskController
                                    .onQueryCategoryChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<SubQueryCategory>(
                                title: "Subquery Category",
                                hint: "Select Sub Category",
                                isCompulsory: true,
                                items: supportTaskController
                                    .filteredSubQueryCategoryList
                                    .map(
                                      (item) =>
                                          DropdownMenuItem<SubQueryCategory>(
                                            value: item,
                                            child: Text(item.name ?? ''),
                                          ),
                                    )
                                    .toList(),
                                selectedValue: supportTaskController
                                    .selectedSubQueryCategory,
                                onChanged: (value) {
                                  supportTaskController
                                          .selectedSubQueryCategory
                                          .value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<OwnershipCategory>(
                                title: "Pending Ownership",
                                hint: "Select Ownership",
                                isCompulsory: true,
                                items: supportTaskController
                                    .ownershipCategoryList
                                    .map(
                                      (item) =>
                                          DropdownMenuItem<OwnershipCategory>(
                                            value: item,
                                            child: Text(item.name ?? ''),
                                          ),
                                    )
                                    .toList(),
                                selectedValue: supportTaskController
                                    .selectedOwnershipCategory,
                                onChanged: (value) {
                                  supportTaskController
                                          .selectedOwnershipCategory
                                          .value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<AssignedTo>(
                                title: 'Assigned To',
                                isCompulsory: true,
                                hint: "Select User",
                                items: supportTaskController.assignedToList
                                    .map(
                                      (item) => DropdownMenuItem<AssignedTo>(
                                        value: item,
                                        child: Text(item.userName ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    supportTaskController.selectedAssignedTo,
                                onChanged: (value) {
                                  supportTaskController
                                          .selectedAssignedTo
                                          .value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: supportTaskController.title,
                              title: 'Title',
                              isCompulsory: true,
                              hinttext: 'Enter Title',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: supportTaskController.tododate,
                              title: 'ToDo Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  supportTaskController.tododate.text =
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(pickedDate);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: supportTaskController.duedate,
                              title: 'Due Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  supportTaskController.duedate.text =
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(pickedDate);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: supportTaskController.description,
                              keyboardType: TextInputType.text,
                              title: 'Description',
                              hinttext: 'Enter Description',
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     padding: const EdgeInsets.all(12),
      //     child: SizedBox(
      //       // width: size.width * 0.4,
      //       width: MediaQuery.of(context).size.width * 0.3,
      //       child: ResponsiveButton(
      //         title: isEdit ? 'Update' : 'Save',
      //         function: () async {
      //           Utility.processLoadingWidget();
      //           await supportTaskController.submitSupportTask();
      //         },
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          child: ResponsiveButton(
            title: isEdit ? 'Update' : 'Save',
            function: () async {
              Utility.processLoadingWidget();
              await supportTaskController.submitSupportTask();
            },
          ),
        ),
      ),
    );
  }
}
