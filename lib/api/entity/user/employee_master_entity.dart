class EmployeeMasterEntity {
  String? groupId;
  String? companyId;
  String? partnerCode;
  String? employeeName;
  String? employeeGuid;
  String? registeredMobileNo;
  // String? displayName;
  String? departmentid;   // komal // 03-02-2022 // department id node added
  String? department;
  String? employeeNumber;
  String? userType;
  String? dateOfJoining;
  String? designation;
  String? gender;
  String? dateOfBirth;
  String? bloodGroup;
  String? fatherName;
  String? spouseName;
  String? bankName;
  String? bankBranch;
  String? bankAccountNumber;
  String? ifscCode;
  String? resignDate;
  String? pfDateOfReleiving;
  String? reasonForLeaving;
  String? mobileNo;
  String? emailId;
  String? address;
  String? address2;
  String? address3;
  String? pincode;
  String? panNumber;
  String? uanNumber;
  String? pfAcNumber;
  String? esiNumber;
  String? imageEvent;
  String? shiftId;
  String? shiftName;
  String? branch;
  String? branchName;
  // String? isLocCompulsory;
  // String? isShareAccess;
  String? attendanceType;
  String? allowMultiCheckin;
  String? empStatus;
  String? imgPath;
  String? imgSelectedFilePath;
  // String? contactNumber;
  String? fcmToken;
  String? moduleCode;
  String? moduleName;
  // String? expiryDate;
  
  String? enableOt;
  // Manisha 13-06-2025 add two rows
  String? isAllBranchesEnabled;
  String? isCompanyEmployee;
  
  // Manisha // 06-08-2025  // add nominee details
  String? emergencyContactNo;
  String? nomineename;
  String? nomineerelation;
  String? nomineeadd1;
  String? nomineeadd2;
  // Manisha // 11-08-2025  // add email id and contact no
  String? nomineeemailid;
  String? nomineecontactno;
  String? deviceempid;// Manisha // 30-10-2025 // add for ESSL unique id

  EmployeeMasterEntity();

  EmployeeMasterEntity.fromJson(Map<String, dynamic> json) {
    partnerCode = json['group_id'];
    companyId = json['company_id'];
    employeeName = json['employee_name'];
    employeeGuid = json['employee_id'];
    registeredMobileNo =json['registered_mobile_no']; //snehal 11-04-2025 add for
    // displayName = json['display_name'];
    departmentid = json['dept_id'];
    department = json['dept_name'];
    employeeNumber = json['employee_number'];
    userType = json["user_type"];//snehal 12-04-2025 add 
    dateOfJoining = json['date_of_joining'];
    designation = json['designation'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    bloodGroup = json['blood_group'];
    fatherName = json['father_name'];
    spouseName = json['spouse_name'];
    bankName = json['bank_name'];
    bankBranch = json['bank_branch'];
    bankAccountNumber = json['bank_account_number'];
    ifscCode = json['ifsc_code'];
    resignDate = json['resign_date'];
    pfDateOfReleiving = json['pf_date_of_releiving'];
    reasonForLeaving = json['reason_for_leaving'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'];
    address = json['address_1'];
    address2 = json['address_2'];
    address3 = json['address_3'];
    pincode = json['pincode'];
    panNumber = json['pan_number'];
    uanNumber = json['uan_number'];
    pfAcNumber = json['pf_ac_number'];
    esiNumber = json['esi_number'];
    imgPath = json['image_path'];
    imgSelectedFilePath = json['image_selected_file_path'];
    shiftId = json['shift_id'];
    shiftName = json['shift_name'];
    branch = json['branch'];
    branchName = json['branch_name'];
    // isLocCompulsory = json["is_loc_compulsory"]; //snehal 12-04-2025 add 
    // isShareAccess = json["is_share_access"];//snehal 12-04-2025 add
    attendanceType = json["attendance_type"];//snehal 12-04-2025 add 
    allowMultiCheckin = json["allow_multi_checkin"];//snehal 12-04-2025 add 
    empStatus = json['employee_status'];
    fcmToken = json['fcm_token'];
    moduleCode = json['module_code'];
    moduleName = json['module_name'];
    // expiryDate = json['user_expiry_date'];

    // notificationRecvrmobNo = json[''];
    enableOt = json['enable_ot'];
    // Manisha 13-06-2025 add two rows
    isAllBranchesEnabled = json['is_all_branch'];
    isCompanyEmployee = json['is_cmp_emp'];
    // Manisha // 06-08-2025  // add nominee details and contact no
    emergencyContactNo = json['emergency_contact_no'];
    nomineename = json['nominee_name'];
    nomineerelation = json['nominee_relation'];
    nomineeadd1 = json['nominee_add_1'];
    nomineeadd2 = json['nominee_add_2'];
    // Manisha // 11-08-2025  // add email id and contact no
    nomineecontactno = json['nominee_contact_no'];
    nomineeemailid = json['nominee_email_id'];
    deviceempid = json['device_emp_id']; // Manisha // 30-10-2025 // add for ESSL unique id
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = partnerCode;
    data['company_id'] = companyId;
    data['employee_name'] = employeeName;
    data['employee_id'] = employeeGuid;
    // data['registered_mobile_no'] = registeredMobileNo;//snehal 11-04-2025 add
    // data['display_name'] = displayName;
    data['dept_id'] = departmentid;
    // data['dept_name'] = department;
    data['employee_number'] = employeeNumber;
    data['user_type'] = userType;
    data['date_of_joining'] = dateOfJoining;
    data['designation'] = designation;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['blood_group'] = bloodGroup;
    data['father_name'] = fatherName;
    data['spouse_name'] = spouseName;
    data['bank_name'] = bankName;
    data['bank_branch'] = bankBranch;
    data['bank_account_number'] = bankAccountNumber;
    data['ifsc_code'] = ifscCode;
    data['resign_date'] = resignDate;
    data['pf_date_of_releiving'] = pfDateOfReleiving;
    data['reason_for_leaving'] = reasonForLeaving;
    data['mobile_no'] = mobileNo;
    data['email_id'] = emailId;
    data['address_1'] = address;
    data['address_2'] = address2;
    data['address_3'] = address3;
    data['pincode'] = pincode;
    data['pan_number'] = panNumber;
    data['uan_number'] = uanNumber;
    data['pf_ac_number'] = pfAcNumber;
    data['esi_number'] = esiNumber;
    data['image_path']= imgPath;
    data['image_selected_file_path']= imgSelectedFilePath;
    data['shift_id'] = shiftId;
    data['branch'] = branch;
    // data['is_loc_compulsory'] = isLocCompulsory;
    // data['is_share_access'] = isShareAccess;
    data['attendance_type'] = attendanceType;
    data['allow_multi_checkin'] = allowMultiCheckin;
    data['employee_status'] = empStatus;
    // Manisha 13-06-2025 add two rows
    data['is_all_branch'] = isAllBranchesEnabled;
    data['is_cmp_emp'] = isCompanyEmployee;
    // Manisha // 06-08-2025  // add alternate contact
    if (emergencyContactNo != null) {
      data['emergency_contact_no'] = emergencyContactNo;
    }
    // Manisha // 06-08-2025  // add nominee details
    if (nomineename != null) {
      data['nominee_name'] = nomineename;
    }
    if (nomineerelation != null) {
      data['nominee_relation'] = nomineerelation;
    }
    if (nomineeadd1 != null) {
      data['nominee_add_1'] = nomineeadd1;
    }
    if (nomineeadd2 != null) {
      data['nominee_add_2'] = nomineeadd2;
    }
    // Manisha // 11-08-2025  // add email id and contact no
    if (nomineecontactno != null) {
      data['nominee_contact_no'] = nomineecontactno;
    }
    if (nomineeemailid != null) {
      data['nominee_email_id'] = nomineeemailid;
    }
    return data;
  }
}