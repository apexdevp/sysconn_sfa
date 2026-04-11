import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {
  final double? height;
  final Color? color;

  const LoadingIcon({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/loading.gif',
      height: height ?? 14.0,
      color: color,
    );
  }
}
