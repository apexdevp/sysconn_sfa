
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class ProductMasterController extends GetxController {
  var isDataLoad = 0.obs; // 0 = loading, 1 = data loaded, 2 = no data
  var rows = <TrinaRow>[].obs;

  TrinaGridStateManager? stateManager;

  @override
  void onInit() {
    super.onInit();
    getProductMasterData();
  }

  Future<void> getProductMasterData() async {
    isDataLoad.value = 0;
    rows.clear();

    // final productMasterDataList = await ApiCall.getStockItemDetApi();
    ApiCall.getStockItemDetApi().then((productMasterDataList) {
      if (productMasterDataList.isNotEmpty) {
        rows.addAll(
          productMasterDataList.map((data) {
            return TrinaRow(
              cells: {
                'action': TrinaCell(value: ''),
                'item_id': TrinaCell(value: data.itemId ?? ''),
                'item_name': TrinaCell(value: data.itemName ?? ''),
                'product_category_main_code': TrinaCell(
                  value: data.productCategoryCode ?? '',
                ),
                'tax_rate': TrinaCell(value: data.taxRate ?? ''),
                'cess_rate': TrinaCell(value: data.cess ?? ''),
                'hsn_code': TrinaCell(value: data.hsnCode ?? ''),
                'unit_name': TrinaCell(value: data.unitName ?? ''),
                // 'tallystatus': TrinaCell(value: data.tallystatus),
                'hsn_desc': TrinaCell(value: data.hsndesc ?? ''),
                'classification': TrinaCell(value: data.classification ?? ''),
                'description': TrinaCell(value: data.description ?? ''),
                'category_name': TrinaCell(value: data.category ?? ''),
                'subcategory_name': TrinaCell(value: data.subcategory ?? ''),
                'group_name': TrinaCell(value: data.groupname ?? ''),
                'image_path': TrinaCell(value: data.imagePath ?? ''),  // Sakshi 08/04/2026
                'active_status': TrinaCell(value: data.activestatus?.toString().trim().toLowerCase() ==
                 'true'? 'Active': 'Inactive',),
               // 'active_status': TrinaCell(value: data.activestatus == 'True' ? 'Active' : 'Inactive',),
                //'active_status': TrinaCell(value: data.activestatus),
              },
            );
          }).toList(),
        );
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }

  // void getProductMasterData() {
  //   isDataLoad.value = 0;
  //   rows.clear();

  //   //Sakshi 10/02/2026

  //   ApiCall.getStockItemDetApi().then((productMasterDataList) {
  //     if (productMasterDataList.isNotEmpty) {
  //       rows.addAll(
  //         productMasterDataList.map((data) {
  //           return TrinaRow(
  //             cells: {
  //               'action': TrinaCell(value: ''),
  //               'item_id': TrinaCell(value: data.itemId ?? ''),
  //               'item_name': TrinaCell(value: data.itemName ?? ''),
  //               'product_category_main_code': TrinaCell(value: data.productCategoryCode ?? ''),
  //               'tax_rate': TrinaCell(value: data.taxRate ?? ''),
  //               'cess_rate': TrinaCell(value: data.cess ?? ''),
  //               'hsn_code': TrinaCell(value: data.hsnCode ?? ''),
  //               'unit_name': TrinaCell(value: data.unitName ?? ''),
  //               // 'tallystatus': TrinaCell(value: data.tallystatus),
  //               'hsn_desc': TrinaCell(value: data.hsndesc ?? ''),
  //               'classification': TrinaCell(value: data.classification ?? ''),
  //               'description': TrinaCell(value: data.description ?? ''),
  //               'category_name': TrinaCell(value: data.category ?? ''),
  //               'subcategory_name': TrinaCell(value: data.subcategory ?? ''),
  //               'group_name': TrinaCell(value: data.groupname ?? ''),
  //               'active_status': TrinaCell(
  //                 value: data.activestatus == 'True' ? 'Active' : 'Inactive',
  //               ),
  //               //'active_status': TrinaCell(value: data.activestatus),
  //             },
  //           );
  //         }).toList(),
  //       );
  //       isDataLoad.value = 1;
  //     } else {
  //       isDataLoad.value = 2;
  //     }
  //   });
  // }

  Future<void> deleteItemApi({required String itemId}) async {
    StockItemEntity deleteEntity = StockItemEntity();

    deleteEntity.companyId = Utility.companyId;
    deleteEntity.itemId = itemId;

    List<Map<String, dynamic>> body = [deleteEntity.toMap()];

    final response = await ApiCall.deleteStockItemApi(body);

    if (response.contains('Data Deleted Successfully')) {
      Get.back();

      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Data Deleted Successfully',
      );

      getProductMasterData();
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }
}
