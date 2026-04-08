class LedgerAttributeEntity {
  String? _partnerCode;
  String? _companyid;
  String? _partyid;
  String? _partyName;
  String? _latitude;
  String? _longitude;
  String? _locationCity;
  String? _route;
  String? _salesPerson;
  String? _area;
  String? _customerClassification;
  String? _customerType;
  String? _beat;
  String? _routeName;
  String? _salesPersonName;
  String? _customerClassificationName;
  String? _customerTypeName;
  String? _beatName;
  String? _areaName;
  String?_status;
  String? _verifiedMobNo;  
  String? _groupName;
  String? constitutionId;
  String? rating;
  String? isbilled;

  LedgerAttributeEntity();
  String? get partnerCode => _partnerCode;
  set partnerCode(value) {
    _partnerCode = value;
  }

  String? get companyId => _companyid;
  set companyId(value) {
    _companyid = value;
  }

  String? get partyId => _partyid;
  set partyId(value) {
    _partyid = value;
  }

  String? get partyName => _partyName;
  set partyName(value) {
    _partyName = value;
  }

  String? get latitude => _latitude;

  set latitude(value) {
    _latitude = value;
  }

  String? get longitude => _longitude;

  set longitude(value) {
    _longitude = value;
  }

  String? get locationCity => _locationCity;

  set locationCity(value) {
    _locationCity= value;
  }

  String? get route => _route;
  set route(value) {
    _route = value;
  }

  String? get salesPerson => _salesPerson;
  set salesPerson(value) {
    _salesPerson = value;
  }

  String? get area => _area;
  set area(value) {
    _area = value;
  }

  String? get customerClassification => _customerClassification;
  set customerClassification(value) {
    _customerClassification = value;
  }

  String? get customerType => _customerType;
  set customerType(value) {
    _customerType = value;
  }

  String? get beat => _beat;
  set beat(value) {
    _beat = value;
  }

  String? get routeName => _routeName;
  set routeName(value) {
    _routeName = value;
  }

  String? get salesPersonName => _salesPersonName;
  set salesPersonName(value) {
    _salesPersonName = value;
  }

  String? get customerClassificationName => _customerClassificationName;
  set customerClassificationName(value) {
    _customerClassificationName = value;
  }

  String? get customerTypeName => _customerTypeName;
  set customerTypeName(value) {
    _customerTypeName = value;
  }

  String? get areaName => _areaName;
  set areaName(value) {
    _areaName = value;
  }

  String? get beatName => _beatName;
  set beatName(value) {
    _beatName = value;
  }

  String? get status => _status;
  set status(value) {
    _status = value;
  }

  String? get verifiedMobNo => _verifiedMobNo;   
  set verifiedMobNo(value) {
    _verifiedMobNo = value;
  }

  String? get groupName => _groupName;
  set groupName(value) {
    _groupName = value;
  }

  LedgerAttributeEntity.fromJson(Map<String, dynamic> json) {
    _partnerCode = json['PARTNER_CODE'];
    _companyid = json['COMPANY_ID'];
    _partyid = json['PARTY_ID'];
    _partyName = json['PARTY_NAME'];
    _latitude = json['LATITUDE'];
    _longitude = json['LONGITUDE'];
    _locationCity = json['LOCATION_CITY'];
    _route = json['ROUTE'];
    _salesPerson = json['SALES_PERSON'];
    _area = json['AREA'];
    _customerClassification = json['CUSTOMER_CLASSIFICATION'];
    _customerType = json['CUSTOMERTYPE'];
    _beat = json['BEAT'];
    _areaName = json['AREA_NAME'];
    _routeName = json['ROUTE_NAME'];
    _customerClassificationName = json['CUSTOMER_CLASSIFICATION_NAME'];
    _customerTypeName = json['CUSTOMERTYPE_NAME'];
    _salesPersonName = json['SALES_PERSON_NAME'];
    _beatName = json['BEAT_NAME'];
    _status = json['STATUS'];
    _verifiedMobNo = json['VERIFIED_MOBILE_NO'];    
    _groupName = json['GROUP_NAME']; 
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_partnerCode != null) {
      data['PARTNER_CODE'] = _partnerCode;
    }
    if (_companyid != null) {
      data['COMPANY_ID'] = _companyid;
    }
    if (_partyid != null) {
      data['PARTY_ID'] = _partyid;
    }
    if (_partyName != null) {
      data['PARTY_NAME'] = _partyName;
    }
    if(_latitude != null){
      data['LATITUDE'] = _latitude;
    }
    if(_longitude != null){
      data['LONGITUDE'] = _longitude;
    }
    if(_locationCity != null){
      data['LOCATION_CITY'] = _locationCity;
    }
    if (_route != null) {
      data['ROUTE'] = _route;
    }
    if (_salesPerson != null) {
      data['SALES_PERSON'] = _salesPerson;
    }
    if (_area != null) {
      data['AREA'] = _area;
    }
    if (_customerClassification != null) {
      data['CUSTOMER_CLASSIFICATION'] = _customerClassification;
    }
    if (_customerType != null) {
      data['CUSTOMERTYPE'] = _customerType;
    }
    if (_beat != null) {
      data['BEAT'] = _beat;
    }
    if (_areaName != null) {
      data['AREA_NAME'] = _areaName;
    }
    if (_routeName != null) {
      data['ROUTE_NAME'] = _routeName;
    }
    if (_customerTypeName != null) {
      data['CUSTOMERTYPE_NAME'] = _customerTypeName;
    }
    if (_customerClassificationName != null) {
      data['CUSTOMER_CLASSIFICATION_NAME'] = _customerClassificationName;
    }
    if (_salesPersonName != null) {
      data['SALES_PERSON_NAME'] = _salesPersonName;
    }
    if (_beatName != null) {
      data['BEAT_NAME'] = _beatName;
    }
    if (_status != null) {
      data['STATUS'] = _status;
    }
    if (_verifiedMobNo != null) {  
      data['VERIFIED_MOBILE_NO'] = _verifiedMobNo;
    }
    if (constitutionId != null) {  
      data['constitutionid'] = constitutionId;
    }
    if (rating != null) {  
      data['rating'] = rating;
    }
    if (isbilled != null) {  
      data['isbilled'] = isbilled;
    }
    return data;
  }
}
