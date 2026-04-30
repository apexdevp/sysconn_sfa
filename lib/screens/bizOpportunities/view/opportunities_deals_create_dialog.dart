// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_create_controller.dart';

// class OpportunitiesDealsCreateDialog extends StatelessWidget {
//   OpportunitiesDealsCreateDialog({super.key});

//   final controller = Get.find<OpportunitiesDealsEditController>();

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         constraints: const BoxConstraints(maxHeight: 650),

//         child: Column(
//           children: [

//             /// HEADER
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   controller.isEdit
//                       ? "Update Opportunity"
//                       : "Add Opportunity",
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   onPressed: () => Get.back(),
//                   icon: const Icon(Icons.close),
//                 )
//               ],
//             ),

//             const Divider(),

//             /// BODY
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [

//                     /// CUSTOMER
//                     // Obx(() {
//                     //   return 
//                       TextField(
//                         controller: controller.retailerName,
//                         decoration: const InputDecoration(
//                           labelText: "Customer",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     // }),

//                     const SizedBox(height: 10),

//                     /// PRODUCT
//                     TextField(
//                       controller: controller.productDesc,
//                       decoration: const InputDecoration(
//                         labelText: "Product",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     /// QTY + RATE
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: controller.qtyController,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: "Qty",
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Obx(() => TextField(
//                                 controller: controller.rateController,
//                                 keyboardType: TextInputType.number,
//                                 readOnly:
//                                     !controller.isRateEditable.value,
//                                 decoration: InputDecoration(
//                                   labelText: "Rate",
//                                   border: const OutlineInputBorder(),
//                                   fillColor:
//                                       controller.isRateEditable.value
//                                           ? Colors.white
//                                           : Colors.grey.shade200,
//                                   filled: true,
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 10),

//                     /// TOTAL
//                     TextField(
//                       controller: controller.totalController,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         labelText: "Total",
//                         border: const OutlineInputBorder(),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     /// STAGE
//                     Obx(() {
//                       return DropdownButtonFormField<int>(
//                         value: controller.selectedStageId.value,
//                         decoration: const InputDecoration(
//                           labelText: "Stage",
//                           border: OutlineInputBorder(),
//                         ),
//                         items: controller.stageList.entries
//                             .map((e) => DropdownMenuItem(
//                                   value: e.key,
//                                   child: Text(e.value),
//                                 ))
//                             .toList(),
//                         onChanged: (val) =>
//                             controller.selectedStageId.value = val,
//                       );
//                     }),

//                     const SizedBox(height: 10),

//                     /// STATUS
//                     Obx(() {
//                       return DropdownButtonFormField<int>(
//                         value: controller.selectedStatusId.value,
//                         decoration: const InputDecoration(
//                           labelText: "Status",
//                           border: OutlineInputBorder(),
//                         ),
//                         items: controller.statusList.entries
//                             .map((e) => DropdownMenuItem(
//                                   value: e.key,
//                                   child: Text(e.value),
//                                 ))
//                             .toList(),
//                         onChanged: (val) =>
//                             controller.selectedStatusId.value = val,
//                       );
//                     }),

//                     const SizedBox(height: 10),

//                     /// PRIORITY
//                     Obx(() {
//                       return DropdownButtonFormField<String>(
//                         value: controller.selectedPriority.value,
//                         decoration: const InputDecoration(
//                           labelText: "Priority",
//                           border: OutlineInputBorder(),
//                         ),
//                         items: controller.arrPriority
//                             .map((e) => DropdownMenuItem(
//                                   value: e,
//                                   child: Text(e),
//                                 ))
//                             .toList(),
//                         onChanged: (val) =>
//                             controller.selectedPriority.value = val,
//                       );
//                     }),

//                     const SizedBox(height: 10),

//                     /// TITLE
//                     TextField(
//                       controller: controller.title,
//                       decoration: const InputDecoration(
//                         labelText: "User Remark",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     /// DESCRIPTION
//                     TextField(
//                       controller: controller.description,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: "Customer Remark",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             /// BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await controller.saveOpportunitiesApi();
//                 },
//                 child: Text(controller.isEdit ? "Update" : "Save"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_product_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/party_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_create_controller.dart';

class OpportunitiesDealsCreateDialog extends StatelessWidget {
  OpportunitiesDealsCreateDialog({super.key});

  final controller = Get.find<OpportunitiesDealsEditController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [

            // ── Header ────────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Obx(() => Text(
                Flexible(
                    child: Text(
                      controller.isEdit
                          ? "Update Biz Opportunity"
                          : "Add Biz Opportunity",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Divider(height: 1),
            const SizedBox(height: 8),

            // ── Body ──────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Customer (hidden in edit mode & partyMasterAdd) ──────
                    Obx(() {
                      final hide = controller.isEdit ||
                          controller.partyMasterAdd.value;
                      if (hide) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SearchableField(
                            label: "Customer *",
                            hint: "Search Customer",
                            displayText: controller
                                    .selectedCustomer.value?.partyName ??
                                '',
                            onSearch: (query) async {
                              await controller.customerListData(query);
                              return controller.partyEntityList
                                  .map((e) => e.partyName ?? '')
                                  .toList();
                            },
                            onSelected: (value) {
                              final customer = controller.partyEntityList
                                  .firstWhereOrNull(
                                      (e) => e.partyName == value);
                              if (customer != null) {
                                controller.selectedCustomer.value = customer;
                                controller.retailerName.text =
                                    customer.partyName ?? '';
                                controller.retailerCode.text =
                                    customer.partyId ?? '';
                                controller.customerPriceList =
                                    customer.pricelist;
                              }
                            },
                            onClear: () {
                              controller.selectedCustomer.value = null;
                              controller.retailerName.clear();
                              controller.retailerCode.clear();
                              controller.customerPriceList = null;
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),

                    // ── Product ──────────────────────────────────────────────
                    Obx(() => _SearchableField(
                          label: "Product *",
                          hint: "Search Product",
                          displayText: controller
                                  .selectedProduct.value?.productDesc ??
                              '',
                          onSearch: (query) async {
                            await controller.itemsListData(query);
                            return controller.stockItemList
                                .map((e) => e.itemName ?? '')
                                .toList();
                          },
                          onSelected: (value) {
                            final stock = controller.stockItemList
                                .firstWhereOrNull(
                                    (e) => e.itemName == value);
                            if (stock != null) {
                              final product = OpportunitiesProductEntity()
                                ..productCode = stock.itemId
                                ..productDesc = stock.itemName;
                              controller.selectedProduct.value = product;
                              controller.productDesc.text =
                                  stock.itemName ?? '';
                              controller.productCode.text =
                                  stock.itemId ?? '';

                              if (stock.priceListRate != null &&
                                  stock.priceListRate!.isNotEmpty) {
                                controller.rateController.text =
                                    stock.priceListRate?.trim() ?? '0';
                                controller.isRateEditable.value = false;
                              } else {
                                controller.rateController.text = '';
                                controller.isRateEditable.value = true;
                              }
                            }
                          },
                          onClear: () {
                            controller.selectedProduct.value = null;
                            controller.productDesc.clear();
                            controller.productCode.clear();
                            controller.rateController.clear();
                            controller.isRateEditable.value = true;
                          },
                        )),

                    const SizedBox(height: 12),

                    // ── Source ───────────────────────────────────────────────
                    Obx(() => _DropdownField<int>(
                          label: "Source",
                          hint: "Select Source",
                          value: controller.selectedSourceId.value,
                          items: controller.sourceList.entries
                              .map((e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.value),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              controller.selectedSourceId.value = val,
                        )),

                    const SizedBox(height: 12),

                    // ── Stage + Status ───────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _DropdownField<int>(
                                label: "Stage",
                                hint: "Select Stage",
                                value: controller.selectedStageId.value,
                                items: controller.stageList.entries
                                    .map((e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    controller.selectedStageId.value = val,
                              )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _DropdownField<int>(
                                label: "Status",
                                hint: "Select Status",
                                value: controller.selectedStatusId.value,
                                items: controller.statusList.entries
                                    .map((e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    controller.selectedStatusId.value = val,
                              )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Qty + Rate + Total ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            label: "Quantity *",
                            hint: "Enter Quantity",
                            controller: controller.qtyController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() => _InputField(
                                label: "Rate *",
                                hint: "Enter Rate",
                                controller: controller.rateController,
                                keyboardType: TextInputType.number,
                                readOnly:
                                    !controller.isRateEditable.value,
                                fillColor: controller.isRateEditable.value
                                    ? Colors.white
                                    : Colors.grey.shade200,
                              )),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InputField(
                            label: "Total *",
                            hint: "Total",
                            controller: controller.totalController,
                            readOnly: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── User Remark + Priority ───────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            label: "User Remark",
                            hint: "Enter User Remark",
                            controller: controller.title,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Obx(() => _DropdownField<String>(
                                label: "Priority *",
                                hint: "Select Priority",
                                value: controller.selectedPriority.value,
                                items: controller.arrPriority
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    controller.selectedPriority.value = val,
                              )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Customer Remark ──────────────────────────────────────
                    _InputField(
                      label: "Customer Remark",
                      hint: "Enter Customer Remark",
                      controller: controller.description,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Save / Update Button ──────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 46,
              child: 
              //Obx(() => ElevatedButton(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      await controller.saveOpportunitiesApi();
                    },
                    child: Text(
                      controller.isEdit ? "Update" : "Save",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable: plain text field
// ─────────────────────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final Color? fillColor;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.fillColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: fillColor != null,
        fillColor: fillColor,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable: simple dropdown field
// ─────────────────────────────────────────────────────────────────────────────
class _DropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable: searchable field that opens a bottom sheet
// Matches web's DropdownCustomList with onSearchApi
// ─────────────────────────────────────────────────────────────────────────────
class _SearchableField extends StatefulWidget {
  final String label;
  final String hint;
  final String displayText;
  final Future<List<String>> Function(String query) onSearch;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _SearchableField({
    required this.label,
    required this.hint,
    required this.displayText,
    required this.onSearch,
    required this.onSelected,
    required this.onClear,
  });

  @override
  State<_SearchableField> createState() => _SearchableFieldState();
}

class _SearchableFieldState extends State<_SearchableField> {

  void _openSearch() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _SearchBottomSheet(
        label: widget.label,
        hint: widget.hint,
        onSearch: widget.onSearch,
        onSelected: (value) {
          widget.onSelected(value);
          Navigator.of(context).pop();
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.displayText.isNotEmpty;

    return GestureDetector(
      onTap: _openSearch,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          suffixIcon: hasValue
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    widget.onClear();
                    setState(() {});
                  },
                )
              : const Icon(Icons.search, size: 18),
        ),
        child: Text(
          hasValue ? widget.displayText : widget.hint,
          style: TextStyle(
            color: hasValue
                ? Theme.of(context).textTheme.bodyMedium?.color
                : Colors.grey,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet with live search
// ─────────────────────────────────────────────────────────────────────────────
class _SearchBottomSheet extends StatefulWidget {
  final String label;
  final String hint;
  final Future<List<String>> Function(String) onSearch;
  final ValueChanged<String> onSelected;

  const _SearchBottomSheet({
    required this.label,
    required this.hint,
    required this.onSearch,
    required this.onSelected,
  });

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final _searchCtrl = TextEditingController();
  List<String> _results = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onQueryChanged);
  }

  void _onQueryChanged() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    final results = await widget.onSearch(q);
    if (mounted) setState(() { _results = results; _loading = false; });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [

            // Title
            Text(
              widget.label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Search input
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _results = []);
                        })
                    : null,
              ),
            ),

            const SizedBox(height: 8),

            // Results
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            _searchCtrl.text.isEmpty
                                ? "Start typing to search..."
                                : "No results found",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (_, i) => ListTile(
                            title: Text(_results[i]),
                            onTap: () => widget.onSelected(_results[i]),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}