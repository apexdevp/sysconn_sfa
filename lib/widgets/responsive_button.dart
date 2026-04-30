

import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  final String title;
  final Function function;
  const ResponsiveButton({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                // padding: EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),  
                  // gradient:kblackButtonColor //kButtonColor,   //Askshay - button design and color change as per vishal sir
                  color : Colors.black,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                function();
              },
            ),
          ),
        ],
      ),
    );
  }
}
