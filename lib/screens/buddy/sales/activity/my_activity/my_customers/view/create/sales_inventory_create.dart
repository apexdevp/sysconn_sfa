import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// ── Theme ────────────────────────────────────────────────────────────────────
const _kRed    = Color(0xFFD32F2F);
const _kOrange = Color.fromARGB(255, 241, 111, 4);
const _kBg     = Color(0xFFF5F6FA);

class SalesInventoryScreen extends StatelessWidget {
  final SalesInventoryEntity? salesInventoryEntity;

  const SalesInventoryScreen({super.key, this.salesInventoryEntity});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SalesController(isEdit: salesInventoryEntity != null),
    );

    // ── PREFILL ──
    if (salesInventoryEntity != null) {
      controller.salesInvEntity.value = salesInventoryEntity!;
      controller.itemName.value = salesInventoryEntity?.itemName ?? '';
      controller.quantityController.text = salesInventoryEntity?.qty ?? '';
      controller.rateController.text = salesInventoryEntity?.rate ?? '';
      controller.discountController.text =
          salesInventoryEntity?.discount ?? '';
      controller.totalQtyController.text = (
        (double.tryParse(salesInventoryEntity?.qty ?? '0') ?? 0) +
        (double.tryParse(controller.freeQtyController.text) ?? 0)
      ).toString();
    }

    return Scaffold(
      backgroundColor: _kBg,
      appBar: SfaCustomAppbar(
        title: salesInventoryEntity != null
            ? "Edit Inventory"
            : "Add Inventory",
      ),

      // ── BOTTOM SAVE BUTTON ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: SafeArea(
          child: ResponsiveButton(
            title: salesInventoryEntity != null ? "Update" : "Save",
            function: () async {
              Utility.showCircularLoadingWid(context);
              await controller.salesItemPost(
                itemSelectedEntity: controller.salesInvEntity.value,
              );
              Get.back(result: true);
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── SECTION: Item ──────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.inventory_2_outlined,
              label: 'Item Details',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Name dropdown
                  Row(
                    children: [
                      Expanded(
                        child: DropdownCustomList(
                          isCompulsory: true,
                          title: "Item Name",
                          items: const [],
                          selectedValue: controller.itemName,
                          onSearchApi: (query) async {
                            await controller.itemsListData(query);
                            return controller.stockItemList
                                .map((e) => DropdownMenuItem(
                                      value: e.itemName,
                                      child: Text(e.itemName!),
                                    ))
                                .toList();
                          },
                          onChanged: (value) {
                            final item = controller.stockItemList
                                .firstWhere((e) => e.itemName == value);
                            controller.itemName.value = item.itemName!;
                            controller.salesInvEntity.value.itemId =
                                item.itemId;
                            controller.salesInvEntity.value.itemName =
                                item.itemName;
                            controller.salesInvEntity.value.gstrate =
                                item.taxRate;
                            controller.rateController.text =
                                item.priceListRate?.toString() ?? '';
                            controller.discountController.text =
                                item.priceListDiscount?.toString() ?? '';
                          },
                          onClear: () {
                            controller.itemName.value = '';
                            controller.rateController.clear();
                            controller.discountController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── SECTION: Pricing ───────────────────────────────────────────
            _SectionHeader(
              icon: Icons.price_change_outlined,
              label: 'Pricing & Quantity',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Qty + Rate
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        isCompulsory: true,
                        title: "Quantity",
                        controller: controller.quantityController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) =>
                            controller.calculateInventoryTotal(),
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormFieldView(
                        isCompulsory: true,
                        title: "Rate",
                        controller: controller.rateController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) =>
                            controller.calculateInventoryTotal(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Discount + Free Qty + Total Qty
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        title: "Discount %",
                        controller: controller.discountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) =>
                            controller.calculateInventoryTotal(),
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormFieldView(
                        title: "Free Qty",
                        controller: controller.freeQtyController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) =>
                            controller.calculateInventoryTotal(),
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormFieldView(
                        title: "Total Qty",
                        controller: controller.totalQtyController,
                        enabled: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── SECTION: Remark ────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.notes_outlined,
              label: 'Remark',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Row(
                children: [
                  CustomTextFormFieldView(
                    title: "Remark",
                    maxLines: 3,
                    controller: controller.remarkController,
                    onChanged: (v) =>
                        controller.salesInvEntity.value.remark = v,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── AMOUNT SUMMARY ─────────────────────────────────────────────
            Obx(() {
              final totalVal = controller.salesInvEntity.value.totalvalue;
              final amount = double.tryParse(totalVal ?? '0') ?? 0.0;
              final netVal = controller.salesInvEntity.value.netValue;
              final net = double.tryParse(netVal ?? '0') ?? 0.0;
              final gstVal = controller.salesInvEntity.value.gstvalue;
              final gst = double.tryParse(gstVal ?? '0') ?? 0.0;

              if (amount == 0) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_kOrange,_kRed, ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _kRed.withOpacity(0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calculate_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Amount Summary',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Divider(
                        color: Colors.white.withOpacity(0.3), height: 1),
                    const SizedBox(height: 12),

                    // Net value
                    _AmountRow(label: 'Net Value', value: net),
                    const SizedBox(height: 6),
                    _AmountRow(label: 'GST', value: gst),
                    const SizedBox(height: 10),
                    Divider(
                        color: Colors.white.withOpacity(0.3), height: 1),
                    const SizedBox(height: 10),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹ ${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AMOUNT ROW — used inside summary card
// ═══════════════════════════════════════════════════════════════

class _AmountRow extends StatelessWidget {
  final String label;
  final double value;

  const _AmountRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// White card container
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

/// Section header: orange icon pill + bold label
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.orange),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Field label with optional required asterisk
class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FieldLabel({required this.label, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              color: Colors.red.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/widgets/responsive_button.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
// import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// class SalesInventoryScreen extends StatelessWidget {
//   final SalesInventoryEntity? salesInventoryEntity;

//   const SalesInventoryScreen({super.key, this.salesInventoryEntity});

  

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//     SalesController(isEdit: salesInventoryEntity != null),
//   );

//   ///  PREFILL (IMPORTANT)
//   if (salesInventoryEntity != null) {
//     controller.salesInvEntity.value = salesInventoryEntity!;

//     controller.itemName.value = salesInventoryEntity?.itemName ?? '';
//     controller.quantityController.text = salesInventoryEntity?.qty ?? '';
//     controller.rateController.text = salesInventoryEntity?.rate ?? '';
//     controller.discountController.text = salesInventoryEntity?.discount ?? '';
//     controller.totalQtyController.text =
//     (
//       (double.tryParse(salesInventoryEntity?.qty ?? '0') ?? 0) +
//       (double.tryParse(controller.freeQtyController.text) ?? 0)
//     ).toString();
//   }
//     return Scaffold(
//       appBar: SfaCustomAppbar(title: "Inventory Details"),

//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ResponsiveButton(
//           function:  () async {
//             Utility.showCircularLoadingWid(context);
//             await controller.salesItemPost(
//   itemSelectedEntity: controller.salesInvEntity.value,
// );
//           //   await controller.salesItemPost(
//           //   itemSelectedEntity: salesInventoryEntity!//controller.salesInvEntity.value,
//           // );
//             Get.back(result: true);
//           },
//           title:  "Save",
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),

//         child: Column(
//           children: [

//             /// ================= ITEM =================
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownCustomList(
//                         title: "Item Name",
//                         items: const [],

//                         selectedValue: controller.itemName,

//                         onSearchApi: (query) async {
//                           await controller.itemsListData(query);
//                           return controller.stockItemList
//                               .map((e) => DropdownMenuItem(
//                                     value: e.itemName,
//                                     child: Text(e.itemName!),
//                                   ))
//                               .toList();
//                         },

//                         onChanged: (value) {
//                           final item = controller.stockItemList
//                               .firstWhere((e) => e.itemName == value);

//                           controller.itemName.value = item.itemName!;

//                           controller.salesInvEntity.value.itemId = item.itemId;
//                           controller.salesInvEntity.value.itemName = item.itemName;
//                           controller.salesInvEntity.value.gstrate = item.taxRate;

//                           controller.rateController.text =
//                               item.priceListRate?.toString() ?? "";

//                           controller.discountController.text =
//                               item.priceListDiscount?.toString() ?? "";
//                         },

//                         onClear: () {
//                           controller.itemName.value = "";
//                           controller.rateController.clear();
//                           controller.discountController.clear();
//                         },
//                       ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ================= QTY / RATE =================
//             Row(
//               children: [

//                 CustomTextFormFieldView(
//                   title: "Quantity",
//                   controller: controller.quantityController,
//                   keyboardType: TextInputType.number,
//                   onChanged: (_) => controller.calculateInventoryTotal(),
//                 ),

//                 const SizedBox(width: 10),

//                 CustomTextFormFieldView(
//                   title: "Rate",
//                   controller: controller.rateController,
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ================= DISCOUNT =================
//             Row(
//               children: [

//                 CustomTextFormFieldView(
//                   title: "Discount",
//                   controller: controller.discountController,
//                   keyboardType: TextInputType.number,
//                 ),

//                 const SizedBox(width: 10),

//                 CustomTextFormFieldView(
//                   title: "Free Qty",
//                   controller: controller.freeQtyController,
//                   keyboardType: TextInputType.number,
//                   onChanged: (_) => controller.calculateInventoryTotal(),
//                 ),

//                 const SizedBox(width: 10),

//                 CustomTextFormFieldView(
//                   title: "Total Qty",
//                   controller: controller.totalQtyController,
//                   enabled: false,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ================= REMARK =================
//             Row(
//               children: [
//                 CustomTextFormFieldView(
//                   title: "Remark",
//                   maxLines: 3,
//                   controller: controller.remarkController,
//                   onChanged: (v) => controller.salesInvEntity.value.remark = v,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ================= AMOUNT =================
//             Obx(() => Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     "Amount: ${controller.salesInvEntity.value.totalvalue ?? 0}",
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }