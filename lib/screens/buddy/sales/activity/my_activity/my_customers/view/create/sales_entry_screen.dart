import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/additional_details.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_inventory_create.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_ledger_create.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';

class SalesCreateScreen extends StatelessWidget {
  final String? hedId;
  final String? vchType;
  final bool isEdit;
  final String? partyId;

  const SalesCreateScreen({
    super.key,
    this.hedId,
    this.vchType,
    required this.isEdit,
    this.partyId,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      SalesController(
        hedId: hedId,
        vchType: vchType,
        isEdit: isEdit,
        partyId: partyId,
      ),
    );

    return WillPopScope(
      onWillPop: c.onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: SfaCustomAppbar(
          title:
              "${c.isTallyEntry.value ? 'Display' : hedId == null ? 'Create' : 'Update'} ${vchType ?? 'Sales'}",
        ),
        body: Obx(() {
          if (c.isDataLoad.value == 0) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ─────────────────────────────────────────────────────
              // SCROLLABLE AREA
              // KEY FIX: Expanded wraps only the ScrollView.
              // Every child inside uses mainAxisSize: min — never Expanded.
              // Inner lists use shrinkWrap:true + NeverScrollableScrollPhysics.
              // ─────────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ← critical
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      hedId == null
                          ? _CreateHeaderCard(c: c)
                          : _EditHeaderCard(c: c),

                      const SizedBox(height: 12),

                      // Inventory
                      _InventorySection(c: c),

                      const SizedBox(height: 12),

                      // Ledger — visible only after header is saved
                      Obx(() {
                        if (c.salesHeaderEntity.value != null &&
                            c.hedId != null) {
                          return _LedgerSection(c: c);
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),

              // ─────────────────────────────────────────────────────
              // FIXED BOTTOM BUTTON
              // ─────────────────────────────────────────────────────
              Obx(() {
                if (c.salesHeaderEntity.value == null) {
                  return const SizedBox.shrink();
                }
                return _BottomActionBar(
                  label: 'Proceed To Buy',
                  onTap: () async {
                    Utility.showCircularLoadingWid(context);
                    await Get.to(() => AdditionalDetailsScreen(
                          salesHeaderEntity: c.salesHeaderEntity.value!,
                        ));
                  },
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CREATE HEADER CARD
// ═══════════════════════════════════════════════════════════════

class _CreateHeaderCard extends StatelessWidget {
  final SalesController c;
  const _CreateHeaderCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min, // ← no unbounded expansion
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.orange.shade700),
                const SizedBox(width: 6),
                Obx(() => Text(
                      DateFormat('dd MMM yyyy')
                          .format(c.selectedDate.value),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Voucher
          _FieldLabel(label: 'Voucher Name', isRequired: true),
          const SizedBox(height: 4),
          Obx(() => DropdownCustomList<VoucherEntity>(
                title: "Voucher Name",
                hint: "Select Voucher",
                items: c.vchEntityList
                    .map((item) => DropdownMenuItem<VoucherEntity>(
                          value: item,
                          child: Text(item.vchTypeName ?? ''),
                        ))
                    .toList(),
                selectedValue: c.voucherEntitySelected,
                onChanged: (value) => c.setVoucher(value!),
              )),

          const SizedBox(height: 10),

          // Party
          _FieldLabel(label: 'Party Name', isRequired: true),
          const SizedBox(height: 4),
          DropdownCustomList(
            title: "Party Name",
            items: const [],
            selectedValue: c.partySelectedName,
            onSearchApi: (query) async {
              await c.customerListData(query);
              return c.partyEntityList
                  .where((e) => e.partyName!
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .map<DropdownMenuItem<String>>((e) =>
                      DropdownMenuItem<String>(
                        value: e.partyName,
                        child: Text(e.partyName!),
                      ))
                  .toList();
            },
            onChanged: (value) {
              final selected = c.partyEntityList
                  .firstWhere((e) => e.partyName == value);
              c.setParty(selected);
              c.partySelectedName.value = selected.partyName!;
            },
            onClear: () {
              c.partySelectedName.value = '';
              c.salesHeaderEntity.value = null;
            },
          ),

          const SizedBox(height: 10),

          // Payment Terms — Row so CustomTextFormFieldView gets a bounded width
          _FieldLabel(label: 'Payment Terms'),
          const SizedBox(height: 4),
          Row(children: [
            CustomTextFormFieldView(
              controller: c.paymentTermsController,
              title: 'Payment Terms',
            ),
          ]),

          const SizedBox(height: 10),

          // Remark
          _FieldLabel(label: 'Remark'),
          const SizedBox(height: 4),
          Row(children: [
            CustomTextFormFieldView(
              controller: c.remarkController,
              title: 'Remark',
              maxLines: 3,
            ),
          ]),

          const SizedBox(height: 16),

          // Next button — hidden once header exists
          Obx(() {
            if (c.salesHeaderEntity.value != null) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              width: double.infinity,
              child: ResponsiveButton(
                title: 'Next',
                function: () async {
                  Utility.showCircularLoadingWid(context);
                  await c.salesHeaderPostApi();
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EDIT HEADER CARD
// ═══════════════════════════════════════════════════════════════

class _EditHeaderCard extends StatelessWidget {
  final SalesController c;
  const _EditHeaderCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon pill
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Icon(Icons.store_outlined,
                    color: Colors.orange, size: 22),
              ),

              const SizedBox(width: 12),

              // Party + invoice + date
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          c.partySelectedName.value,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                    const SizedBox(height: 4),
                    Obx(() => _InfoChip(
                          icon: Icons.receipt_outlined,
                          label:
                              'Invoice: ${c.salesHeaderEntity.value?.invoiceNo ?? '—'}',
                        )),
                    const SizedBox(height: 4),
                    Obx(() => _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: DateFormat('dd MMM yyyy')
                              .format(c.selectedDate.value),
                        )),
                  ],
                ),
              ),

              // Delete
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red),
                tooltip: 'Delete Entry',
                onPressed: () => Utility.showAlertYesNo(
                  title: "Delete Entry",
                  msg:
                      "Are you sure you want to delete this entry?",
                  yesBtnFun: () => c.deleteAllSalesApi(),
                  noBtnFun: () => Get.back(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(children: [
            CustomTextFormFieldView(
              controller: c.remarkController,
              title: 'Narration',
              maxLines: 2,
            ),
          ]),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INVENTORY SECTION
// ═══════════════════════════════════════════════════════════════

class _InventorySection extends StatelessWidget {
  final SalesController c;
  const _InventorySection({required this.c});

  void _navigateInventory({SalesInventoryEntity? data}) async {
    await Get.to(() => SalesInventoryScreen(salesInventoryEntity: data));
    // isInvClicked:true keeps salesHeaderEntity intact during refresh
    await c.getSalesDataAPI(isInvClicked: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final header = c.salesHeaderEntity.value;
      if (header == null && c.hedId == null) {
        return const SizedBox.shrink();
      }

      final items = header?.items ?? [];

      return Column(
        mainAxisSize: MainAxisSize.min, // ← no Expanded inside scroll
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.inventory_2_outlined,
            label: 'Inventory Details',
            onAdd: () => _navigateInventory(),
          ),
          const SizedBox(height: 8),
          _SectionCard(
            padding: EdgeInsets.zero,
            child: items.isEmpty
                ? const _EmptyState(
                    icon: Icons.inventory_2_outlined,
                    message: 'No inventory added yet',
                  )
                : ListView.separated(
                    // shrinkWrap + Never = safe inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16),
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      final amount =
                          double.tryParse(item.totalvalue ?? '0') ?? 0;
                      return _InventoryRow(
                        item: item,
                        amount: amount,
                        onEdit: () => _navigateInventory(data: item),
                        // onDelete: () async {
                        //   await c.deleteItemPostApi(
                        //       invId: item.invId ?? '');
                        //   c.salesHeaderEntity.refresh();
                        // },
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}

class _InventoryRow extends StatelessWidget {
  final dynamic item;
  final double amount;
  final VoidCallback onEdit;
  // final VoidCallback onDelete;

  const _InventoryRow({
    required this.item,
    required this.amount,
    required this.onEdit,
    // required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Orange dot
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Wrap prevents overflow when chips don't fit one line
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _MiniChip(label: 'Qty: ${item.qty ?? 0}'),
                      _MiniChip(label: 'Rate: ${item.rate ?? 0}'),
                      _MiniChip(label: 'Disc: ${item.discount ?? 0}%'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount + actions — Column with mainAxisSize.min, NOT Expanded
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  indianRupeeFormat(amount),
                  style: kTxtStl13B,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        onEdit();
        //     _navigateInventory(data: item);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// LEDGER SECTION
// ═══════════════════════════════════════════════════════════════

class _LedgerSection extends StatelessWidget {
  final SalesController c;
  const _LedgerSection({required this.c});

  void _navigateLedger({SalesLedgerEntity? data}) async {
    await Get.to(() => SalesLedgerScreen(salesLedgerEntity: data));
    // isInvClicked:true keeps salesHeaderEntity intact during refresh
    await c.getSalesDataAPI(isInvClicked: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Ledger Details',
          onAdd: () => _navigateLedger(),
        ),
        const SizedBox(height: 8),
        _SectionCard(
          padding: EdgeInsets.zero,
          child: Obx(() {
            final ledgerList = c.salesLedgerList;
            if (ledgerList.isEmpty) {
              return const _EmptyState(
                icon: Icons.account_balance_wallet_outlined,
                message: 'No ledger entries added',
              );
            }
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ledgerList.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 16,
                  endIndent: 16),
              itemBuilder: (ctx, i) {
                final ledger = ledgerList[i];
                final amount =
                    double.tryParse(ledger.amount ?? '0') ?? 0;
                return _LedgerRow(
                  ledger: ledger,
                  amount: amount,
                  onEdit: () => _navigateLedger(data: ledger),
                  // onDelete: () => Utility.showAlertYesNo(
                  //   title: 'Delete Ledger',
                  //   msg: 'Delete "${ledger.ledgerName}"?',
                  //   yesBtnFun: () async {
                  //     Utility.showCircularLoadingWid(context);
                  //     await c.deleteLedgerPostApi(ledger);
                  //     Get.back();
                  //   },
                  //   noBtnFun: () => Get.back(),
                  // ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  final SalesLedgerEntity ledger;
  final double amount;
  final VoidCallback onEdit;
  // final VoidCallback onDelete;

  const _LedgerRow({
    required this.ledger,
    required this.amount,
    required this.onEdit,
    // required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ledger.ledgerName ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              indianRupeeFormat(amount),
              style:kTxtStl13B
            ),
            // const SizedBox(width: 4),
            // _ActionIconBtn(
            //     icon: Icons.edit_outlined,
            //     color: Colors.green,
            //     onTap: onEdit),
            // _ActionIconBtn(
            //     icon: Icons.delete_outline,
            //     color: Colors.red,
            //     onTap: onDelete),
          ],
        ),
      ),
      onTap: () {
        onEdit();
      },
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// BOTTOM ACTION BAR
// ═══════════════════════════════════════════════════════════════

class _BottomActionBar extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BottomActionBar({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: ResponsiveButton(title: label, function: onTap),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

/// White card container — no inner Expanded ever
class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _SectionCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Section header: icon + title + Add pill
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onAdd;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.onAdd,
  });

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
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: Colors.red.shade600),
                const SizedBox(width: 4),
                Text('Add',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(label,
            style:
                TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style:
              TextStyle(fontSize: 10, color: Colors.grey.shade700)),
    );
  }
}

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconBtn(
      {required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

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
              color: Colors.grey.shade700),
        ),
        if (isRequired)
          Text(' *',
              style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(message,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
// import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/additional_details.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_inventory_create.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_ledger_create.dart';
// import 'package:sysconn_sfa/widgets/responsive_button.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
// import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';

// class SalesCreateScreen extends StatelessWidget {
//   final String? hedId;
//   final String? vchType;
//   final bool isEdit;
//   final String? partyId;

//   const SalesCreateScreen({
//     super.key,
//     this.hedId,
//     this.vchType,
//     required this.isEdit,
//     this.partyId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final c = Get.put(
//       SalesController(
//         hedId: hedId,
//         vchType: vchType,
//         isEdit: isEdit,
//         partyId: partyId,
//       ),
//     );

//     return WillPopScope(
//       onWillPop: c.onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F6FA),
//         appBar: SfaCustomAppbar(
//           title:
//               "${c.isTallyEntry.value
//                   ? 'Display'
//                   : hedId == null
//                   ? 'Create'
//                   : 'Update'} ${vchType ?? 'Sales'}",
//         ),
//         body: Obx(() {
//           if (c.isDataLoad.value == 0) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Column(
//             children: [
//               // ─────────────────────────────────────────────────────
//               // SCROLLABLE AREA
//               // KEY FIX: Expanded wraps only the ScrollView.
//               // Every child inside uses mainAxisSize: min — never Expanded.
//               // Inner lists use shrinkWrap:true + NeverScrollableScrollPhysics.
//               // ─────────────────────────────────────────────────────
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min, // ← critical
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       hedId == null
//                           ? _CreateHeaderCard(c: c)
//                           : _EditHeaderCard(c: c),

//                       const SizedBox(height: 12),

//                       // Inventory
//                       _InventorySection(c: c),

//                       const SizedBox(height: 12),

//                       // Ledger — visible only after header is saved
//                       Obx(() {
//                         if (c.salesHeaderEntity.value != null &&
//                             c.hedId != null) {
//                           return _LedgerSection(c: c);
//                         }
//                         return const SizedBox.shrink();
//                       }),
//                     ],
//                   ),
//                 ),
//               ),

//               // ─────────────────────────────────────────────────────
//               // FIXED BOTTOM BUTTON
//               // ─────────────────────────────────────────────────────
//               Obx(() {
//                 if (c.salesHeaderEntity.value == null) {
//                   return const SizedBox.shrink();
//                 }
//                 return _BottomActionBar(
//                   label: 'Proceed To Buy',
//                   onTap: () async {
//                     Utility.showCircularLoadingWid(context);
//                     await Get.to(
//                       () => AdditionalDetailsScreen(
//                         salesHeaderEntity: c.salesHeaderEntity.value!,
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // CREATE HEADER CARD
// // ═══════════════════════════════════════════════════════════════

// class _CreateHeaderCard extends StatelessWidget {
//   final SalesController c;
//   const _CreateHeaderCard({required this.c});

//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // ← no unbounded expansion
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Date pill
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.orange.shade100),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.calendar_today_outlined,
//                   size: 14,
//                   color: Colors.orange.shade700,
//                 ),
//                 const SizedBox(width: 6),
//                 Obx(
//                   () => Text(
//                     DateFormat('dd MMM yyyy').format(c.selectedDate.value),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.orange.shade800,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           // Voucher
//           _FieldLabel(label: 'Voucher Name', isRequired: true),
//           const SizedBox(height: 4),
//           Obx(
//             () => DropdownCustomList<VoucherEntity>(
//               title: "Voucher Name",
//               hint: "Select Voucher",
//               items: c.vchEntityList
//                   .map(
//                     (item) => DropdownMenuItem<VoucherEntity>(
//                       value: item,
//                       child: Text(item.vchTypeName ?? ''),
//                     ),
//                   )
//                   .toList(),
//               selectedValue: c.voucherEntitySelected,
//               onChanged: (value) => c.setVoucher(value!),
//             ),
//           ),

//           const SizedBox(height: 10),

//           // Party
//           _FieldLabel(label: 'Party Name', isRequired: true),
//           const SizedBox(height: 4),
//           DropdownCustomList(
//             title: "Party Name",
//             items: const [],
//             selectedValue: c.partySelectedName,
//             onSearchApi: (query) async {
//               await c.customerListData(query);
//               return c.partyEntityList
//                   .where(
//                     (e) => e.partyName!.toLowerCase().contains(
//                       query.toLowerCase(),
//                     ),
//                   )
//                   .map<DropdownMenuItem<String>>(
//                     (e) => DropdownMenuItem<String>(
//                       value: e.partyName,
//                       child: Text(e.partyName!),
//                     ),
//                   )
//                   .toList();
//             },
//             onChanged: (value) {
//               final selected = c.partyEntityList.firstWhere(
//                 (e) => e.partyName == value,
//               );
//               c.setParty(selected);
//               c.partySelectedName.value = selected.partyName!;
//             },
//             onClear: () {
//               c.partySelectedName.value = '';
//               c.salesHeaderEntity.value = null;
//             },
//           ),

//           const SizedBox(height: 10),

//           // Payment Terms — Row so CustomTextFormFieldView gets a bounded width
//           _FieldLabel(label: 'Payment Terms'),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               CustomTextFormFieldView(
//                 controller: c.paymentTermsController,
//                 title: 'Payment Terms',
//               ),
//             ],
//           ),

//           const SizedBox(height: 10),

//           // Remark
//           _FieldLabel(label: 'Remark'),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               CustomTextFormFieldView(
//                 controller: c.remarkController,
//                 title: 'Remark',
//                 maxLines: 3,
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // Next button — hidden once header exists
//           Obx(() {
//             if (c.salesHeaderEntity.value != null) {
//               return const SizedBox.shrink();
//             }
//             return SizedBox(
//               width: double.infinity,
//               child: ResponsiveButton(
//                 title: 'Next',
//                 function: () async {
//                   Utility.showCircularLoadingWid(context);
//                   await c.salesHeaderPostApi();
//                 },
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // EDIT HEADER CARD
// // ═══════════════════════════════════════════════════════════════

// class _EditHeaderCard extends StatelessWidget {
//   final SalesController c;
//   const _EditHeaderCard({required this.c});

//   @override
//   Widget build(BuildContext context) {
//     return _SectionCard(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Icon pill
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade50,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.orange.shade100),
//                 ),
//                 child: Icon(
//                   Icons.store_outlined,
//                   color: Colors.orange,
//                   size: 22,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // Party + invoice + date
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Obx(
//                       () => Text(
//                         c.partySelectedName.value,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Obx(
//                       () => _InfoChip(
//                         icon: Icons.receipt_outlined,
//                         label:
//                             'Invoice: ${c.salesHeaderEntity.value?.invoiceNo ?? '—'}',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Obx(
//                       () => _InfoChip(
//                         icon: Icons.calendar_today_outlined,
//                         label: DateFormat(
//                           'dd MMM yyyy',
//                         ).format(c.selectedDate.value),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Delete
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 tooltip: 'Delete Entry',
//                 onPressed: () => Utility.showAlertYesNo(
//                   title: "Delete Entry",
//                   msg: "Are you sure you want to delete this entry?",
//                   yesBtnFun: () => c.deleteAllSalesApi(),
//                   noBtnFun: () => Get.back(),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 8),
//           Row(
//             children: [
//               CustomTextFormFieldView(
//                 controller: c.remarkController,
//                 title: 'Narration',
//                 maxLines: 2,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // INVENTORY SECTION
// // ═══════════════════════════════════════════════════════════════

// class _InventorySection extends StatelessWidget {
//   final SalesController c;
//   const _InventorySection({required this.c});

//   void _navigateInventory({SalesInventoryEntity? data}) async {
//     await Get.to(() => SalesInventoryScreen(salesInventoryEntity: data));
//     await c.getSalesDataAPI();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final header = c.salesHeaderEntity.value;
//       if (header == null && c.hedId == null) {
//         return const SizedBox.shrink();
//       }

//       final items = header?.items ?? [];

//       return Column(
//         mainAxisSize: MainAxisSize.min, // ← no Expanded inside scroll
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _SectionHeader(
//             icon: Icons.inventory_2_outlined,
//             label: 'Inventory Details',
//             onAdd: () => _navigateInventory(),
//           ),
//           const SizedBox(height: 8),
//           _SectionCard(
//             padding: EdgeInsets.zero,
//             child: items.isEmpty
//                 ? const _EmptyState(
//                     icon: Icons.inventory_2_outlined,
//                     message: 'No inventory added yet',
//                   )
//                 : ListView.separated(
//                     // shrinkWrap + Never = safe inside SingleChildScrollView
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: items.length,
//                     separatorBuilder: (_, __) => const Divider(
//                       height: 1,
//                       thickness: 0.5,
//                       indent: 16,
//                       endIndent: 16,
//                     ),
//                     itemBuilder: (ctx, i) {
//                       final item = items[i];
//                       final amount =
//                           double.tryParse(item.totalvalue ?? '0') ?? 0;
//                       return _InventoryRow(
//                         item: item,
//                         amount: amount,
//                         onEdit: () => _navigateInventory(data: item),
//                         // onDelete: () async {
//                         //   await c.deleteItemPostApi(invId: item.invId ?? '');
//                         //   c.salesHeaderEntity.refresh();
//                         // },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       );
//     });
//   }
// }

// class _InventoryRow extends StatelessWidget {
//   final dynamic item;
//   final double amount;
//   final VoidCallback onEdit;
//   // final VoidCallback onDelete;

//   const _InventoryRow({
//     required this.item,
//     required this.amount,
//     required this.onEdit,
//     // required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Orange dot
//             Container(
//               margin: const EdgeInsets.only(top: 4),
//               width: 8,
//               height: 8,
//               decoration: const BoxDecoration(
//                 color: Colors.orange,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 10),

//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.itemName ?? '',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // Wrap prevents overflow when chips don't fit one line
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 4,
//                     children: [
//                       _MiniChip(label: 'Qty: ${item.qty ?? 0}'),
//                       _MiniChip(label: 'Rate: ${item.rate ?? 0}'),
//                       _MiniChip(label: 'Disc: ${item.discount ?? 0}%'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 8),

//             // Amount + actions — Column with mainAxisSize.min, NOT Expanded
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   indianRupeeFormat(amount),
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       onTap: () {
//         onEdit();
//         //     _navigateInventory(data: item);
//       },
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // LEDGER SECTION
// // ═══════════════════════════════════════════════════════════════

// class _LedgerSection extends StatelessWidget {
//   final SalesController c;
//   const _LedgerSection({required this.c});

//   void _navigateLedger({SalesLedgerEntity? data}) async {
//     await Get.to(() => SalesLedgerScreen(salesLedgerEntity: data));
//     await c.getSalesDataAPI();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           icon: Icons.account_balance_wallet_outlined,
//           label: 'Ledger Details',
//           onAdd: () => _navigateLedger(),
//         ),
//         const SizedBox(height: 8),
//         _SectionCard(
//           padding: EdgeInsets.zero,
//           child: Obx(() {
//             final ledgerList = c.salesLedgerList;
//             if (ledgerList.isEmpty) {
//               return const _EmptyState(
//                 icon: Icons.account_balance_wallet_outlined,
//                 message: 'No ledger entries added',
//               );
//             }
//             return ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: ledgerList.length,
//               separatorBuilder: (_, __) => const Divider(
//                 height: 1,
//                 thickness: 0.5,
//                 indent: 16,
//                 endIndent: 16,
//               ),
//               itemBuilder: (ctx, i) {
//                 final ledger = ledgerList[i];
//                 final amount = double.tryParse(ledger.amount ?? '0') ?? 0;
//                 return _LedgerRow(
//                   ledger: ledger,
//                   amount: amount,
//                   onEdit: () => _navigateLedger(data: ledger),
//                   onDelete: () => Utility.showAlertYesNo(
//                     title: 'Delete Ledger',
//                     msg: 'Delete "${ledger.ledgerName}"?',
//                     yesBtnFun: () async {
//                       Utility.showCircularLoadingWid(context);
//                       await c.deleteLedgerPostApi(ledger);
//                       Get.back();
//                     },
//                     noBtnFun: () => Get.back(),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

// class _LedgerRow extends StatelessWidget {
//   final SalesLedgerEntity ledger;
//   final double amount;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const _LedgerRow({
//     required this.ledger,
//     required this.amount,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//         child: Row(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 4),
//               width: 8,
//               height: 8,
//               decoration: const BoxDecoration(
//                 color: Colors.orange,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 ledger.ledgerName ?? '',
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Text(
//               indianRupeeFormat(amount),
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blue.shade800,
//               ),
//             ),
//             // const SizedBox(width: 4),
//             // _ActionIconBtn(
//             //     icon: Icons.edit_outlined,
//             //     color: Colors.green,
//             //     onTap: onEdit),
//             // _ActionIconBtn(
//             //     icon: Icons.delete_outline,
//             //     color: Colors.red,
//             //     onTap: onDelete),
//           ],
//         ),
//       ),
//       onTap: () {
//         onEdit();
//       },
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // BOTTOM ACTION BAR
// // ═══════════════════════════════════════════════════════════════

// class _BottomActionBar extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;

//   const _BottomActionBar({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 10,
//             offset: const Offset(0, -3),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: SafeArea(
//         child: ResponsiveButton(title: label, function: onTap),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════════════════════
// // SHARED WIDGETS
// // ═══════════════════════════════════════════════════════════════

// /// White card container — no inner Expanded ever
// class _SectionCard extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? padding;

//   const _SectionCard({required this.child, this.padding});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       padding: padding ?? const EdgeInsets.all(16),
//       child: child,
//     );
//   }
// }

// /// Section header: icon + title + Add pill
// class _SectionHeader extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onAdd;

//   const _SectionHeader({
//     required this.icon,
//     required this.label,
//     required this.onAdd,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(7),
//           decoration: BoxDecoration(
//             color: Colors.orange.shade50,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, size: 16, color: Colors.orange),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: onAdd,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.red.shade50,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.red.shade100),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.add, size: 14, color: Colors.red.shade600),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Add',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.red.shade700,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _InfoChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 12, color: Colors.grey.shade500),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//         ),
//       ],
//     );
//   }
// }

// class _MiniChip extends StatelessWidget {
//   final String label;
//   const _MiniChip({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
//       ),
//     );
//   }
// }

// class _ActionIconBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _ActionIconBtn({
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(6),
//       child: Padding(
//         padding: const EdgeInsets.all(4),
//         child: Icon(icon, size: 18, color: color),
//       ),
//     );
//   }
// }

// class _FieldLabel extends StatelessWidget {
//   final String label;
//   final bool isRequired;

//   const _FieldLabel({required this.label, this.isRequired = false});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         if (isRequired)
//           Text(
//             ' *',
//             style: TextStyle(
//               color: Colors.red.shade600,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final IconData icon;
//   final String message;
//   const _EmptyState({required this.icon, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 32, color: Colors.grey.shade300),
//           const SizedBox(height: 8),
//           Text(
//             message,
//             style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
//           ),
//         ],
//       ),
//     );
//   }
// }
