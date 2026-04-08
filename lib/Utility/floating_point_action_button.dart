import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    this.isExtended = true,
    this.title,
    required this.icon,
    required this.function,
  });

  final bool isExtended;
  final String? title;
  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: isExtended
          ? ((title ?? '').length * 15)
          : icon.size,   
      child: FloatingActionButton.extended(
        shape: isExtended
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              )
            : const CircleBorder(),
        icon: icon,
        backgroundColor: Get.theme.colorScheme.secondary,  // GetX theme
        onPressed: () => function(),
        isExtended: isExtended,
        label: Text(
          title ?? '',
          style: kTxtStl16B,
        ),
      ),
    );
  }
}
