

import 'package:sysconn_sfa/api/entity/company/customer_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_city_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_pricelist_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_refferedby_entity.dart';

class CustomerMasterDataEntity {
  final List<CustomerCategoryEntity> constitution;
  final List<CustomerCategoryEntity> segment;
  final List<CustomerPricelistEntity> priceList;
  final List<CustomerCategoryEntity> group;
  final List<CustomerRefferedbyEntity> refferedBy;

  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final List<CustomerCityEntity> cities;
  final List<AreaEntity> areas;
  final List<LocalityEntity> localities;

  CustomerMasterDataEntity({
    required this.constitution,
    required this.segment,
    required this.priceList,
    required this.group,
    required this.refferedBy,
    required this.countries,
    required this.states,
    required this.cities,
    required this.areas,
    required this.localities,
  });

  factory CustomerMasterDataEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CustomerMasterDataEntity(
      constitution: (data['constitution'] as List)
          .map((e) => CustomerCategoryEntity.fromJson(e))
          .toList(),
      segment: (data['segment'] as List)
          .map((e) => CustomerCategoryEntity.fromJson(e))
          .toList(),
      priceList: (data['price_list'] as List)
          .map((e) => CustomerPricelistEntity.fromJson(e))
          .toList(),
      group: (data['group'] as List)
          .map((e) => CustomerCategoryEntity.fromJson(e))
          .toList(),
      refferedBy: (data['reffered'] as List)
          .map((e) => CustomerRefferedbyEntity.fromJson(e))
          .toList(),
      countries: (data['country'] as List)
          .map((e) => CountryEntity.fromJson(e))
          .toList(),
      states: (data['state'] as List)
          .map((e) => StateEntity.fromJson(e))
          .toList(),
      cities: (data['cities'] as List)
          .map((e) => CustomerCityEntity.fromJson(e))
          .toList(),
      areas: (data['area'] as List).map((e) => AreaEntity.fromJson(e)).toList(),
      localities: (data['locality'] as List)
          .map((e) => LocalityEntity.fromJson(e))
          .toList(),
    );
  }
}
