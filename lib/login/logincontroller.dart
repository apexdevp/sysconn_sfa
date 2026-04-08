import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/login/loginentity.dart';
import 'package:sysconn_sfa/routes/navigator_routes.dart';
import 'package:url_launcher/url_launcher.dart';
//Getx 
class LoginController extends GetxController {

  // Text Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observables
  var passwordVisible = true.obs;
  var isChecked = true.obs;
  var currentVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSavedLogin();
  }

  // Load saved email + password
  void getSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('Email_Id') ?? '';
    passwordController.text = prefs.getString('Password') ?? '';
    Utility.useremailid = prefs.getString('Old_User_Email_Id') ?? '';
    update();
  }

  // Validate
  Future<bool> validate() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Alert", "Please enter email ID");
      return false;
    } else if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Alert", "Please enter password");
      return false;
    }
    return true;
  }

  // Save login details
  Future<int> storeLoginDetails(LoginEntity entity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Mobile_No', entity.usermobno ?? "");
    await prefs.setString('UserName', entity.mobusername ?? "");
    await prefs.setString('Email_Id', emailController.text);
    await prefs.setString('Module_Code', entity.modulecode ?? "");
    await prefs.setString('ExpiryDate', entity.expirydate ?? "");
    await prefs.setString('Password', passwordController.text);
    await prefs.setString('Old_User_Email_Id', Utility.useremailid);
    await prefs.setString('User_Type', entity.usertype ?? "");
    return 1;
  }

  Future storeNewUserCmpDetails() async {
    await Utility.saveCompanyDetails('', "Select Company First", '', 'ADMIN', '','');
  }

  // Launch URLs
  void openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    }
  }

  // Login API call
  // Future login() async {
  //   if (!await validate()) return;

  //   Get.dialog(const Center(child: CircularProgressIndicator()),
  //       barrierDismissible: false);

  //   LoginEntity request = LoginEntity();
  //   request.emailid = emailController.text;
  //   request.password = passwordController.text;

  //   var response = await ApiCall.postLoginAPIDet(request);
  //   Get.back(); // close loading

  //   if (response.isEmpty) {
  //     Get.snackbar("Error", "Invalid login details");
  //     return;
  //   }

  //   LoginEntity data = LoginEntity.fromJson(response[0]);

  //   if (data.token == null) {
  //     Get.snackbar("Error", "Please enter valid Mobile Number and Password.");
  //     return;
  //   }

  //   // Validate expiry
  //   if (DateTime.parse(data.expirydate!).isBefore(DateTime.now())) {
  //     Get.snackbar("Alert", "Your login has expired.");
  //     return;
  //   }

  //   // New user company reset
  //   if (data.emailid != Utility.useremailid) {
  //     storeNewUserCompany();
  //   }

  //   // Assign Utility values
  //   Utility.useremailid = emailController.text;
  //   Utility.logintoken = data.token!;
  //   Utility.cmpmobileno = data.usermobno!;
  //   Utility.moduleCode = data.modulecode!;
  //   Utility.loginDmsToken = data.token!;

  //   await storeLoginDetails(data);

  //   // Fetch company details
  //   await Utility.getCompanyDetails();
  //   await ApiCall.getCompanyDataAPI();

  //   Get.toNamed(NavigatorRoutes.homescreen);
  // }
Future login() async {
  bool isValidData = await validate();

  if (!isValidData) {
    Get.back(); // replaces Navigator.pop(context);
    return;
  }

  LoginEntity loginEntity = LoginEntity();
  loginEntity.emailid = emailController.text;
  loginEntity.password = passwordController.text;

  var loginResponseList = await ApiCall.postLoginAPIDet(loginEntity);

  if (loginResponseList.isEmpty) return;

  // Close loader/dialog
  if (Get.isDialogOpen ?? false) Get.back();

  LoginEntity loginReponseEntity =
      LoginEntity.fromJson(loginResponseList[0]);
print( LoginEntity.fromJson(loginResponseList[0]));
print(loginReponseEntity.token);
  if (loginReponseEntity.token == null) {
    Utility.showAlert(
      icons:Icons.error_outline_outlined,
      iconcolor:Colors.redAccent,
      title:'Alert',
      msg:"Please enter valid Mobile Number and Password.",
    );
    return;
  }

  // Validate module
  if (!(loginReponseEntity.modulecode == 'OMS002' ||
        loginReponseEntity.modulecode == 'OMS001')) {
    Utility.showAlert(      
      icons:Icons.error_outline_outlined,
      iconcolor:Colors.redAccent,
      title:'Alert',
      msg:"Invalid Module Code.",
    );
    return;
  }

  // Validate expiry date
  if (!DateTime.parse(loginReponseEntity.expirydate!)
      .isAfter(DateTime.now())) {
    Utility.showAlert(
      icons:Icons.error_outline_outlined,
      iconcolor:Colors.redAccent,
      title:'Alert',
      msg:"Sorry ! Your login has expired."
    );
    return;
  }

  // Store new user details (if changed)
  if (loginReponseEntity.emailid != Utility.useremailid) {
    storeNewUserCmpDetails();
  }

  // Update Utility values (No setState required in GetX)
  Utility.useremailid = emailController.text;
  Utility.logintoken = loginReponseEntity.token!;
  Utility.cmpmobileno = loginReponseEntity.usermobno!;
  Utility.moduleCode = loginReponseEntity.modulecode!;
  Utility.loginDmsToken = loginReponseEntity.token!;
  // Utility.groupCode = loginReponseEntity.groupId!; //Snehal 5-01-2026 add

  await storeLoginDetails(loginReponseEntity);

  await Utility.getCompanyDetails();
  await ApiCall.getCompanyDataAPI();

  // Redirect to Home
  Get.offAllNamed(NavigatorRoutes.homescreen);
}

}
