import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/support_task_dropdown_model.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/supporttaskeditcontroller.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

class PinnedTaskDrawer extends StatefulWidget {
  final Map<String, dynamic>? row;
  final RxBool isOpen;
  final String screenType;

  const PinnedTaskDrawer({
    super.key,
    required this.row,
    required this.isOpen,
    required this.screenType,
  });

  @override
  State<PinnedTaskDrawer> createState() => _PinnedTaskDrawerState();
}

class _PinnedTaskDrawerState extends State<PinnedTaskDrawer>
    with TickerProviderStateMixin {
  final RxBool isExpanded = true.obs;
  final TextEditingController _descController = TextEditingController();
  Timer? _debounce;
  RxString saveStatus = "Saved".obs;

  final SupportTaskEditController supportController = Get.find();
  final SalesTaskEditController salesTaskController = Get.find();

  @override
  void initState() {
    super.initState();

    _descController.text = widget.row?['description']?.toString() ?? "";

    //Reset dropdowns every time drawer opens
    ever(widget.isOpen, (isOpen) {
      if (isOpen) {
        _resetFromRow();
      }
    });

    //Also set on first open
    _resetFromRow();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _descController.dispose();
    super.dispose();
  }

  void _resetFromRow() {
    final row = widget.row;
    if (row == null) return;
    Future.delayed(const Duration(milliseconds: 300), () {
      // final row = widget.row;
      // if (row == null) return;

      supportController.selectedQueryCategory.value = supportController
          .queryCategoryList
          .firstWhereOrNull((q) => q.categoryid == row['query_category_id']);

      if (supportController.selectedQueryCategory.value != null) {
        supportController.filteredSubQueryCategoryList.value = supportController
            .subQueryCategoryList
            .where(
              (sub) =>
                  sub.categoriesid ==
                  supportController.selectedQueryCategory.value!.categoryid,
            )
            .toList();
      }

      supportController.selectedSubQueryCategory.value = supportController
          .filteredSubQueryCategoryList
          .firstWhereOrNull(
            (s) => s.subcategoryid == row['subquery_category_id'],
          );

      supportController.selectedOwnershipCategory.value = supportController
          .ownershipCategoryList
          .firstWhereOrNull(
            (o) => o.categoryid == row['ownership_category_id'],
          );
    });
  }

  void _onChanged(String val) {
    saveStatus.value = "Saving...";

    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      try {
        if (widget.screenType == "support") {
          await supportController.updateDescriptionOnly(val);
        } else {
          await Get.find<SalesTaskEditController>().updateSalesDescriptionOnly(
            val,
          );
        }
      } catch (_) {}

      saveStatus.value = "Saved";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    // return Obx(() {

    return Obx(() {
      if (!widget.isOpen.value) return const SizedBox.shrink();
      // Always read latest row from controller reactively
      final row = widget.screenType == "support"
          ? supportController.editingRowData.value
          : salesTaskController.editingRowData.value;

      // Sync description if changed externally and user not typing
      final newDesc = row?['description']?.toString() ?? '';
      if (_descController.text != newDesc && saveStatus.value == "Saved") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _descController.text = newDesc;
        });
      }
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: 0,
        right: isMobile ? 0 : (widget.isOpen.value ? 0 : -420),
        child: isMobile ? _buildMobile(size) : _buildDesktop(size),
      );
    });
  }

  /// ================= MOBILE =================
  Widget _buildMobile(Size size) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: size.width,
        constraints: isExpanded.value
            ? BoxConstraints(maxHeight: size.height * 0.75)
            : const BoxConstraints(), // 🔥 collapse fix
        child: _cardWrapper(),
      ),
    );
  }

  /// ================= DESKTOP =================
  Widget _buildDesktop(Size size) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: 380,
        margin: const EdgeInsets.all(12),
        constraints: isExpanded.value
            ? BoxConstraints(maxHeight: size.height * 0.8)
            : const BoxConstraints(), // 🔥 collapse fix
        child: _cardWrapper(),
      ),
    );
  }

  /// ================= CARD =================
  Widget _cardWrapper() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        elevation: isExpanded.value ? 12 : 6,
        child: Container(color: Colors.white, child: _buildContent()),
      ),
    );
  }

  /// ================= CONTENT =================
  Widget _buildContent() {
    return Obx(() {
      if (!isExpanded.value) {
        return _buildHeader(); // 🔥 only header
      }

      return Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      );
    });
  }

  Widget _buildHeader() {
    final row = widget.row;

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 20,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: "#TAS${row?['id'] ?? ''}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Tooltip(
                message: "Unpin Task", // 🔥 Hover text for push pin
                child: IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.push_pin, color: Colors.white),
                  onPressed: () => widget.isOpen.value = false,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: isExpanded.value
                    ? "Collapse Card"
                    : "Expand Card", // 🔥 Hover text
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(
                    isExpanded.value ? Icons.minimize : Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => isExpanded.value = !isExpanded.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= BODY =================
  Widget _buildBody() {
    final row = widget.row;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          color: Colors.orange.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "TD: ${row?['tododate']}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  "DD: ${row?['duedate']}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _row("Customer:", row?['customer_name']),
                _row("Agenda:", row?['event_name']),

                const SizedBox(height: 10),
                if (widget.screenType == "sales") ...[
                  Obx(
                    () => DropdownCustomList<String>(
                      title: "Division Category",
                      hint: "Select Division Category",
                      isCompulsory: true,
                      items: salesTaskController.divisioncategoryList
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      selectedValue: salesTaskController.selectedDivision,
                      onChanged: (value) {
                        salesTaskController.selectedDivision.value = value;
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  Obx(
                    () => DropdownCustomList<TargetCategory>(
                      title: "Target Category",
                      hint: "Select Target Category",
                      isCompulsory: true,
                      items: salesTaskController.targetCategoryList
                          .map(
                            (item) => DropdownMenuItem<TargetCategory>(
                              value: item,
                              child: Text(item.name ?? ''),
                            ),
                          )
                          .toList(),
                      selectedValue: salesTaskController.selectedTargetCategory,
                      onChanged: (value) {
                        salesTaskController.selectedTargetCategory.value =
                            value;
                      },
                    ),
                  ),
                ],
                if (widget.screenType == "support") ...[
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<QueryCategory>(
                            title: "Query Category",
                            hint: "Select Query",
                            isCompulsory: true,
                            items: supportController.queryCategoryList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            selectedValue:
                                supportController.selectedQueryCategory,
                            onChanged: supportController.onQueryCategoryChanged,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<SubQueryCategory>(
                            title: "Sub Query",
                            hint: "Select Sub Query",
                            isCompulsory: true,
                            items: supportController
                                .filteredSubQueryCategoryList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            selectedValue:
                                supportController.selectedSubQueryCategory,
                            onChanged: (v) =>
                                supportController
                                        .selectedSubQueryCategory
                                        .value =
                                    v,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => DropdownCustomList<OwnershipCategory>(
                      title: "Pending Ownership",
                      hint: "Select Ownership",
                      isCompulsory: true,
                      items: supportController.ownershipCategoryList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.name ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      selectedValue:
                          supportController.selectedOwnershipCategory,
                      onChanged: (v) =>
                          supportController.selectedOwnershipCategory.value = v,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: "Call Remark",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          children: [
                            TextSpan(
                              text: " *",
                              style: TextStyle(
                                color: Colors.red, // red asterisk
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      Expanded(
                        child: TextField(
                          controller: _descController,
                          expands: true,
                          maxLines: null,
                          onChanged: _onChanged,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Enter remark...",
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                          ), // match text size
                        ),
                      ),

                      const SizedBox(height: 6),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(
                          () => Text(
                            saveStatus.value,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1.0),
                      const SizedBox(height: 5),

                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.black,
                      //       foregroundColor: Colors.white,
                      //     ),
                      //     onPressed: () async {
                      //       if (widget.screenType == "support") {
                      //         await supportController.updateMarkStatusOnly('2');
                      //       } else {
                      //         await salesTaskController.updateSalesmarkStatusOnly('2');
                      //       }
                      //     },
                      //     child: const Text("Mark as Completed"),
                      //   ),
                      // ),
                      _buildMarkButtonOrText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarkButtonOrText() {
    final rowStatus = widget.row?['status']?.toString() ?? "";

    if (rowStatus != "2") {
      // Show the button
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            if (widget.screenType == "support") {
              await supportController.updateMarkStatusOnly('2');
            } else {
              await salesTaskController.updateSalesmarkStatusOnly('2');
            }
          },
          child: const Text("Mark as Completed"),
        ),
      );
    } else {
      // Show completed text
      return Align(
        alignment: Alignment.centerRight,
        child: Text(
          "This task is completed",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 13,
          ),
        ),
      );
    }
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
