import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/controllers/buddy/sales/additionaldetails_controller.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_payment_screen.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/autocomplete_list.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

// ── Theme ────────────────────────────────────────────────────────────────────
const _kRed    = Color(0xFFD32F2F);
const _kOrange = Color(0xFFF57C00);
const _kBg     = Color(0xFFF5F6FA);

class AdditionalDetailsScreen extends StatelessWidget {
  final SalesHeaderEntity salesHeaderEntity;

  const AdditionalDetailsScreen({
    super.key,
    required this.salesHeaderEntity,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AdditionalDetailsController>()
        ? Get.find<AdditionalDetailsController>()
        : Get.put(
            AdditionalDetailsController(
                salesHeaderEntity: salesHeaderEntity),
          );

    return Scaffold(
      backgroundColor: _kBg,
      appBar: SfaCustomAppbar(title: "Additional Details"),

      // ── FIXED BOTTOM BUTTON ──────────────────────────────────────────────
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
            title: 'Proceed To Payment',
            function: () async {
              Utility.showCircularLoadingWid(context);
              await controller.saveAdditionalDetails();
              await Get.to(() => PaymentDetailsWidget());
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

            // ── BILLED TO ──────────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.receipt_outlined,
              label: 'Billed To Details',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.partyNameController,
                      title: 'Party Name',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.addressBilledController,
                      title: 'Address Line 1',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.addressBilled2Controller,
                      title: 'Address Line 2',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.gstinBilledController,
                      title: 'GSTIN',
                    ),
                  ]),
                  // State autocomplete
                  Row(children: [
                    Obx(() => AutoCompleteFieldView(
                          title: 'State',
                          controllerValue: controller.stateBilled.value,
                          optionsBuilder: (v) {
                            return Utility.stateDropdownlist
                                .where((e) => e
                                    .toLowerCase()
                                    .contains(v.text.toLowerCase()))
                                .toList();
                          },
                          onSelected: (text) =>
                              controller.stateBilled.value = text,
                          closeControllerFun: () =>
                              controller.stateBilled.value = '',
                        )),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── SHIPPED TO ─────────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.local_shipping_outlined,
              label: 'Shipped To',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.consigneeController,
                      title: 'Consignee',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.addressShippedController,
                      title: 'Address Line 1',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.addressShipped2Controller,
                      title: 'Address Line 2',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.gstinShippedController,
                      title: 'GSTIN',
                    ),
                  ]),
                  Row(children: [
                    Obx(() => AutoCompleteFieldView(
                          title: 'State',
                          controllerValue: controller.stateShipped.value,
                          optionsBuilder: (v) {
                            return Utility.stateDropdownlist
                                .where((e) => e
                                    .toLowerCase()
                                    .contains(v.text.toLowerCase()))
                                .toList();
                          },
                          onSelected: (text) =>
                              controller.stateShipped.value = text,
                          closeControllerFun: () =>
                              controller.stateShipped.value = '',
                        )),
                  ]),
                  // City + Pincode side by side
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.cityController,
                        title: 'City',
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormFieldView(
                        controller: controller.pincodeController,
                        title: 'Pincode',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── OTHER DETAILS ──────────────────────────────────────────────
            _SectionHeader(
              icon: Icons.info_outline,
              label: 'Other Details',
            ),
            const SizedBox(height: 10),

            _Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date + Vehicle side by side
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.dateController,
                        title: 'Date',
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormFieldView(
                        controller: controller.vehicleController,
                        title: 'Vehicle',
                      ),
                    ],
                  ),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.dispatchController,
                      title: 'Dispatched Through',
                    ),
                  ]),
                  Row(children: [
                    CustomTextFormFieldView(
                      controller: controller.mailingController,
                      title: 'Mailing Name',
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: child,
    );
  }
}

/// Section header: gradient icon pill + bold label
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
            gradient: const LinearGradient(
              colors: [_kRed, _kOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}