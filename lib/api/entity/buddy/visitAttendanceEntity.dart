class VisitAttendanceEntity {
  String? companyId;
  String? mobileNo;
  String? partyid;
  String? partyname;
  String? date;
  String? checkintime;
  String? checkinlocation;
  String? checkouttime;
  String? checkoutlocation;
  String? status;
  // String? employeeid;
  String? inLatitude;
  String? inLongitude;
  String? outLatitude;
  String? outLongitude;
  String? totalVisit;
  String? visited;
  String? visitPending;
  String? totalhrs;
  String? visitId;
  String? customertype;
  String? visittype;
  String? address;
  String? pincode;
  String? location;
  String? conPerson;
  String? designation;
  String? partymobileno;
  String? emailid;
  String? leadstatus;
  String? mobUserName;
  String? plannedExisting;
  String? plannedColdVisit;
  String? actualExisting;
  String? actualColdVisit;
  String? pendingExisting;
  String? pendingColdVisit;
  String? remark;
  String? locationUpdate;
  String? verifiedMobNo;
  String? route;
  String? area;
  String? reason;
  String? leadQty;
  String? leadValue;
  String? soQty;
  String? soValue;
  String? salesQty;
  String? salesValue;
  String? collectionValue;
  String? followupCount;
  String? dcQty;
  String? dcValue;
  String? address2;
  String? address3;
  String? state;
  String? gstno;
  String? salesperson;

  VisitAttendanceEntity({
    this.companyId,
    this.mobileNo,
    this.partyid,
    this.partyname,
    this.date,
    this.checkintime,
    this.checkouttime,
    this.checkinlocation,
    this.checkoutlocation,
    this.status,
    // this.employeeid,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.totalhrs,
    this.visitId,
    this.totalVisit,
    this.visitPending,
    this.visited,
    this.customertype,
    this.address,
    this.emailid,
    this.leadstatus,
    this.location,
    this.partymobileno,
    this.conPerson,
    this.designation,
    this.pincode,
    this.visittype,
    this.mobUserName,
    this.plannedExisting,
    this.plannedColdVisit,
    this.actualExisting,
    this.actualColdVisit,
    this.pendingExisting,
    this.pendingColdVisit,
    this.locationUpdate,
    this.verifiedMobNo,
    this.route,
    this.area,
    this.reason,
    this.leadQty,
    this.leadValue,
    this.soQty,
    this.soValue,
    this.salesQty,
    this.salesValue,
    this.collectionValue,
    this.dcQty,
    this.dcValue,
    this.followupCount,
    this.remark,
    this.address2,
    this.address3,
    this.gstno,
    this.state,
    this.salesperson,
  });

  VisitAttendanceEntity.fromJson(Map<String, dynamic> json) {
    companyId = json['COMPANY_ID'];
    mobileNo = json['MOBILE_NO'];
    partyid = json['party_id'];
    partyname = json['party_name'];
    date = json['date'];
    checkintime = json['check_in_time'];
    checkouttime = json['check_out_time'];
    status = json['status'];
    checkinlocation = json['check_in_location'];
    checkoutlocation = json['check_out_location'];
    // employeeid = json['EMPLOYEE_ID'];
    inLatitude = json['IN_LATITUDE'];
    inLongitude = json['IN_LONGITUDE'];
    outLatitude = json['OUT_LATITUDE'];
    outLongitude = json['OUT_LONGITUDE'];
    totalhrs = json['total_hours'];
    visitId = json['visit_id'];
    customertype = json['customer_type'];
    visittype = json['visit_type'];
    address = json['address'];
    pincode = json['pincode'];
    location = json['location'];
    partymobileno = json['party_mobile_no'];
    conPerson = json['contact_person'];
    designation = json['designation'];
    emailid = json['email_id'];
    leadstatus = json['LEAD_STATUS'];
    mobUserName = json['mob_user_name'];
    plannedExisting = json['PLANNED_EXISTING'];
    plannedColdVisit = json['PLANNED_COLD_VISIT'];
    actualExisting = json['ACTUAL_EXISTING'];
    actualColdVisit = json['ACTUAL_COLD_VISIT'];
    pendingExisting = json['PENDING_EXISTING'];
    pendingColdVisit = json['PENDING_COLD_VISIT'];
    remark = json['remark'];
    address2 = json['address_2'];
    address3 = json['address_3'];
    state = json['state'];
    gstno = json['gst_no'];
    salesperson = json['mob_user_name'];
  }

  VisitAttendanceEntity.fromSummaryJson(Map<String, dynamic> json) {
    date = json['date'];
    mobileNo = json['mobile_no'];
    totalVisit = json['NO_OF_COUNTER'];
    visited = json['NO_OF_COUNTER_VISITED'];
    visitPending = json['MARKET_VISIT_PENDING'];
    mobUserName = json['mob_user_name'];
    plannedExisting = json['planned_existing'];
    plannedColdVisit = json['planned_cold_visit'];
    actualExisting = json['actual_existing'];
    actualColdVisit = json['actual_cold_visit'];
    pendingExisting = json['pending_existing'];
    pendingColdVisit = json['pending_cold_visit'];
  }

  VisitAttendanceEntity.fromDetailsRptJson(Map<String, dynamic> json) {
    companyId = json['COMPANY_ID'];
    mobileNo = json['MOBILE_NO'];
    partyid = json['party_id'];
    partyname = json['party_name'];
    date = json['date'];
    checkintime = json['check_in_time'];
    checkouttime = json['check_out_time'];
    status = json['status'];
    checkinlocation = json['check_in_location'];
    checkoutlocation = json['check_out_location'];
    totalhrs = json['total_hours'];
    visitId = json['visit_id'];
    customertype = json['customer_type'];
    visittype = json['visit_type'];
    address = json['address'];
    pincode = json['pincode'];
    location = json['location'];
    partymobileno = json['party_mobile_no'];
    conPerson = json['contact_person'];
    designation = json['designation'];
    emailid = json['email_id'];
    leadstatus = json['lead_status'];
    remark = json['remark'];
    address2 = json['address_2'];
    address3 = json['address_3'];
    state = json['state'];
    gstno = json['gst_no'];
    salesperson = json['mob_user_namex'];
    remark = json['remark'];
    locationUpdate = json['location_update'];
    verifiedMobNo = json['verified_mobile_no'];
    route = json['route'];
    area = json['area'];
    reason = json['reason'];
    leadQty = json['lead_qty'];
    leadValue = json['lead_value'];
    soQty = json['so_qty'];
    soValue = json['so_value'];
    salesQty = json['sales_qty'];
    salesValue = json['sales_value'];
    collectionValue = json['collection_value'];
    dcQty = json['dc_qty'];
    dcValue = json['dc_value'];
    followupCount = json['followup_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (mobileNo != null) {
      data['mobile_no'] = mobileNo;
    }
    if (partyid != null) {
      data['party_id'] = partyid;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (checkintime != null) {
      data['check_in_time'] = checkintime;
    }
    if (checkouttime != null) {
      data['check_out_time'] = checkouttime;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (checkinlocation != null) {
      data['check_in_location'] = checkinlocation;
    }
    if (checkoutlocation != null) {
      data['check_out_location'] = checkoutlocation;
    }
    // if (employeeid != null) {
    //   data['EMPLOYEE_ID'] = employeeid;
    // }
    if (inLatitude != null) {
      data['in_latitude'] = inLatitude;
    }
    if (inLongitude != null) {
      data['in_longitude'] = inLongitude;
    }
    if (outLatitude != null) {
      data['out_latitude'] = outLatitude;
    }
    if (outLongitude != null) {
      data['out_longitude'] = outLongitude;
    }
    if (totalhrs != null) {
      data['total_hours'] = totalhrs;
    }
    if (visitId != null) {
      data['visit_id'] = visitId;
    }
    if (customertype != null) {
      data['customer_type'] = customertype;
    }
    if (visittype != null) {
      data['visit_type'] = visittype;
    }
    if (partyname != null) {
      data['party_name'] = partyname;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (pincode != null) {
      data['pincode'] = pincode;
    }
    if (location != null) {
      data['location'] = location;
    }
    if (partymobileno != null) {
      data['party_mobile_no'] = partymobileno;
    }
    if (conPerson != null) {
      data['contact_person'] = conPerson;
    }
    if (designation != null) {
      data['designation'] = designation;
    }
    if (emailid != null) {
      data['email_id'] = emailid;
    }
    if (leadstatus != null) {
      data['lead_status'] = leadstatus;
    }
    if (mobUserName != null) {
      data['mob_user_name'] = mobUserName;
    }
    if (plannedExisting != null) {
      data['PLANNED_EXISTING'] = plannedExisting;
    }
    if (plannedColdVisit != null) {
      data['PLANNED_COLD_VISIT'] = plannedColdVisit;
    }
    if (actualExisting != null) {
      data['ACTUAL_EXISTING'] = actualExisting;
    }
    if (actualColdVisit != null) {
      data['ACTUAL_COLD_VISIT'] = actualColdVisit;
    }
    if (pendingExisting != null) {
      data['PENDING_EXISTING'] = pendingExisting;
    }
    if (pendingColdVisit != null) {
      data['PENDING_COLD_VISIT'] = pendingColdVisit;
    }
    if (remark != null) {
      data['remark'] = remark;
    }
    if (address2 != null) {
      data['address_2'] = address2;
    }
    if (address3 != null) {
      data['address_3'] = address3;
    }
    if (state != null) {
      data['state'] = state;
    }
    if (gstno != null) {
      data['gst_no'] = gstno;
    }
    if (salesperson != null) {
      data['mob_user_name'] = salesperson;
    }
    return data;
  }
}
