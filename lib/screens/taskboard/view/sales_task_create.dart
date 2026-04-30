import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// ignore: must_be_immutable
class SalesTaskCreateDialog extends StatelessWidget {
  final Size size;
  final Map<String, dynamic>? rowData;
  final bool hideCustomerSourceBiz;
  final bool partyMasterTask;
  final bool followUpTask;

  final SalesTaskEditController salesTaskController = Get.find();
  bool get isEdit => rowData != null;

  SalesTaskCreateDialog(
    this.size, {
    super.key,
    this.rowData,
    this.hideCustomerSourceBiz = false,
    this.partyMasterTask = false,
    this.followUpTask = false,
  }) {
    print(
      "Dialog Open → EditingRowData: ${salesTaskController.editingRowData.value}",
    );
    if (rowData != null) {
      //Edit
      salesTaskController.editingRowData.value = rowData;
      salesTaskController.loadTaskForEdit(rowData!);
    } else {
      //Add
      salesTaskController.clearFields(
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
            ? 'Update Sales Task'
            : followUpTask
            ? 'Add Follow-up Sales Task'
            : 'Add Sales Task',
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
                      //             items: salesTaskController.customerList
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
                      //                 salesTaskController.selectedCustomer,
                      //             onChanged: (value) {
                      //               salesTaskController.selectedCustomer.value =
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
                            if (!hideCustomerSourceBiz &&
                                !followUpTask &&
                                !partyMasterTask &&
                                !isEdit)
                            Obx(() {
                              final RxString displayName = RxString(
                                salesTaskController
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
                                  await salesTaskController.customerListData(
                                    query,
                                  );
                                  return salesTaskController.partyEntityList
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
                                    final customer = salesTaskController
                                        .partyEntityList
                                        .firstWhereOrNull(
                                          (e) => e.partyName == value,
                                        );

                                    if (customer != null) {
                                      salesTaskController
                                          .selectedCustomer
                                          .value = CustomerList(
                                        retailerName: customer.partyName,
                                        tallyRetailerCode: customer.partyId,
                                      );
                                    }
                                  }
                                },

                                onClear: () {
                                  salesTaskController.selectedCustomer.value =
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
                            if (!hideCustomerSourceBiz && !followUpTask)
                              Obx(
                                () => DropdownCustomList<String>(
                                  title: "Source",
                                  hint: "Select Source",
                                  items: salesTaskController.sourceList
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ),
                                      )
                                      .toList(),
                                  selectedValue:
                                      salesTaskController.selectedSource,
                                  onChanged: (value) {
                                    salesTaskController.selectedSource.value =
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
                      if (!hideCustomerSourceBiz && !followUpTask)
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!hideCustomerSourceBiz)
                                Obx(
                                  () => DropdownCustomList<BizCategory>(
                                    title: "Business Opportunity",
                                    hint: "Select Opportunity",
                                    isCompulsory: true,
                                    items: salesTaskController.bizCategoryList
                                        .map(
                                          (item) =>
                                              DropdownMenuItem<BizCategory>(
                                                value: item,
                                                child: Text(item.title ?? ''),
                                              ),
                                        )
                                        .toList(),
                                    selectedValue:
                                        salesTaskController.selectedBizCategory,
                                    onChanged: (value) {
                                      salesTaskController
                                              .selectedBizCategory
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
                              () => DropdownCustomList<EventList>(
                                title: 'Event',
                                isCompulsory: true,
                                hint: "Select Event",
                                items: salesTaskController.eventList
                                    .map(
                                      (item) => DropdownMenuItem<EventList>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedEvent,
                                onChanged: (value) {
                                  salesTaskController.selectedEvent.value =
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
                                items: salesTaskController.statuslist
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedstatus,
                                onChanged: (value) {
                                  salesTaskController.selectedstatus.value =
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
                                title: "Division Category",
                                hint: "Select Category",
                                isCompulsory: true,
                                items: salesTaskController.divisioncategoryList
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedDivision,
                                onChanged: (value) {
                                  salesTaskController.selectedDivision.value =
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
                              () => DropdownCustomList<TargetCategory>(
                                title: "Target Category",
                                hint: "Select Category",
                                isCompulsory: true,
                                items: salesTaskController.targetCategoryList
                                    .map(
                                      (item) =>
                                          DropdownMenuItem<TargetCategory>(
                                            value: item,
                                            child: Text(item.name ?? ''),
                                          ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedTargetCategory,
                                onChanged: (value) {
                                  salesTaskController
                                          .selectedTargetCategory
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
                              controller: salesTaskController.title,
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
                            Obx(
                              () => DropdownCustomList<AssignedTo>(
                                title: 'Assigned To',
                                isCompulsory: true,
                                hint: "Select User",
                                items: salesTaskController.assignedToList
                                    .map(
                                      (item) => DropdownMenuItem<AssignedTo>(
                                        value: item,
                                        child: Text(item.userName ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedAssignedTo,
                                onChanged: (value) {
                                  salesTaskController.selectedAssignedTo.value =
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
                              controller: salesTaskController.tododate,
                              title: 'ToDo Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  salesTaskController.tododate.text =
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
                              controller: salesTaskController.duedate,
                              title: 'Due Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  salesTaskController.duedate.text = DateFormat(
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
                              controller: salesTaskController.description,
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
      //       width: MediaQuery.of(context).size.width * 0.3,
      //       child: ResponsiveButton(
      //         title: isEdit ? 'Update' : 'Save',
      //         function: () async {
      //           Utility.processLoadingWidget();
      //           await salesTaskController.submitSalesTask();
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
              await salesTaskController.submitSalesTask();
            },
          ),
        ),
      ),
    );
  }
}
