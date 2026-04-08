import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage(ImageList.nodataImage),
          height: 85,
          width: 100,
        ),
        Text('No data found', style: kTxtStl13GreyB),
      ],
    );
  }
}
