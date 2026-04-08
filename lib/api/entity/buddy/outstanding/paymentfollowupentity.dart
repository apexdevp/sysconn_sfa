class PaymentFollowupEntity {
  String? partnerCode;
  String? companyId;
  String? partyId;
  String? mobileNo;
  String? followUpAmount;
  String? lsFollowUpDoneWith;
  String? contact;
  String? nextFollowUpTime;
  String? remarks;
  String? nextFollowUpDate;
  String? lsRemark;
  String? lsContact;
  String? todayFollowupDoneWith;
  String? date;
  String? followUpBy;
  String? lastFollowupDate;
  String? overDueAmount;
  String? outstandingAmount;
  String? todaysFollowUp;
  String? monthlyFollowup;
  String? partyName;
  String? followuptype;
  String? emailid;

  PaymentFollowupEntity(
      {this.companyId,
      this.partnerCode,
      this.partyId,
      this.mobileNo,
      this.followUpAmount,
      this.lsFollowUpDoneWith,
      this.contact,
      this.nextFollowUpDate,
      this.remarks,
      this.nextFollowUpTime,
      this.lsRemark,
      this.lsContact,
      this.todayFollowupDoneWith,
      this.date,
      this.followUpBy,
      this.lastFollowupDate,
      this.outstandingAmount,
      this.overDueAmount,
      this.monthlyFollowup,
      this.todaysFollowUp,
      this.partyName,
      this.followuptype,
      this.emailid});

  PaymentFollowupEntity.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    partyId = json['party_id'];
    mobileNo = json['mobile_no'];
    followUpAmount = json['followup_amount'];
    lsFollowUpDoneWith = json['last_followup_done_with'];
    contact = json['contact'];
    nextFollowUpDate = json['next_followup_date'];
    remarks = json['remarks'];
    nextFollowUpTime = json['next_followup_time'];
    lsRemark = json['last_remark'];
    lsContact = json['last_contact'];
    todayFollowupDoneWith = json['today_followup_done_with'];
    date = json['date'];
    followUpBy = json['followup_by'];
    lastFollowupDate = json['last_followup_date'];
    overDueAmount = json['overdue_amount'];
    outstandingAmount = json['outstanding_amount'];
    todaysFollowUp = json['todays_followup'];
    monthlyFollowup = json['monthly_followup'];
    partyName = json['party_name'];
  }

// PaymentFollowupEntity.fromJson(Map<String, dynamic> json) {
//     companyId = json['COMPANY_ID'];
//     partnerCode = json['PARTNER_CODE'];
//     partyId = json['PARTY_ID'];
//     mobileNo = json['MOBILE_NO'];
//     followUpAmount = json['FOLLOWUP_AMOUNT'];
//     lsFollowUpDoneWith = json['LAST_FOLLOWUP_DONE_WITH'];
//     contact = json['CONTACT'];
//     nextFollowUpDate = json['NEXT_FOLLOWUP_DATE'];
//     remarks = json['REMARKS'];
//     nextFollowUpTime = json['NEXT_FOLLOWUP_TIME'];
//     lsRemark = json['LAST_REMARK'];
//     lsContact = json['LAST_CONTACT'];
//     todayFollowupDoneWith = json['TODAY_FOLLOWUP_DONE_WITH'];
//     date = json['DATE'];
//     followUpBy = json['FOLLOWUP_BY'];
//     lastFollowupDate = json['LAST_FOLLOWUP_DATE'];
//     overDueAmount = json['OVERDUE_AMOUNT'];
//     outstandingAmount = json['OUTSTANDING_AMOUNT'];
//     todaysFollowUp =
//         json['TODAYS_FOLLOWUP']; //snehal 28-07-2022 add todaysFollowUp
//     monthlyFollowup =
//         json['MONTHLY_FOLLOWUP']; //snehal 28-07-2022 add monthlyFollowup
//     partyName = json['PARTY_NAME']; //snehal 28-07-2022 add partyName
//   }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (mobileNo != null) {
      data['mobile_no'] = mobileNo;
    }
    if (partyId != null) {
      data['party_id'] = partyId;
    }
    if (followUpAmount != null) {
      data['followup_amount'] = followUpAmount;
    }
    if (lsFollowUpDoneWith != null) {
      data['last_followup_done_with'] = lsFollowUpDoneWith;
    }
    if (contact != null) {
      data['contact'] = contact;
    }
    if (nextFollowUpDate != null) {
      data['next_followup_date'] = nextFollowUpDate;
    }
    if (remarks != null) {
      data['remarks'] = remarks;
    }
    if (nextFollowUpTime != null) {
      data['next_followup_time'] = nextFollowUpTime;
    }
    if (lsRemark != null) {
      data['last_remark'] = lsRemark;
    }
    if (lsContact != null) {
      data['last_contact'] = lsContact;
    }
    if (todayFollowupDoneWith != null) {
      data['today_followup_done_with'] = todayFollowupDoneWith;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (followUpBy != null) {
      data['followup_by'] = followUpBy;
    }
    if (lastFollowupDate != null) {
      data['last_followup_date'] = lastFollowupDate;
    }
    if (overDueAmount != null) {
      data['overdue_amount'] = overDueAmount;
    }
    if (outstandingAmount != null) {
      data['outstanding_amount'] = outstandingAmount;
    }
    if (followuptype != null) {
      data['followup_type'] = followuptype;
    }
    if (emailid != null) {
      data['email_id'] = emailid;
    }
    return data;
  }
}
