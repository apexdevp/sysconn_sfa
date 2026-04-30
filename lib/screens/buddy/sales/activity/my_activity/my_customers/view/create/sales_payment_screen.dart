import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PaymentDetailsWidget extends StatelessWidget {
  PaymentDetailsWidget({super.key});

  final SalesController c = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: SfaCustomAppbar(title: "Payment Details"),

      // ── FIXED BOTTOM BUTTON ──
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
            title: 'Proceed To Buy',
            function: () async {
               await Utility.runWithLoading(context, () => c.salesSavePostApi());
                Get.back(); 
                
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

            // ── SECTION HEADER ──
            _SectionHeader(
              icon: Icons.payments_outlined,
              label: 'Payment Mode',
            ),

            const SizedBox(height: 12),

            // ── PAYMENT METHOD CARDS ──
            // c is passed so _AmountField can call c.calculatePaymentTotal()
            _PaymentMethodCard(
              c: c,
              title: 'Cash',
              subtitle: 'Physical currency payment',
              icon: Icons.money_outlined,
              iconColor: const Color(0xFF2E7D32),
              iconBg: const Color(0xFFE8F5E9),
              amountController: c.cashController,
            ),

            _PaymentMethodCard(
              c: c,
              title: 'UPI',
              subtitle: 'Instant bank transfer',
              icon: Icons.qr_code_outlined,
              iconColor: const Color(0xFF6A1B9A),
              iconBg: const Color(0xFFF3E5F5),
              amountController: c.bankAmtController,
              referenceController: c.bankInstNoController,
              referenceTitle: 'UPI Ref No',
            ),

            _PaymentMethodCard(
              c: c,
              title: 'Card',
              subtitle: 'Debit / Credit card',
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFF1565C0),
              iconBg: const Color(0xFFE3F2FD),
              amountController: c.cardAmtController,
              referenceController: c.cardInstNoController,
              referenceTitle: 'Card Ref No',
            ),

            _PaymentMethodCard(
              c: c,
              title: 'Gift Voucher',
              subtitle: 'Redeemable gift coupon',
              icon: Icons.card_giftcard_outlined,
              iconColor: const Color(0xFFBF360C),
              iconBg: const Color(0xFFFBE9E7),
              amountController: c.giftAmtController,
              referenceController: c.giftReferenceController,
              referenceTitle: 'Voucher No',
            ),

            const SizedBox(height: 16),

            // ── TOTAL SUMMARY ──
            _TotalSummaryCard(c: c),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAYMENT METHOD CARD
// ═══════════════════════════════════════════════════════════════

class _PaymentMethodCard extends StatelessWidget {
  final SalesController c;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final TextEditingController? amountController;
  final TextEditingController? referenceController;
  final String referenceTitle;

  const _PaymentMethodCard({
    required this.c,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.amountController,
    this.referenceController,
    this.referenceTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── HEADER ROW ──
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 14),

            // ── AMOUNT FIELD ──
            _AmountField(
              controller: amountController,
              onChanged: (_) => c.calculatePaymentTotal(),
            ),

            // ── REFERENCE FIELD (optional) ──
            if (referenceController != null) ...[
              const SizedBox(height: 10),
              _ReferenceField(
                controller: referenceController!,
                label: referenceTitle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AMOUNT FIELD
// ═══════════════════════════════════════════════════════════════

class _AmountField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const _AmountField({this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // ✅ No ^ anchor — allow digits and decimal point per character
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          // ✅ Directly calls c.calculatePaymentTotal() on every keystroke
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(
                color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 13),
              child: Text(
                '₹',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.orange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// REFERENCE FIELD
// ═══════════════════════════════════════════════════════════════

class _ReferenceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _ReferenceField(
      {required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TextStyle(
                color: Colors.grey.shade400, fontSize: 13),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.orange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TOTAL SUMMARY CARD
// ═══════════════════════════════════════════════════════════════

class _TotalSummaryCard extends StatelessWidget {
  final SalesController c;
  const _TotalSummaryCard({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_long_outlined,
                    size: 18, color: Colors.green.shade700),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sum of all payment modes',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),

          // ✅ Reactive — updates whenever calculatePaymentTotal() is called
          Obx(() => Text(
                '₹ ${c.paymentTotal.value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════

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
              fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/widgets/responsive_button.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

// class PaymentDetailsWidget extends StatelessWidget {
//   PaymentDetailsWidget({super.key});

//   final SalesController c = Get.find<SalesController>();

//   @override
//    Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: SfaCustomAppbar(title: "Payment Details"),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             paymentDetails(MediaQuery.of(context).size),
//           ],
//         ),
//       ),
//         // ================= FIXED SAVE BUTTON =================
//   bottomNavigationBar: SafeArea(
//     child: Container(
//       padding: const EdgeInsets.all(12),
//       child: SizedBox(
//         width: size.width*0.2,
//         child: ResponsiveButton(
//           title: 'Proceed To Buy',
//           function: () async {
//             Utility.showCircularLoadingWid(context);
//             await c.salesSavePostApi();
//             Get.back();
//             Get.back();
//           },
//         ),
//       ),
//     ),
//   ),

//     );
//   }
// }

// Widget paymentDetails(Size size) {
//   final SalesController c = Get.find<SalesController>();

//   return Padding(
//     padding: const EdgeInsets.all(12),
//     child: Column(
//       children: [

//         cardWidget(
//           title: 'Cash',
//           icon: Icons.money,
//           amountController: c.cashController,
//         ),

//         cardWidget(
//           title: 'UPI',
//           icon: Icons.qr_code,
//           amountController: c.bankAmtController,
//           referenceController: c.bankInstNoController,
//           referenceTitle: "UPI Ref No",
//         ),

//         cardWidget(
//           title: 'Card',
//           icon: Icons.credit_card,
//           amountController: c.cardAmtController,
//           referenceController: c.cardInstNoController,
//           referenceTitle: "Card Ref No",
//         ),

//         cardWidget(
//           title: 'Gift Voucher',
//           icon: Icons.card_giftcard,
//           amountController: c.giftAmtController,
//           referenceController: c.giftReferenceController,
//           referenceTitle: "Voucher No",
//         ),

//         const SizedBox(height: 12),

//         /// TOTAL CARD
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.blue.shade50,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Total",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Obx(
//                 () => Text(
//                   "₹ ${c.paymentTotal.value.toStringAsFixed(2)}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }


//   Widget cardWidget({
//   required String title,
//   required IconData icon,
//   TextEditingController? amountController,
//   TextEditingController? referenceController,
//   String referenceTitle = '',
//   void Function(String)? onChanged,
// }) {
//   return Card(
//     elevation: 2,
//     margin: const EdgeInsets.symmetric(vertical: 6),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     child: Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           /// HEADER
//           Row(
//             children: [
//               Icon(icon, size: 20),
//               const SizedBox(width: 8),
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),

//           const SizedBox(height: 12),

//           /// AMOUNT FIELD
//           TextField(
//             controller: amountController,
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//             ],
//             decoration: InputDecoration(
//               labelText: "Amount",
//               prefixText: "₹ ",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onChanged: onChanged,
//           ),

//           /// REFERENCE (ONLY IF EXISTS)
//           if (referenceController != null) ...[
//             const SizedBox(height: 10),
//             TextField(
//               controller: referenceController,
//               decoration: InputDecoration(
//                 labelText: referenceTitle,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     ),
//   );
// }
