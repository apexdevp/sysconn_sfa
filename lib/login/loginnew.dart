import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/login/logincontroller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          
          children: [
                 Image.asset(ImageList.loginBackgroundImage,fit: BoxFit.cover,width: size.width,),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageList.loginSFALogoImage,
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.19),
                  Row(
                    children: [
                       SizedBox(width: size.width * 0.10),
                      Text('Welcome', style: TextStyle(fontSize: 26)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: TextFormField(
                            // keyboardType: TextInputType.number,
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              labelStyle: kTxtStl14GreyN,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(color: kAppColor),
                              ),
                              // contentPadding: EdgeInsets.all(8),
                              // prefixIcon: Icon(
                              //   Icons.email,
                              //   color: kIconColor,
                              //   size: 19,
                              // ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(color: kAppIconColor),
                              ),
                            ),
            
                            style: kTxtStl15B,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Obx(
                            () => TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                labelStyle: kTxtStl14GreyN,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(color: kGreyColor),
                                ),
                                // prefixIcon: Icon(Icons.password_outlined,color: kIconColor,size: 19,),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.passwordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () =>
                                      controller.passwordVisible.toggle(),
                                ),
                              ),
                              obscureText: controller.passwordVisible.value,
                              style: kTxtStl15B,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: ResponsiveButton(
                      title: 'LOG IN',
                      function: () async {
                        await controller.login();
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Center(child: Text('Powered by:', style: kTxtStl12N)),
                  SizedBox(height: size.height * 0.01),
                  Image.asset(
                    ImageList.sysconnlogo,
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
