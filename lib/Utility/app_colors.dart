import 'package:flutter/material.dart';

Color kAppColor = const Color.fromRGBO(117, 40, 142, 1);//Colors.purple.shade200;
Color kLightAppColor = Colors.orange.shade200;
Color kContrastDarkColor = Colors.orange;
Color kBackgroundColor = Colors.grey.shade100;
Color kGreyColor = Colors.grey.shade300;
Color kIconColor = Colors.grey;
Color kNewColor = const Color.fromARGB(249, 223, 156, 146);
Color kAppNewColor = const Color.fromRGBO(239,243,250,1);//pratiksha p 18-08-2024 add
Color kAppIconColor = Colors.red.shade700;// const Color.fromARGB(255, 190, 86, 25);// const Color.fromRGBO(134, 36, 35, 1);//Colors.black;//pratiksha p 18-08-2024 add
Color kHeaderBckColor = Colors.grey.shade200;
Color kContrastLightColor = Colors.orange.shade100;
LinearGradient kButtonColor =  LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
                                  
       Color.fromARGB(255, 224, 94, 7),
       Colors.red.shade700,
    // Color.fromRGBO(134, 36, 35, 1),//pratiksha p 31-01-2025 change opacity as in new version  color was showing white
    // Color.fromRGBO(226, 121, 105, 1),
    // Color.fromRGBO(143, 46, 42, 1),
    // Color.fromRGBO(231, 126, 109, 1),
    // Color.fromRGBO(134, 36, 35, 1)
  ]
);

LinearGradient kblackButtonColor = LinearGradient(
  colors: [
    Colors.black,
    //Colors.black,
    Colors.grey.shade600,
    //Colors.black,
    Colors.black
  ],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  // stops: [
  //   0.3,0.7,1
  // ]
);
LinearGradient kColor = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
   Color.fromRGBO(117, 148, 219, 0.965),
   Color.fromRGBO(102, 75, 170, 1),
   Color.fromRGBO(117, 40, 142, 1)
   ]
);
Color kcPrimary = Color(0xff2B2926);
const Color kcSecondary = Color(0xFF3f3c39);
const Color kcDark = Color(0xFF414141);
const Color kcGray = Color(0xffcdcdcd);