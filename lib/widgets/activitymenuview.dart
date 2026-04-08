import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class ActivityMenuView extends StatelessWidget {
  final Widget child;
  final String title;
  final Function function;

  const ActivityMenuView({
    super.key,
    required this.child,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      child: SizedBox(
        width: size.width * 0.2,
        child: Column(
          children: [
            CircleAvatar(
              radius: size.height * 0.03,
              backgroundColor: Colors.grey.shade200,
              child: Container(
                height: size.height * 0.04,
                width: size.width * 0.1,
                padding: const EdgeInsets.all(1.0),
                child: child,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: kTxtStl12N, textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        function();
      },
    );
  }
}
