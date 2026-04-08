class LoginEntity {
  String? usermobno;
  String? mobusername;
  String? emailid;
  //  String? partneremailid;
  String? modulecode;
  String? expirydate;
  String? password;
  String? devicename;
  String? usertype;
  String? active;
  String? dbname;
  String? token;
 String? groupId;//Snehal 5-01-2026 add
  LoginEntity();

  LoginEntity.fromJson(Map<String, dynamic> json) {
    usermobno = json['user_mobile_no'];
    mobusername = json['user_name'];
    emailid = json['user_emailid'];
    // partneremailid = json['PARTNER_CODE'];
    modulecode = json['module_code'];
    expirydate = json['user_expiry_date'];
    password = json['user_password'];
    devicename = json['device_name'];
    usertype = json['user_type'];
    active = json['ACTIVE'];
    dbname = json['DB_NM'];
    token = json['token'];
     groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if(usermobno != null){
      data['user_mobile_no'] = usermobno;
    }
    if(mobusername != null){
      data['user_name'] = mobusername;
    }
    if(emailid != null){
      data['user_emailid'] = emailid;
    }
    // if (partneremailid != null) {
    //   data['PARTNER_CODE'] = partneremailid;
    // }
    if(modulecode != null){
      data['module_code'] = modulecode;
    }
    if(expirydate != null){
      data['user_expiry_date'] = expirydate;
    }
    if(password != null){
      data['user_password'] = password;
    }
    if(devicename != null){
      data['device_name'] = devicename;
    }
    if(active != null){
      data['ACTIVE'] = active;
    }
    if(dbname != null){
      data['DB_NM'] = dbname; 
    }
    return data;
  }
  //snehal 29-11-2024 add for forgot password
    Map<String, dynamic> toJsonforgot() {
    var data = <String, dynamic>{};
    if (usermobno != null) {
      data['user_mobile_no'] = usermobno;
    }
    if (password != null) {
      data['password'] = password;
    }
    return data;
  }
}