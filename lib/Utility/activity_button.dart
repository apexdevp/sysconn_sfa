import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class ActivityButton extends StatelessWidget {
  final String title;
  final Function function;
  const ActivityButton({super.key,required this.title,required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)
          ),
          side: BorderSide(
            color: kAppColor,
            width: 2
          ),
          // backgroundColor: kAppColor,
          foregroundColor: Colors.black,
          elevation: 2
        ),
        onPressed: (){
          function();
        }, 
        child: Text(title,style: kTxtStl13B,)
      ),
    );
  }
}