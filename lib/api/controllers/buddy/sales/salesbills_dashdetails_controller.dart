// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/apicall.dart';
// import 'package:sysconn_sfa/api/entity/sales/sales_register_rep_entity.dart';

// class SalesBillsDashDetailsController extends GetxController {
//   var isdataLoad = 0.obs;
//   var salesbillswiseValue = <SalesRegisterReportEntity>[].obs;
//   var searchResultOfInvoice = <SalesRegisterReportEntity>[].obs;
//   var isSearch = false.obs;
//   var searchController = TextEditingController();

//   DateTime fromDate = Utility.findStartOfThisMonth(DateTime.now());
//   DateTime toDate = Utility.findLastOfThisMonth(DateTime.now());

//   Future salesListApiDet(String? id, String? type) async {
//     salesbillswiseValue.clear();
//     isdataLoad.value = 0;

//     var salesRegisterRepListData =
//         await ApiCall.getSalesRegisterReport(fromDate.toString(), toDate.toString(), id, type);

//     if (salesRegisterRepListData.isNotEmpty) {
//       salesbillswiseValue.value = salesRegisterRepListData;
//       isdataLoad.value = 1;
//     } else {
//       isdataLoad.value = 2;
//     }
//   }

//   onSearchTextChanged(String text) {
//     searchResultOfInvoice.clear();
//     if (text.isEmpty) {
//       isSearch.value = false;
//       return;
//     }
//     for (var salesData in salesbillswiseValue) {
//       if (salesData.invoiceno!.toLowerCase().contains(text.toLowerCase())) {
//         searchResultOfInvoice.add(salesData);
//       }
//     }
//     salesbillswiseValue.value = searchResultOfInvoice.toList();
//     isSearch.value = true;
//   }
// }