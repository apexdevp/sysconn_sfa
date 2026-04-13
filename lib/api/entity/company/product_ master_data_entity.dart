
import 'package:sysconn_sfa/api/entity/company/product_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_group_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_unit_entity.dart';

class ProductMasterDataEntity {
  final List<ProductCategoryEntity> category;
  final List<ProductSubCategoryEntity> subCategory;
  final List<ProductGrpEntity> group;
  final List<ProductUOMEntity> unit;

  ProductMasterDataEntity({
    required this.category,
    required this.subCategory,
    required this.group,
    required this.unit,
  });

  factory ProductMasterDataEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProductMasterDataEntity(
      category: (data['category'] as List)
          .map((e) => ProductCategoryEntity.fromJson(e))
          .toList(),
      subCategory: (data['subcategory'] as List)
          .map((e) => ProductSubCategoryEntity.fromJson(e))
          .toList(),
      group: (data['group'] as List)
          .map((e) => ProductGrpEntity.fromJson(e))
          .toList(),
      unit: (data['unit'] as List)
          .map((e) => ProductUOMEntity.fromJson(e))
          .toList(),
    );
  }
}
