class UserEntity{
  String? _customeruniquecode;
  String? _companyid;
  String? _mobileno;
  String? _username;
  String? _emailid;
  String? _usertype;
  String? _devicename;
  String? _active;
  String? _salesperson;    // komal // allow access
  String? _ledgergroupcreditor;    // komal // allow access
  String? _stockgroup;   // komal // allow access
  String? _backdatedaccess;    // komal // allow access
  String? _partyaccess;    // komal // allow access
  String? _ledgeraccess;   // komal // allow access
  String? _stockitemaccess;    // komal // allow access
  String? _employeeid;    // komal // employee id added
  String? _iouledgerid;   // komal // 8-3-2022 // iou ledger id
  String? _iouledgername;   // komal // 8-3-2022 // iou ledger name
  String? _locationid; // Komal D 29-03-2022 add location id 
  String? _islocompulsory; 
  String? _issharedaccess;
  String? _modulename;
  String? _modulecode;
  String? _attendancetype; // mayuri 12-12-2022 add  _attendancetype
  String? _partyid;   // komal // 15-2-2023 // party id added for retailer app
  String? _partyname;   // komal // 15-2-2023 // party id added for retailer app
  String? _fcmtoken; //snehal 1-07-2023 add fcm token for notification

  String? customerviewdata; //add for customer key search  // akshay


  UserEntity();

  String? get customeruniquecode => _customeruniquecode;
  set customeruniquecode(value){
    _customeruniquecode = value;
  }

  String? get companyid => _companyid;
  set companyid(value){
    _companyid = value;
  }

  String? get mobileno => _mobileno;
  set mobileno(value){
    _mobileno = value;
  }

  String? get username => _username;
  set username(value){
    _username = value;
  }

  String? get emailid => _emailid;
  set emailid(value){
    _emailid = value;
  }

  String? get usertype => _usertype;
  set usertype(value){
    _usertype = value;
  }

  String? get devicename => _devicename;
  set devicename(value){
    _devicename = value;
  }

  String? get active => _active;
  set active(value){
    _active = value;
  }

  String? get salesperson => _salesperson;   // komal // allow access
  set salesperson(value){
    _salesperson = value;
  }

  String? get ledgergroupcreditor => _ledgergroupcreditor;   // komal // allow access
  set ledgergroupcreditor(value){
    _ledgergroupcreditor = value;
  }

  String? get stockgroup => _stockgroup;   // komal // allow access
  set stockgroup(value){
    _stockgroup = value;
  }

  String? get backdatedaccess => _backdatedaccess;   // komal // allow access
  set backdatedaccess(value){
    _backdatedaccess = value;
  }

  String? get partyaccess => _partyaccess;   // komal // allow access
  set partyaccess(value){
    _partyaccess = value;
  }

  String? get ledgeraccess => _ledgeraccess;   // komal // allow access
  set ledgeraccess(value){
    _ledgeraccess = value;
  }

  String? get stockitemaccess => _stockitemaccess;   // komal // allow access
  set stockitemaccess(value){
    _stockitemaccess = value;
  }

  String? get employeeid => _employeeid;   // komal // employee id added
  set employeeid(value){
    _employeeid = value;
  }

  String? get iouledgerid => _iouledgerid;   // komal // 8-3-2022 // iou ledger id added
  set iouledgerid(value){
    _iouledgerid = value;
  }

  String? get iouledgername => _iouledgername;   // komal // 8-3-2022 // iou ledger name added
  set iouledgername(value){
    _iouledgername = value;
  }

  String? get locationId => _locationid;    //komal D  29-3-2022  location id  added
  set locationId(value){
    _locationid = value;
  }
String? get isloccompulsory => _islocompulsory;
  set isloccompulsory(value) {
    _islocompulsory = value;
  }

  String? get isshareaccess => _issharedaccess;
  set isshareaccess(value) {
    _issharedaccess = value;
  }
  String? get modulename => _modulename;
  set modulename(value) {
    modulename = value;
  }
  String? get modulecode => _modulecode;
  set modulecode(value) {
    modulecode = value;
  }
  
  String? get attendancetype => _attendancetype; // mayuri 12-12-2022 add  _attendancetype
  set attendancetype(value){
    _attendancetype = value;
  }

  String? get partyid => _partyid;   // komal // 15-2-2023 // party id added for retailer app 
  set partyid(value){
    _partyid = value;
  }

  String? get partyname => _partyname;   // komal // 15-2-2023 // party name added for retailer app 
  set partyname(value){
    _partyname = value;
  }
 String? get fcmtoken => _fcmtoken; // snehal 1-07-2023 add fcmtoken for notification
  set fcmtoken(value) {
    _fcmtoken = value;
  }
  
