
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class MenuCardView extends StatelessWidget {
  final Widget image;
  final String title;
  final Function function;

  const MenuCardView({
    super.key,
    required this.image,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        function();
      },
      child: SizedBox(
        width: size.width * 0.21,
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Prevent unbounded height crash
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              
              shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                         side: const BorderSide(
                  color: Colors.orangeAccent, // ✅ Yellow border
                  width: 2.0,           // Border thickness
                ),),
              child: Container(
                height: size.height * 0.08,
                width: size.width * 0.5,
                padding: const EdgeInsets.all(8.0),
                child: image,
              ),
            ),
            const SizedBox(height: 2), // spacing
            // Text(
            //   title,
            //   style: kTxtStl12N,
            //   textAlign: TextAlign.center,
            // ),
            Text(
        title,
        style: kTxtStl10N,
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
      ),
          ],
        ),
      ),
    );
  }
}
