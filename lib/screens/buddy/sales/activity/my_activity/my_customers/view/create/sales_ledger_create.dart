import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/autocomplete_list.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

class SalesLedgerScreen extends StatelessWidget {
  final SalesLedgerEntity? salesLedgerEntity;

  const SalesLedgerScreen({super.key, this.salesLedgerEntity});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SalesController(isEdit: salesLedgerEntity != null),
    );

    final ledgerCtrl = TextEditingController(
      text: salesLedgerEntity?.ledgerName ?? '',
    );

    final amountCtrl = TextEditingController(
      text: salesLedgerEntity?.amount ?? '',
    );

    final ledger = (salesLedgerEntity ?? SalesLedgerEntity()).obs;

    final isLedgerError = false.obs;
    final isAmountError = false.obs;

    bool validate() {
      bool valid = true;

      if ((ledger.value.ledgerId ?? '').trim().isEmpty) {
        isLedgerError.value = true;
        valid = false;
      } else {
        isLedgerError.value = false;
      }

      final amtText = amountCtrl.text.trim();
      if (amtText.isEmpty) {
        isAmountError.value = true;
        valid = false;
      } else {
        final parsed = double.tryParse(amtText);
        if (parsed == null || parsed <= 0) {
          isAmountError.value = true;
          valid = false;
        } else {
          isAmountError.value = false;
        }
      }

      if (!valid) {
        Get.snackbar(
          'Validation Error',
          'Please fill in all required fields.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          borderColor: Colors.red.shade200,
          borderWidth: 1,
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.error_outline, color: Colors.red),
          duration: const Duration(seconds: 3),
        );
      }

      return valid;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: SfaCustomAppbar(
        title: salesLedgerEntity != null ? "Edit Ledger" : "Add Ledger",
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SafeArea(
          child: ResponsiveButton(
            title: salesLedgerEntity != null ? "Update" : "Save",
            function: () async {
              if (!validate()) return;
              ledger.update((val) {
                val?.amount = amountCtrl.text.trim();
              });
              Utility.showCircularLoadingWid(context);
              await controller.ledgerPostApi(
                salesledgerApiEntity: ledger.value,
              );
              Get.back(result: true);
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ← no unbounded expansion
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── SECTION HEADER ──
            _SectionHeader(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Ledger Information',
            ),

            const SizedBox(height: 16),

            // ── CARD ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ← no unbounded expansion
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── LEDGER NAME ──
                  // FIX: CustomAutoCompleteFieldView has internal Flexible/Expanded
                  // that requires a bounded width parent. Wrapping in Row provides
                  // the bounded horizontal constraint — never place it bare inside
                  // a Column that lives inside SingleChildScrollView.
                  Obx(() => _FieldWrapper(
                        // label: 'Ledger Name',
                        isRequired: true,
                        hasError: isLedgerError.value,
                        errorText: 'Please select a ledger',
                        child: Row(
                          children: [
                            AutoCompleteFieldView(
                              isCompulsory: true,
                              title: "Ledger Name",
                              controllerValue: ledgerCtrl.text,
                              optionsBuilder: (TextEditingValue value) {
                                final query = value.text.trim();
                                if (query.isEmpty) {
                                  return const <LedgerMasterEntity>[];
                                }
                                return controller.ledgerMasterlist
                                    .where((LedgerMasterEntity e) {
                                  final name = e.ledgerName;
                                  if (name == null) return false;
                                  return name.toLowerCase().contains(
                                        query.toLowerCase(),
                                      );
                                }).toList();
                              },
                              displayStringForOption:
                                  (LedgerMasterEntity e) =>
                                      e.ledgerName ?? '',
                              onSelected: (LedgerMasterEntity selected) {
                                ledgerCtrl.text =
                                    selected.ledgerName ?? '';
                                isLedgerError.value = false;
                                ledger.update((val) {
                                  val?.ledgerId = selected.ledgerId;
                                  val?.ledgerName = selected.ledgerName;
                                });
                              },
                              closeControllerFun: () {
                                ledgerCtrl.clear();
                                isLedgerError.value = false;
                                ledger.update((val) {
                                  val?.ledgerId = '';
                                  val?.ledgerName = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 16),

                  // ── AMOUNT ──
                  // FIX: Same as above — CustomTextFormFieldView uses
                  // Flexible(flex:1) internally, so it needs a Row parent.
                  Obx(() => _FieldWrapper(
                        // label: 'Amount',
                        isRequired: true,
                        hasError: isAmountError.value,
                        errorText: 'Enter a valid amount greater than 0',
                        child: Row(
                          children: [
                            CustomTextFormFieldView(
                              isCompulsory: true,
                              title: "Amount",
                              controller: amountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (txt) {
                                if (txt.isNotEmpty &&
                                    double.tryParse(txt) != null &&
                                    double.parse(txt) > 0) {
                                  isAmountError.value = false;
                                }
                                ledger.update(
                                    (val) => val?.amount = txt);
                              },
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── LIVE SUMMARY ──
            Obx(() {
              final name = ledger.value.ledgerName ?? '';
              final amount =
                  double.tryParse(ledger.value.amount ?? '') ?? 0.0;

              if (name.isEmpty && amount == 0) {
                return const SizedBox.shrink();
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name.isNotEmpty ? name : '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (amount > 0)
                      Text(
                        '₹ ${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
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
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FIELD WRAPPER
// ═══════════════════════════════════════════════════════════════

class _FieldWrapper extends StatelessWidget {
  // final String label;
  final bool isRequired;
  final bool hasError;
  final String errorText;
  final Widget child;

  const _FieldWrapper({
    // required this.label,
    required this.child,
    this.isRequired = false,
    this.hasError = false,
    this.errorText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ← no unbounded expansion
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        // Field with optional error border
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: hasError
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.shade400,
                    width: 1.5,
                  ),
                )
              : null,
          child: child,
        ),

        // Inline error message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: hasError
              ? Padding(
                  key: ValueKey(errorText),
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline,
                          size: 13, color: Colors.red.shade500),
                      const SizedBox(width: 4),
                      Text(
                        errorText,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('no-error')),
        ),
      ],
    );
  }
}