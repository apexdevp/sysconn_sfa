import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class ReportMenuView extends StatelessWidget {
  final String title;
  final Function function;

  const ReportMenuView({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
        side: const BorderSide(color: Colors.black),
      ),
      elevation: 2.0,
      shadowColor: Colors.cyan.shade200,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 13, 4, 13),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.2,
                height: size.height * 0.04,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kButtonColor, //kColor
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Colors.white,
                  ),
                ), //child,
              ),
              Flexible(
                child: Column(children: [Text(title, style: kTxtStl14N)]),
              ),
            ],
          ),
        ),
        onTap: () {
          function();
        },
      ),
    );
  }
}
