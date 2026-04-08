class PartyEntity {
  String? distributorCode;
  String? partyId;
  String? partyName;
  String? address;
  String? state;
  String? pinCode;
  String? contactPerson;
  String? contactNo;
  String? partyMobNo;
  String? gstIn;
  String? mailingname;
  String? pricelist;
  String? customerClassification;
  String? email;
  String? latitude;
  String? longitude;
  String? salesPerson;
  String? salesPersonName;
  String? area;
  String? areaName;
  String? beat;
  String? beatName;
  String? route;
  String? routeName;
  String? customerType;
  String? customerTypeName;
  String? customerClassificationName;
  String? verifiedMobNo;
  String? vanumber;
  String? panno;
  String? creditdays;
  String? creditlimit;
  String? locationcity;
  //Rupali 19-10-2024
  String? bbpsB2bId;
  String? city;
  String? partytype;
  String? partyCreatedDate;
  String? tallystatus;
  String? tallysyncdate;
  String? groupid; //Rupali 27-11-2024
  String? groupname; //Rupali 27-11-2024
  String? npciLedgerName;
  String? partygroup;
  String? primaryGroup;
  String? partyGroupName;
  String? partyType;

  // Manoj 23-02-2026 Add new columns
  String? retailerCode;
  String? retailerName;
  String? segmentId;
  String? segmentName;
  String? constitutionId;
  String? constitutionname;
  // String? active;
    int? active; //Manisha C 27-03-2026 added
  String? isBilled;
  String? stateId;
  String? cityId;
  String? cityAreaId;
  String? cityAreaName;
  String? localityId;
  String? localityName;
  String? incorporationDate;
  String? remark;
  String? influencerUserId;
  String? influencerUserName;
  String? rating;
  String? existingId;
  String? countryId;
  String? companyId;
   String? address1;
  String? address2;
 
  PartyEntity();

  PartyEntity.formPartyMap(Map<String, dynamic> map) {
    distributorCode = map['distributor_code'];
    partyId = map['party_id'];
    partyName = map['retailer_name'];//party_name
    // partyGroupName = map['party_group_name'];
    // address1 = map['add_1'];
    // address2 = map['add_2'];
    // address3 = map['add_3'];
    address = map['address'];
    state = map['state'];
    // country = map['country'];
    pinCode = map['pin_code'];
    contactPerson = map['contact_person'];
    contactNo = map['phone_number'];
    partyMobNo = map['mobile_no'];
    gstIn = map['gstin'];
    mailingname = map['mailing_name'];
    pricelist = map['pricelist'];
    creditdays = map['credit_days'];
    creditlimit = map['credit_limit'];
    customerClassification = map['customer_classification'];
    latitude = map['lattitude'];
    longitude = map['longitude'];
    salesPerson = map['sales_person'];
    salesPersonName = map['sales_person_name'];
    area = map['area'];
    areaName = map['area_name'];
    beat = map['beat'];
    beatName = map['beat_name'];
    route = map['route'];
    routeName = map['route_name'];
    customerType = map['customertype'];
    customerTypeName = map['customertpe_name'];
    customerClassificationName = map['customer_classification_name'];
    verifiedMobNo = map['VERIFIED_MOBILE_NO'];
    vanumber = map['va_number'];
    // mailingname = map['mailing_name'];
    email = map['email_id'];
    panno = map['pan_no'];
    locationcity = map['location_city'];
    //Rupali 19-10-2024
    bbpsB2bId = map['bbps_b2b_id'];
    city = map['city'];
    partytype = map['party_type'];
    partyCreatedDate = map['creation_date'];
    tallystatus = map['tally_status'];
    tallysyncdate = map['tally_sync_date'];
    //Rupali 27-11-2024
    groupid = map['party_group'];
    groupname = map['party_group_name'];
    //snehal add
    npciLedgerName = map['npci_ledger_name'];
    partygroup = map['party_group'];
    primaryGroup = map['primary_group'];
    partyGroupName = map['party_group_name'];

    retailerCode = map['retailer_code'];
    retailerName = map['retailer_name'];
    segmentId = map['segmentid'];
    segmentName = map['segmentname'];
    constitutionId = map['constitutionid'];
    constitutionname = map['constitutionname'];
    // active = map['active_status'];
     active = map['active_status'] == null
    ? null
    : int.tryParse(map['active_status'].toString());
    isBilled = map['isbilled'];
    stateId = map['stateid'];
    cityId = map['cityid'];
    cityAreaId = map['cityareaid'];
    cityAreaName = map['cityareaname'];
    localityId = map['localityid'];
    localityName = map['localityname'];
    incorporationDate = map['incorporationdate'];
    remark = map['remark'];
    influencerUserId = map['influenceruserid'];
    influencerUserName = map['influencerusername'];
    rating = map['rating'];
    existingId = map['existing_id'];
    countryId = map['countryid'];
    companyId = map['company_id'];
    partyType = map['party_type'];
    address1 = map['add_1'];
    address2 = map['add_2'];
  }

  //Rupali 17-10-2024
   Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (companyId != null) {
      map['company_id'] = companyId;
    }
    if (partyId != null) {
      map['party_id'] = partyId;
    }
    if (partyName != null) {
      map['party_name'] = partyName;
    }
    if (address != null) {
      map['address'] = address;
    }
    if (state != null) {
      map['state'] = state;
    }
    if (pinCode != null) {
      map['pin_code'] = pinCode;
    }
    if (contactPerson != null) {
      map['contact_person'] = contactPerson;
    }
    if (contactNo != null) {
      map['phone_number'] = contactNo;
    }
    if (email != null) {
      map['email_id'] = email;
    }
    if (gstIn != null) {
      map['gstin'] = gstIn;
    }
    if (mailingname != null) {
      map['mailing_name'] = mailingname;
    }
    if (panno != null) {
      map['pan_no'] = panno;
    }
    if (partyMobNo != null) {
      map['mobile_no'] = partyMobNo;
    }
    if (creditdays != null) {
      map['credit_days'] = creditdays;
    }
    if (creditlimit != null) {
      map['credit_limit'] = creditlimit;
    }
    if (pricelist != null) {
      map['pricelist'] = pricelist;
    }
    if (distributorCode != null) {
      map['distributor_code'] = distributorCode;
    }
    if (city != null) {
      //komal D 08-08-2024 added city
      map['city'] = city;
    }
    if (partygroup != null) {
      //pratiksha p 14-08-2024 add partygroup
      map['party_group'] = partygroup;
    }
    if (partyType != null) {
      map['party_type'] = partyType;
    }
    if (groupid != null) {
      // sakshi 09/01/2025
      map['group_id'] = groupid;
    }

    if (retailerCode != null) {
      map['retailer_code'] = retailerCode;
    }
    if (retailerName != null) {
      map['retailer_name'] = retailerName;
    }
    if (segmentId != null) {
      map['segmentid'] = segmentId;
    }
    if (segmentName != null) {
      map['segmentname'] = segmentName;
    }
    if (constitutionId != null) {
      map['constitutionid'] = constitutionId;
    }
    if (constitutionname != null) {
      map['constitutionname'] = constitutionname;
    }
    if (constitutionname != null) {
      map['constitutionname'] = constitutionname;
    }
    if (active != null) {
      map['active_status'] = active;
    }
    if (isBilled != null) {
      map['isbilled'] = isBilled;
    }
    if (stateId != null) {
      map['stateid'] = stateId;
    }
    if (cityId != null) {
      map['cityid'] = cityId;
    }
    if (cityAreaId != null) {
      map['cityareaid'] = cityAreaId;
    }
    if (cityAreaName != null) {
      map['cityareaname'] = cityAreaName;
    }
    if (localityId != null) {
      map['localityid'] = localityId;
    }
    if (localityName != null) {
      map['localityname'] = localityName;
    }
    if (incorporationDate != null) {
      map['incorporationdate'] = incorporationDate;
    }
    if (remark != null) {
      map['remark'] = remark;
    }
    if (influencerUserId != null) {
      map['influenceruserid'] = influencerUserId;
    }
    if (influencerUserName != null) {
      map['influencerusername'] = influencerUserName;
    }
    if (rating != null) {
      map['rating'] = rating;
    }
    if (existingId != null) {
      map['existing_id'] = existingId;
    }
    if (countryId != null) {
      map['countryid'] = countryId;
    }
    if (companyId != null) {
      map['company_id'] = companyId;
    }
    return map;
  }

  Map<String, dynamic> tolocationMap() {
    var map = <String, dynamic>{};
    if (partyId != null) {
      map['party_id'] = partyId;
    }
    if (longitude != null) {
      map['longitude'] = longitude;
    }
    if (latitude != null) {
      map['latitude'] = latitude;
    }

    if (distributorCode != null) {
      map['distributor_code'] = distributorCode;
    }
    if (locationcity != null) {
      map['location_city'] = locationcity;
    }
    if (groupid != null) {
      //Rupali 27-11-2024
      map['party_group'] = groupid;
    }
    if (groupname != null) {
      //Rupali 27-11-2024
      map['party_group_name'] = groupname;
    }
    return map;
  }
}
