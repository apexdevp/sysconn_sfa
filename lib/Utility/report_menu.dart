import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class ReportMenu extends StatelessWidget {
  final String title;
  final Function function;
  const ReportMenu({super.key,required this.title,required this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,style: kTxtStl14N,),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_sharp,color: kIconColor,)
              ],
            ),
          ),
          onTap: (){
            function();
          },
        ),
        Divider(
          // height: 3,
          color: kIconColor,
        )
      ],
    );
  }
}