
import 'package:sysconn_sfa/api/entity/taskboard/task_opportunity_create_entity.dart';

class TaskBizOpportunityDropdownEntity {
  final List<TaskOpportunitiesCustomerEntity> customerList;
  // final List<TaskOpportunitiesProductEntity> productList;
  // final List<TaskOpportunitiesPriceListEntity> priceList;

  TaskBizOpportunityDropdownEntity({
    required this.customerList,
    // required this.productList,
    // required this.priceList,
  });

  factory TaskBizOpportunityDropdownEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return TaskBizOpportunityDropdownEntity(
      customerList: (data['customerlist'] as List)
          .map((e) => TaskOpportunitiesCustomerEntity.fromJson(e))
          .toList(),

    //   productList: (data['productlist'] as List)
    //       .map((e) => TaskOpportunitiesProductEntity.fromJson(e))
    //       .toList(),

    //   priceList: (data['pricelist'] as List)
    //       .map((e) => TaskOpportunitiesPriceListEntity.fromJson(e))
    //       .toList(),
    );
  }

}