  UserEntity.map(dynamic obj){
    _customeruniquecode = obj['CUSTOMER_UNIQUE_CODE'];
    _companyid = obj['COMPANY_ID'];
    _mobileno = obj['MOBILE_NO'];
    _username = obj['MOB_USER_NAME'];
    _emailid = obj['EMAIL_ID'];
    _usertype = obj['USER_TYPE'];
    _devicename = obj['DEVICE_NAME'];
    _active = obj['ACTIVE'];
    _salesperson = obj['LED_GROUP_DEBTOR'];   // komal // allow access
    _ledgergroupcreditor = obj['LED_GROUP_CREDITOR'];
    _stockgroup = obj['STOCK_GROUP'];
    _backdatedaccess = obj['ALLOWED_BACK_DATED_ACCESS'];
    _partyaccess = obj['PARTY_MASTER_ACCESS'];
    _ledgeraccess = obj['LEDGER_ACCESS'];
    _stockitemaccess = obj['STOCK_ITEM_ACCESS'];
    _employeeid = obj['EMPLOYEE_ID'];   // komal // employee id added
    _iouledgerid = obj['IOU_LEDGER_ID'];   // komal // 8-3-2022 // iou ledger id added
    _iouledgername = obj['IOU_LEDGER_NAME'];   // komal // 8-3-2022 // iou ledger name added
    _locationid = obj['LOCATION'];   // Komal D 29-03-2022 add location id 
    _islocompulsory = obj['IS_LOC_COMPULSORY'];
    _issharedaccess = obj['IS_SHARE_ACCESS'];
    _modulename = obj['MODULE_NAME'];
    _modulecode = obj['MODULE_CODE'];
    _attendancetype = obj['ATTENDANCE_TYPE']; // mayuri 12-12-2022 add  _attendancetype
    _partyid = obj['PARTY_ID'];   // komal // 15-2-2023 // party id added for retailer app
    _partyname = obj['PARTY_NAME'];   // komal // 15-2-2023 // party name added for retailer app
  }

  
  UserEntity.fromMap(Map<String, dynamic> map) {
    companyid = map['company_id'];
    mobileno = map['mobile_no'];
    username = map['user_name'];
    emailid = map['user_emailid'];
    usertype = map['user_type'];
    fcmtoken = map['fcm_token'];
    customerviewdata = map['customer_view_data'];  //add for customer key search  // akshay

  }
 

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{};
    map['CUSTOMER_UNIQUE_CODE'] = _customeruniquecode;
    map['COMPANY_ID'] = _companyid;
    map['MOBILE_NO'] = _mobileno;
    map['MOB_USER_NAME'] = _username;
    map['EMAIL_ID'] = _emailid;
    map['USER_TYPE'] = _usertype;
    map['DEVICE_NAME'] = _devicename;
    map['ACTIVE'] = _active;
    map['LED_GROUP_DEBTOR'] = _salesperson;
    map['LED_GROUP_CREDITOR'] = _ledgergroupcreditor;
    map['STOCK_GROUP'] = _stockgroup;
    map['ALLOWED_BACK_DATED_ACCESS'] = _backdatedaccess;
    map['PARTY_MASTER_ACCESS'] = _partyaccess;
    map['LEDGER_ACCESS'] = _ledgeraccess;
    map['STOCK_ITEM_ACCESS'] = _stockitemaccess;
    map['EMPLOYEE_ID'] = _employeeid;    // komal // employee id added
    map['IOU_LEDGER_ID'] = _iouledgerid;    // komal // 8-3-2022 // iou ledger id added
    map['IOU_LEDGER_NAME'] = _iouledgername;    // komal // 8-3-2022 // iou ledger name added
    map['LOCATION'] = _locationid; // Komal D 29-03-2022 add location id
    map['IS_LOC_COMPULSORY'] =  _islocompulsory; 
    map['IS_SHARE_ACCESS'] = _issharedaccess;
    map['MODULE_NAME'] = _modulename;
    map['ATTENDANCE_TYPE'] = _attendancetype; // mayuri 12-12-2022 add  _attendancetype
    map['PARTY_ID'] = _partyid;   // komal // 15-2-2023 // party id added for retailer app
    map['customer_view_data'] = customerviewdata;   //add for customer key search  // akshay

    return map;
  }
}

// komal // multiple group entity

class MultipleGroupSelectEntity {
 String? _id;
 String? _name;

 MultipleGroupSelectEntity();

 String get id => _id!;
  set id(value){
    _id = value;
  }

  String get name => _name!;
  set name(value){
    _name = value;
  }

 MultipleGroupSelectEntity.map(dynamic obj){
    _id = obj['ID'];
    _name = obj['NAME'];
 }

 MultipleGroupSelectEntity.formMap(Map<String, dynamic> map){
    _id = map['ID'];
    _name = map['NAME'];
 }

 Map<String, dynamic> toMap(){
    var map = <String, dynamic>{};
    map['ID'] = _id;
    map['NAME'] = _name;
    return map;
 }
}