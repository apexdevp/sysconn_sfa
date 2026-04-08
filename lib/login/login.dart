import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/login/logincontroller.dart';
//Getx 
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height *0.84,
              width: size.width,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(238, 242, 251, 1),
                borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(
                  MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Column(
            
                children: [
                  Padding(padding: const EdgeInsets.only(top: 120),
                  child: Image.asset(
                    ImageList.sysconnlogo,
                    height: size.height * 0.08,
                    width: size.width * 0.8,
                  ),),
                  SizedBox(height: size.height * 0.02),
                  
                  SizedBox(
                    width: size.width * 0.85,
                    height: size.height * 0.58,
                    child: Card(
                      elevation: 12,
                      child: Column(
                        children: [
                          //Business book logo
                          Padding(padding: EdgeInsets.only(top: 25, left: 10, right: 13, bottom: 0),
                        child: Column(
                          children: [
                            Text('Welcome to',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                            SizedBox(
                              child: Image(image: AssetImage('assets/images/Sfa.png',),
                              height:size.height * 0.14,
                              width:size.width * 0.5 ,
                              ),
                            )
                          ],
                        ),
                        ),
                          // Email
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 18),
                              child: GradientIcon(
                                icon: Icons.person,
                                gradient: LinearGradient(
                                  colors: [
                                      Color.fromARGB(255, 190, 86, 25),
                                      Color.fromARGB(255, 192, 114, 70),
                                      Color.fromARGB(255, 190, 86, 25),
                                    ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                size: 26,
                              ),
                            ),
                            hintStyle:const TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(22.0),
                            borderSide:BorderSide(color: kAppColor)),                              ),
                            ),
                          ),

                          // Password
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Obx(() => TextFormField(
                              controller: controller.passwordController,
                              obscureText: controller.passwordVisible.value,
                              decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.passwordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () =>
                                      controller.passwordVisible.toggle(),
                                ),
                                fillColor:const Color.fromRGBO(245, 250, 253, 1),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none),
                              prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: GradientIcon(
                                icon: Icons.lock,gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 190, 86, 25),
                                  const Color.fromARGB(255, 192, 114, 70),
                                  const Color.fromARGB(255, 190, 86, 25),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  ),
                                  size: 26,
                                  ),
                                ),
                              hintStyle:const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:BorderRadius.circular(22.0),
                                borderSide:BorderSide(color: kAppColor)),
                              ),
                            )),
                          ),

                          // Login Button
                          // InkWell(
                          //   onTap: () => controller.login(),
                          //   child: Container(
                          //     height: size.height * 0.06,
                          //     width: size.width * 0.4,
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           Color(0xFF862423),
                          //           Color(0xFFE27969),
                          //         ],
                          //       ),
                          //       borderRadius: BorderRadius.circular(22),
                          //     ),
                          //     alignment: Alignment.center,
                          //     child: Text("Get Started",
                          //         style: kTxtStl14WN),
                          //   ),
                          // ),
                          InkWell(
                                child: SizedBox(
                                  height: size.height * 0.06,
                                  width: size.width * 0.4,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:const BorderRadius.all(Radius.circular(22)), 
                                      // gradient: LinearGradient(
                                      //   colors: [
                                      //   Color.fromRGBO(134, 36, 35, 1),//pratiksha p 31-01-2025 change opacity as in new version  color was showing white
                                      //   Color.fromRGBO(226, 121, 105, 1),
                                      //   Color.fromRGBO(143, 46, 42, 1),
                                      //   Color.fromRGBO(231, 126, 109, 1),
                                      //   Color.fromRGBO(134, 36, 35, 1),
                                      //   ],
                                      //   begin: Alignment.centerLeft,
                                      //   end: Alignment.centerRight,
                                      // ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Get Started",textAlign: TextAlign.center,style: kTxtStl14WN,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: ()  =>    controller.login(),//Get.to(() =>  ExpensesMenuView())// controller.login(),
                              ),

                          // Checkbox + terms
                          Obx(() => Row(
                                children: [
                                  Checkbox(
                                    value: controller.isChecked.value,
                                    onChanged: (v) =>
                                        controller.isChecked.value = v!,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'I agree to the ',
                                      style: kTxtStl11N,
                                      children: [
                                        TextSpan(
                                          text: "Terms and Conditions ",
                                          style:  TextStyle(
                                              color: kAppColor,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => controller.openUrl(
                                                "https://www.systemxs.ai/terms-conditions/"),
                                        ),
                                        const TextSpan(text: "and "),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style:  TextStyle(
                                              color: kAppColor,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => controller.openUrl(
                                                "https://www.systemxs.ai/privacy-policy/"),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),

                          Obx(() => Text("Ver. ${controller.currentVersion.value}",
                              style: kTxtStl12GreyN)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
