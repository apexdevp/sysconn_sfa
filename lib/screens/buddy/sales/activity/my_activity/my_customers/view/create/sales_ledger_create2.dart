// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
// import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
// import 'package:sysconn_sfa/widgets/responsive_button.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

// class SalesLedgerScreen extends StatelessWidget {
//   final SalesLedgerEntity? salesLedgerEntity;

//   const SalesLedgerScreen({super.key, this.salesLedgerEntity});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SalesController(isEdit: salesLedgerEntity != null));

//     final ledgerCtrl = TextEditingController(
//       text: salesLedgerEntity?.ledgerName ?? '',
//     );

//     final amountCtrl = TextEditingController(
//       text: salesLedgerEntity?.amount ?? '',
//     );

//     final ledger = (salesLedgerEntity ?? SalesLedgerEntity()).obs;

//     return Scaffold(
//       appBar: SfaCustomAppbar(title: "Ledger Details"),

//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ResponsiveButton(
//           title: "Save",
//           function: () async {
//             Utility.showCircularLoadingWid(context);

//             await controller.ledgerPostApi(
//               salesledgerApiEntity: ledger.value,
//             );

//             Get.back(result: true);
//           },
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
            
//             /// ===== LEDGER NAME =====
//             Row(
//               children: [
//                 CustomAutoCompleteFieldView(
//                   title: "Ledger Name",
//                   controllerValue: ledgerCtrl.text,
//                   optionsBuilder: (TextEditingValue value) {
//                     final query = value.text.trim();
//                     if (query.isEmpty) return const <LedgerMasterEntity>[];
                
//                     return controller.ledgerMasterlist.where((LedgerMasterEntity e) {
//                       final name = e.ledgerName;
//                       if (name == null) return false;
//                       return name.toLowerCase().contains(query.toLowerCase());
//                     }).toList();
//                   },
//                   displayStringForOption: (LedgerMasterEntity e) =>
//                       e.ledgerName ?? '',
                
//                   onSelected: (LedgerMasterEntity selected) {
//                     ledgerCtrl.text = selected.ledgerName ?? '';
                
//                     ledger.update((val) {
//                       val?.ledgerId = selected.ledgerId;
//                       val?.ledgerName = selected.ledgerName;
//                     });
//                   },
                
//                   closeControllerFun: () {
//                     ledgerCtrl.clear();
//                     ledger.update((val) {
//                       val?.ledgerId = '';
//                       val?.ledgerName = '';
//                     });
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             /// ===== AMOUNT =====
//             Row(
//               children: [
//                 CustomTextFormFieldView(
//                   title: "Amount",
//                   controller: amountCtrl,
//                   keyboardType: TextInputType.number,
//                   onChanged: (txt) {
//                     ledger.update((val) {
//                       val?.amount = txt;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }