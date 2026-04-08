class PartyAddressEntity {
  String? addressId;
  String? companyId;
  String? tenantId;
  String? retailerCode;
  String? isPrimary;
  String? address1;
  String? address2;
  String? countryId;
  String? stateId;
  String? cityId;
  String? cityAreaId;
  String? localityId;
  String? countryName;
  String? stateName;
  String? cityName;
  String? cityAreaName;
  String? localityName;
  String? pinCode;
  String? geoLatitude;
  String? geoLongitude;
  String? createdAt;
  String? updatedAt;

  PartyAddressEntity();

  PartyAddressEntity.fromMap(Map<String, dynamic> map) {
    addressId = map['addressid'];
    companyId = map['company_id'];
    tenantId = map['tenantid'];
    retailerCode = map['retailer_code'];
    isPrimary = map['isprimary'];
    address1 = map['address1'];
    address2 = map['address2'];
    countryId = map['countryid'];
    stateId = map['stateid'];
    cityId = map['cityid'];
    cityAreaId = map['cityareaid'];
    localityId = map['localityid'];
    countryName = map['countryname'];
    stateName = map['statename'];
    cityName = map['cityname'];
    cityAreaName = map['cityareaname'];
    localityName = map['localityname'];
    pinCode = map['pincode'];
    geoLatitude = map['geo_latitude'];
    geoLongitude = map['geo_longitude'];
    createdAt = map['createdat'];
    updatedAt = map['updatedat'];
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['addressid'] = addressId;
    map['company_id'] = companyId;
    map['tenantid'] = tenantId;
    map['retailer_code'] = retailerCode;
    map['isprimary'] = isPrimary;
    map['address1'] = address1;
    map['address2'] = address2;
    map['countryid'] = countryId;
    map['stateid'] = stateId;
    map['cityid'] = cityId;
    map['cityareaid'] = cityAreaId;
    map['localityid'] = localityId;
    map['countryname'] = countryName;
    map['statename'] = stateName;
    map['cityname'] = cityName;
    map['cityareaname'] = cityAreaName;
    map['localityname'] = localityName;
    map['pincode'] = pinCode;
    map['geo_latitude'] = geoLatitude;
    map['geo_longitude'] = geoLongitude;
    map['createdat'] = createdAt;
    map['updatedat'] = updatedAt;

    return map;
  }
}
