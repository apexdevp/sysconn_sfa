import 'package:sysconn_sfa/api/entity/company/bank_entity.dart';

class CompanyEntity {
  String? companyid;
  String? companyname;
  String? companyaddress01;
  String? companyaddress02;
  String? companyaddress03;
  String? companycountry;
  String? companystate;
  String? stateCode;
  String? companypincode;
  String? companygstin;
  String? companymobilenumber;
  String? companyemail;
  String? companywebsite;
  String? companyusertype;
  String? mailingname;
  // String? tallysyncdate;
  String? companylogo;
  String? panno;
  // String? ispartyid;
  // String? isvchcode;
  String? partyId;
  String? soVchTypeCode;
  String? soRateType;
  String? bbpsb2bid; //pratiksha p 17-07-2024
  // String? soEnableDelNote;
  List<BankEntity>? bankdetails; //snehal 28-11-2024 add for voucher master
   String? groupId;//Snehal 5-01-2026 add
  CompanyEntity();

  CompanyEntity.formMap(Map<String, dynamic> map) {
    // partnercode = map['customer_unique_code'];
    companyid = map['company_id'];
    companyname = map['company_name'];
    companyaddress01 = map['add_1'];
    companyaddress02 = map['add_2'];
    companyaddress03 = map['add_3'];
    companycountry = map['country'];
    companystate = map['state'];
    stateCode = map['state_code'];
    companypincode = map['pin_code'];
    companygstin = map['gstin'];
    panno = map['pan_no'];
    companymobilenumber = map['mobile_no'];
    companyemail = map['e_mail_id'];
    companywebsite = map['website'];
    companyusertype = map['user_type'];
    mailingname = map['mailing_name'];
    // tallysyncdate = map['sync_date'];
    companylogo = map['company_logo'];
    bbpsb2bid = map["bbps_b2b_id"]; //pratiksha p 17-07-2024 add
     groupId = map['group_id'];//snehal add 5-01-2026
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['company_id'] = companyid;
    map['company_name'] = companyname;
    map['add_1'] = companyaddress01;
    map['add_2'] = companyaddress02;
    map['add_3'] = companyaddress03;
    map['country'] = companycountry;
    map['state'] = companystate;
    map['state_code'] = stateCode;
    map['pin_code'] = companypincode;
    map['gstin'] = companygstin;
    map['mobile_no'] = companymobilenumber;
    map['e_mail_id'] = companyemail;
    map['website'] = companywebsite;
    map['mailing_name'] = mailingname;
    return map;
  }

  CompanyEntity.companyMasterMap(Map<String, dynamic> map) {
    companyid = map['company_id'];
    companyname = map['company_name'];
    companyaddress01 = map['add_1'];
    companyaddress02 = map['add_2'];
    companyaddress03 = map['add_3'];
    companycountry = map['country'];
    companystate = map['state'];
    companypincode = map['pin_code'];
    companygstin = map['gstin'];
    companymobilenumber = map['mobile_no'];
    companyemail = map['e_mail_id'];
    companywebsite = map['website'];
    mailingname = map['mailing_name'];
    panno = map['pan_no'];
    // ispartyid = map['party_id']; //  pratiksha p 16-02-2023 IS_PARTY_ID
    // isvchcode = map['VCHTYPE_CODE']; //  pratiksha p 16-02-2023 IS_VCH_CODE
    partyId = map['party_id'];
    soVchTypeCode = map['so_vch_type_code'];
    soRateType = map['so_rate_type'];
    // soEnableDelNote = map['so_enable_del_note'];
    if (map['bankdetails'] != null) {
      bankdetails = <BankEntity>[];
      map['bankdetails'].forEach((v) {
        bankdetails?.add(BankEntity.fromMap(v));
      });
    }
  }
}
