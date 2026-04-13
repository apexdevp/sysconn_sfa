import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/producteditcontroller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/productmastercontroller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/view/product_image.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/view/product_master.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:sysconn_sfa/widgetscustome/custom_popup_list_Item.dart';
import 'package:sysconn_sfa/widgetscustome/entry_button.dart';
import 'package:trina_grid/trina_grid.dart';

//SHWETA 25-11-2025
class ProductMasterReport extends StatelessWidget {
  ProductMasterReport({super.key});

  final ProductMasterController controller = Get.put(ProductMasterController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //child: DefaultLayout (
       appBar: SfaCustomAppbar(title: 'Product Master Report',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Obx(
              //       () => CalendarSingleView(
              //         fromDate: controller.fromDate.value,
              //         toDate: controller.toDate.value,
              //         function: () async {
              //           await selectDateRange(
              //             controller.fromDate.value,
              //             controller.toDate.value,
              //           ).then((dateTimeRange) {
              //             controller.fromDate.value = dateTimeRange.start;
              //             controller.toDate.value = dateTimeRange.end;
              //           });
              //            controller.getProductMasterData();
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
        ),
       
        body: Column(
          children: [
            MakeEntryButton(
              title: 'New Product',
              onTap: () async {
             final controller = Get.isRegistered<ProductEditController>()
            ? Get.find<ProductEditController>()
          : Get.put(ProductEditController());
         controller.clearFields();
      Get.dialog(ProductCreateDialog(size));
},
              // onTap: () async {
              //   final controller = Get.find<ProductEditController>();
              //   controller.clearFields();
              //   Get.put(ProductEditController());
              //   Get.dialog(ProductCreateDialog(size));
              // },
            ),
            Expanded(
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(child: Utility.processLoadingWidget());
                } else if (controller.isDataLoad.value == 2) {
                  return Center(child: const NoDataFound());
                } else {
                  return trinaCustomTheme(
                    context: context,
                    select: TrinaGridMode.select,
                    iscolumnsize: true, //pratiksha p 08-01-2026 add
                    columns: [
                      gridColumnRpt(
                        field: 'action',
                        title: 'Action',
                        isstartcolumn: true,
                        width: 120,
                        renderer: (rendererContext) {
                          var map = rendererContext.row.cells;
                          StockItemEntity stockitemEntity = StockItemEntity();
                          stockitemEntity.itemId =
                              map['item_id']?.value?.toString() ?? '';
                          stockitemEntity.itemName =
                              map['item_name']?.value?.toString() ?? '';
                          stockitemEntity.productCategoryCode =
                              map['product_category_main_code']?.value
                                  ?.toString() ??
                              '';
                          stockitemEntity.taxRate =
                              map['tax_rate']?.value?.toString() ?? '';
                          stockitemEntity.cess =
                              map['cess_rate']?.value?.toString() ?? '';
                          stockitemEntity.hsnCode =
                              map['hsn_code']?.value?.toString() ?? '';
                          stockitemEntity.unitName =
                              map['unit_name']?.value?.toString() ?? '';
                          stockitemEntity.hsndesc =
                              map['hsn_desc']?.value?.toString() ?? '';
                          stockitemEntity.classification =
                              map['classification']?.value?.toString() ?? '';
                          stockitemEntity.description =
                              map['description']?.value?.toString() ?? '';
                          stockitemEntity.category =
                              map['category_name']?.value?.toString() ?? '';
                          stockitemEntity.subcategory =
                              map['subcategory_name']?.value?.toString() ?? '';
                          stockitemEntity.groupname =
                              map['group_name']?.value?.toString() ?? '';
                          // stockitemEntity.activestatus =
                          //     map['active_status']?.value?.toString() ?? '';
                           stockitemEntity.activestatus =
                              map['active_status']?.value?.toString() ?? '';
                                stockitemEntity.imagePath =
                              map['image_Path']?.value?.toString() ?? '';  // Sakshi 08/04/2026
                            
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: CustomPopupMenuButton(
                              screenSize: size,
                              menuItems: [
                                PopupMenuItemModel(
                                  value: 'edit',
                                  icon: Icons.edit,
                                  title: 'Edit',
                                  onTap: () async {
                                    await Future.delayed(
                                      Duration(milliseconds: 100),
                                    ); // avoid menu bug
                                    final ProductEditController editController = Get.put(ProductEditController());
                                      final ProductMasterController productMasterController = Get.find();
                                   // ProductEditController editController = Get.find();
                                    //ProductMasterController productMasterController = Get.find();
                                    await productMasterController.getProductMasterData();
                                    editController.loadProductForEdit(stockitemEntity,);
                                    Get.dialog(ProductCreateDialog(size));
                                  },
                                ),
                                PopupMenuItemModel(
                                  value: 'delete',
                                  icon: Icons.delete,
                                  title: 'Delete',
                                  onTap: () async {
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );

                                    Utility.showAlertYesNo(
                                     // Get.context!,
                                      iconData: Icons.warning_amber_rounded,
                                      iconcolor: Colors.red,
                                      title: "Delete Item",
                                      msg:
                                          "Are you sure you want to delete ${stockitemEntity.itemName} ?",
                                      yesBtnFun: () async {
                                        //Get.back();
                                        // await controller.deleteItemApi(stockitemEntity.itemId);
                                        await controller.deleteItemApi(
                                          itemId: stockitemEntity.itemId ?? '',
                                        );
                                      },
                                      noBtnFun: () {
                                        Get.back();
                                      },
                                    );
                                  },
                                ),
                                 // Sakshi 07/04/2026
                                 PopupMenuItemModel(
                                          value: 'addproductimage',
                                          icon: Icons.add_a_photo,
                                          title: 'Add Product Image',
                                          onTap: () async {
                                        await Future.delayed(const Duration(milliseconds: 100));
                                        ProductImageAdd().showProductImageDialog(context,
                                        productCode: stockitemEntity.itemId ?? "",
                                        imagePath: map['image_path']?.value?.toString() ?? "",);
                                         },
                                        ),
                              ],
                            ),
                          );
                        },
                      ),
                      gridColumnRpt(
                        field: 'item_id',
                        title: 'ITEM CODE',
                       width: 100,
                      ),
                      gridColumnRpt(
                        field: 'item_name',
                        title: 'ITEM NAME',
                       width: 135,
                      ), // isfooter: true,isstartcolumn: true,coltype: PlutoAggregateColumnType.count,
                      gridColumnRpt(
                        field: 'unit_name',
                        title: 'UNIT NAME',
                      width: 135,
                      ),
                       // Sakshi 08/04/2026
                        gridColumnRpt(
                        field: 'image_path',
                        title: 'PRODUCT IMAGE',
                        width: 135,
                        hide: true,
                      ), 
                      gridColumnRpt(
                        field: 'group_name',
                        title: 'GROUP NAME',
                        width: 120,
                      ),
                      gridColumnRpt(
                        field: 'category_name',
                        title: 'CATEGORY',
                        width: 135,
                      ),
                      gridColumnRpt(
                        field: 'subcategory_name',
                        title: 'SUBCATEGORY',
                        width: 135,
                      ),
                      gridColumnRpt(
                        field: 'hsn_code',
                        title: 'HSN CODE',
                        width: size.width * 0.1,
                      ),
                      gridColumnRpt(
                        field: 'hsn_desc',
                        title: 'HSN DESCRIPTION',
                        width: 135,
                      ), //Sakshi 10/02/2026
                      gridColumnRpt(
                        field: 'tax_rate',
                        title: 'TAX RATE',
                        width: size.width * 0.1,
                      ),
                      gridColumnRpt(
                        field: 'classification',
                        title: 'CLASSIFICATION',
                        width: 135,
                      ), //Sakshi 10/02/2026
                      gridColumnRpt(
                        field: 'description',
                        title: 'DESCRIPTION',
                        width: 135,
                      ), //Sakshi 10/02/2026
                      gridColumnRpt(
                        field: 'cess_rate',
                        title: 'CESS RATE',
                        width: size.width * 0.1,
                      ),
                      gridColumnRpt(
                        field: 'product_category_main_code',
                        title: 'CATEGORY CODE',
                        hide: true,
                      ), //pratiksha p 03-12-2024
                      // gridColumnRpt(
                      //   field: 'tallystatus',
                      //   title: 'SYNC',
                      //   width: 135,
                      // ), //'DOWNLOAD STATUS',
                      gridColumnRpt(
                        field: 'active_status',
                        title: 'ACTIVE',
                        width: 135, // //Sakshi 12/02/2026
                        renderer: (rendererContext) {
                          final cells = rendererContext.row.cells;
                          final status =
                              cells['active_status']?.value?.toString() ??
                              'Inactive';
                          final isActive = status.toLowerCase() == 'active';
                          final textColor = Colors.black;
                          final borderColor = isActive
                              ? Colors.green
                              : Colors.red;
                          final backgroundColor = isActive
                              ? Color(0xFFE8F5E9)
                              : Color(0xFFFDECEA);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: Text(
                              status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ].obs,
                    rows: controller.rows,
                    onLoaded: (event) {
                      controller.stateManager = event.stateManager;
                    },
                  );
                }
              }),
            ),
          ],
        ),
     // ),s
    );
  }
}
