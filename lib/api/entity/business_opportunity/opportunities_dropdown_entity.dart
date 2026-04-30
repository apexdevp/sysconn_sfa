import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_customer_entity.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_product_entity.dart';

class BizOpportunityDropdownEntity {
  final List<OpportunitiesCustomerEntity> customerList;
  final List<OpportunitiesProductEntity> productList;
  final List<OpportunitiesPriceListEntity> priceList;

  BizOpportunityDropdownEntity({
    required this.customerList,
    required this.productList,
    required this.priceList,
  });

  factory BizOpportunityDropdownEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return BizOpportunityDropdownEntity(
      customerList: (data['customerlist'] as List)
          .map((e) => OpportunitiesCustomerEntity.fromJson(e))
          .toList(),

      productList: (data['productlist'] as List)
          .map((e) => OpportunitiesProductEntity.fromJson(e))
          .toList(),

      priceList: (data['pricelist'] as List)
          .map((e) => OpportunitiesPriceListEntity.fromJson(e))
          .toList(),
    );
  }

}