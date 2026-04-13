import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/product_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_group_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_unit_entity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/producteditcontroller.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/custome_dialogbox.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// import 'package:sysconn_oms/app/modules/masters/controller/productmaster/productmasterrptcontroller.dart';

// ignore: must_be_immutable
class ProductCreateDialog extends StatelessWidget {
  final Size size;
  StockItemEntity? productEntity;
 
  final ProductEditController productEditController = Get.find();

  bool get isEdit => productEditController.prdcode.text.isNotEmpty;
  ProductCreateDialog(this.size, {super.key, this.productEntity});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return CustomeDialogbox(
      title: productEditController.isEdit ? 'Update Item' : 'Create Item',
      buttontitle: productEditController.isEdit ? 'Update' : 'Save',
      maxHeight: 12000, //shweta 09-03-26
      maxWidth: 800,
     // minWidth: 1000,
      function: () async {
        // await controller.submitProduct();
        Utility.processLoadingWidget();
        await productEditController.submitProduct();
      },
      // content: SingleChildScrollView(
       content: SingleChildScrollView(
        child: Column(
          children: [
               Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row (  //
                      children: [
                        Expanded (
                         child:Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              CustomTextFormFieldView(
                                controller: productEditController.prddesc,
                                keyboardType: TextInputType.name,
                                title: 'Product Desc',
                                isCompulsory: true,
                                hinttext: 'Enter Product Desc',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => DropdownCustomList<ProductUOMEntity>(
                                  title: "UOM",
                                  hint: "Select Unit",
                                  items: productEditController.unitList
                                      .map(
                                        (item) =>
                                            DropdownMenuItem<ProductUOMEntity>(
                                              value: item,
                                              child: Text(item.pUnitName ?? ''),
                                            ),
                                      )
                                      .toList(),
                                  // selectedValue:productEditController.selectedUnit,
                                  selectedValue:
                                      productEditController.selectedUnit,
                                  onChanged: (value) {
                                    productEditController.selectedUnit.value =
                                        value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                         ],
                    ),
                    SizedBox(height: size.height * 0.01),
                     Row (  //
                      children: [
                       Expanded(
                          child:Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Obx(
                              //   () => DropdownCustomList<String>(
                              DropdownCustomList<String>(
                                title: "Classification",
                                hint: "Select Classification",
                                items: productEditController.classificationList
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue: productEditController
                                    .selectedClassification,
                                onChanged: (value) {
                                  productEditController
                                          .selectedClassification
                                          .value =
                                      value;
                                },
                              ),
                            ],
                          ),
                        ),
                      
                     const SizedBox(width: 12),
          
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => DropdownCustomList<ProductGrpEntity>(
                                  title: 'Group',
                                  // isCompulsory:true,
                                  hint: "Select Group",
                                  items: productEditController.groupList
                                      .map(
                                        (item) =>
                                            DropdownMenuItem<ProductGrpEntity>(
                                              value: item,
                                              child: Text(item.pGrpName ?? ''),
                                            ),
                                      )
                                      .toList(),
                                  selectedValue:
                                      productEditController.selectedGroup,
                                  onChanged: (value) {
                                    productEditController.selectedGroup.value =
                                        value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ],
                    ),
                 SizedBox(height: size.height * 0.01),
                 Row (  //
                      children: [
                    Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => DropdownCustomList<ProductCategoryEntity>(
                                  title: 'Product Category Name',
                                  // isCompulsory:true,
                                  hint: "Select Category",
                                  items: productEditController
                                      .productCategoryList
                                      .map(
                                        (a) =>
                                            DropdownMenuItem<
                                              ProductCategoryEntity
                                            >(value: a, child: Text(a.name)),
                                      )
                                      .toList(),
                                  selectedValue: productEditController
                                      .selectedProductCategory,
                                  // onChanged: (value) {
                                  //   productEditController.selectedGroup.value = value;
                                  // },
                                  onChanged: (category) {
                                    if (category != null) {
                                      productEditController
                                              .selectedProductCategory
                                              .value =
                                          category;
                                      productEditController
                                          .filterSubCatByCategory(category.id);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx( () =>
                                    DropdownCustomList<ProductSubCategoryEntity>(
                                      title: 'Product SubCategory Name',
                                      // isCompulsory:true,
                                      hint: "Select SubCategory",
                                      items: productEditController.filteredSubCategoryList
                                      .map((c) => DropdownMenuItem<ProductSubCategoryEntity>(
                                                  value: c,child: Text(c.name),
                                                ),
                                          )
                                          .toList(),
                                      selectedValue: productEditController
                                          .selectedSubProductCategory,
                                      onChanged: (subCategory) {
                                        if (subCategory != null) {
                                          productEditController
                                                  .selectedSubProductCategory
                                                  .value =
                                              subCategory;
                                        }
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.01),

                    Row (  //
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormFieldView(
                                controller: productEditController.hsncd,
                                title: 'HSN Code',
                                // isCompulsory: true,
                                hinttext: 'Enter HSN Code',
                              ),
                            ],
                          ),
                        ),
                 const SizedBox(width: 12),
              Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormFieldView(
                                controller: productEditController.hsndsc,
                                title: 'HSN Description',
                                hinttext: 'Enter HSN Description',
                              ),
                            ],
                          ),
                        ),
                    ],
                    ),
                  SizedBox(height: size.height * 0.01),

                  Row (  //
                      children: [
                  Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormFieldView(
                                controller: productEditController.taxrate,
                                title: 'Tax Rate',
                                hinttext: 'Enter Tax Rate (e.g. 18%)',
                                isCompulsory: true,
                                suffixIcon: const Icon(
                                  Icons.percent,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                    
            const SizedBox(width: 12),
                    // Row( 
                    // Column (                                          //shweta 09-03-26 from here 
                    //       children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextFormFieldView(
                                    controller: productEditController.existingid,
                                    title: 'Existing Id',
                                    // isCompulsory: true,
                                    hinttext: 'Enter Existing Id',
                                  ),
                                ],
                              ),
                            ),
                            // ],
                   // ),
                      ],
                    ),
                SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormFieldView(
                                controller:
                                    productEditController.descriptionController,
                                keyboardType: TextInputType.text,
                                title: 'Description',
                                maxLines: 5,
                                hinttext: 'Enter Description',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                     SizedBox(height: size.height * 0.01),

                    Row (
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                () => Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.9,
                                      child: Switch.adaptive(
                                        activeColor: Colors.orange,
                                        inactiveThumbColor: Colors.black,
                                        inactiveTrackColor: Colors.grey,
                                        value: productEditController
                                            .isActive
                                            .value,
                                        onChanged: productEditController
                                            .onToggleStatus,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      productEditController.isActive.value
                                          ? "YES"
                                          : "NO",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
          ],
        ),
      ),
    );
  }

  
}
